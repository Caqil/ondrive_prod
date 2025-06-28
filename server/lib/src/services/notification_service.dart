// server/lib/src/services/notification_service.dart

import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';
import 'email_service.dart';
import 'mongodb_service.dart';
import 'websocket_service.dart';

/// Service for sending push notifications, emails, and in-app notifications
class NotificationService {
  static const String _className = 'NotificationService';

  // FCM configuration
  static String? _fcmServerKey;
  static String? _fcmSenderId;
  static const String _fcmEndpoint = 'https://fcm.googleapis.com/fcm/send';

  // SMS configuration (Twilio example)
  static String? _twilioAccountSid;
  static String? _twilioAuthToken;
  static String? _twilioPhoneNumber;

  // Notification templates
  static final Map<String, Map<String, String>> _templates = {
    'ride_request': {
      'title': 'New Ride Request',
      'body': 'You have a new ride request from {pickup_address}',
    },
    'ride_accepted': {
      'title': 'Ride Accepted',
      'body': 'Your ride has been accepted by {driver_name}',
    },
    'driver_arriving': {
      'title': 'Driver Arriving',
      'body': '{driver_name} is arriving in {eta} minutes',
    },
    'ride_started': {
      'title': 'Ride Started',
      'body': 'Your ride to {dropoff_address} has started',
    },
    'ride_completed': {
      'title': 'Ride Completed',
      'body': 'Your ride has been completed. Total fare: {total_fare}',
    },
    'payment_failed': {
      'title': 'Payment Failed',
      'body':
          'Payment for your ride failed. Please update your payment method.',
    },
  };

  /// Initialize notification service
  static void initialize({
    String? fcmServerKey,
    String? fcmSenderId,
    String? twilioAccountSid,
    String? twilioAuthToken,
    String? twilioPhoneNumber,
  }) {
    _fcmServerKey = fcmServerKey;
    _fcmSenderId = fcmSenderId;
    _twilioAccountSid = twilioAccountSid;
    _twilioAuthToken = twilioAuthToken;
    _twilioPhoneNumber = twilioPhoneNumber;
  }

  /// Send notification through multiple channels
  static Future<NotificationResult> sendNotification(
    Session session, {
    required int userId,
    required String templateKey,
    required Map<String, dynamic> templateData,
    List<NotificationChannel> channels = const [NotificationChannel.push],
    NotificationPriority priority = NotificationPriority.normal,
    DateTime? scheduledAt,
    Duration? expiresIn,
  }) async {
    try {
      session.log('$_className: Sending notification to user $userId',
          level: LogLevel.info);

      final template = _templates[templateKey];
      if (template == null) {
        throw Exception('Template not found: $templateKey');
      }

      final title = _processTemplate(template['title']!, templateData);
      final body = _processTemplate(template['body']!, templateData);

      final notification = Notification(
        userId: userId,
        title: title,
        body: body,
        type: _getNotificationTypeFromTemplate(templateKey),
        data: templateData,
        priority: priority,
        channels: channels,
        sentAt: scheduledAt ?? DateTime.now(),
        expiresAt: expiresIn != null ? DateTime.now().add(expiresIn) : null,
      );

      // Store notification in database
      final notificationId =
          await MongoDBService.storeNotification(session, notification);

      final results = <NotificationChannel, bool>{};

      // Send through each requested channel
      for (final channel in channels) {
        bool success = false;

        switch (channel) {
          case NotificationChannel.push:
            success = await _sendPushNotification(
                session, userId, title, body, templateData);
            break;
          case NotificationChannel.email:
            success = await _sendEmailNotification(
                session, userId, title, body, templateData);
            break;
          case NotificationChannel.sms:
            success =
                await _sendSmsNotification(session, userId, body, templateData);
            break;
          case NotificationChannel.inApp:
            success = await _sendInAppNotification(
                session, userId, title, body, templateData);
            break;
          case NotificationChannel.websocket:
            success = await _sendWebSocketNotification(
                session, userId, title, body, templateData);
            break;
        }

        results[channel] = success;
      }

      return NotificationResult(
        notificationId: notificationId,
        success: results.values.any((success) => success),
        channelResults: results,
        sentAt: DateTime.now(),
      );
    } catch (e, stackTrace) {
      session.log('$_className: Failed to send notification: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);

      return NotificationResult(
        notificationId: null,
        success: false,
        channelResults: {},
        sentAt: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  /// Send bulk notifications
  static Future<List<NotificationResult>> sendBulkNotifications(
    Session session, {
    required List<int> userIds,
    required String templateKey,
    required Map<String, dynamic> templateData,
    List<NotificationChannel> channels = const [NotificationChannel.push],
    NotificationPriority priority = NotificationPriority.normal,
    int batchSize = 100,
  }) async {
    final results = <NotificationResult>[];

    // Process in batches to avoid overwhelming the system
    for (int i = 0; i < userIds.length; i += batchSize) {
      final batch = userIds.skip(i).take(batchSize).toList();
      final batchResults = await Future.wait(
        batch.map((userId) => sendNotification(
              session,
              userId: userId,
              templateKey: templateKey,
              templateData: templateData,
              channels: channels,
              priority: priority,
            )),
      );
      results.addAll(batchResults);

      // Small delay between batches
      if (i + batchSize < userIds.length) {
        await Future.delayed(Duration(milliseconds: 100));
      }
    }

    return results;
  }

  /// Send targeted notification to drivers in area
  static Future<List<NotificationResult>> notifyNearbyDrivers(
    Session session, {
    required double latitude,
    required double longitude,
    required double radiusKm,
    required String templateKey,
    required Map<String, dynamic> templateData,
    RideType? rideType,
    int maxDrivers = 10,
  }) async {
    try {
      // Get nearby drivers (this would typically come from location service)
      final nearbyDrivers = await _getNearbyDrivers(
        session,
        latitude,
        longitude,
        radiusKm,
        rideType,
        maxDrivers,
      );

      if (nearbyDrivers.isEmpty) {
        session.log('$_className: No nearby drivers found',
            level: LogLevel.info);
        return [];
      }

      return await sendBulkNotifications(
        session,
        userIds: nearbyDrivers,
        templateKey: templateKey,
        templateData: templateData,
        channels: [NotificationChannel.push, NotificationChannel.websocket],
        priority: NotificationPriority.high,
      );
    } catch (e) {
      session.log('$_className: Failed to notify nearby drivers: $e',
          level: LogLevel.error);
      return [];
    }
  }

  /// Send ride status update notification
  static Future<NotificationResult> sendRideStatusNotification(
    Session session, {
    required int userId,
    required String rideId,
    required RideStatus status,
    Map<String, dynamic>? additionalData,
  }) async {
    final templateKey = _getRideStatusTemplate(status);
    final templateData = {
      'ride_id': rideId,
      'status': status.toString(),
      ...?additionalData,
    };

    return await sendNotification(
      session,
      userId: userId,
      templateKey: templateKey,
      templateData: templateData,
      channels: [
        NotificationChannel.push,
        NotificationChannel.inApp,
        NotificationChannel.websocket,
      ],
      priority: NotificationPriority.high,
    );
  }

  /// Send payment notification
  static Future<NotificationResult> sendPaymentNotification(
    Session session, {
    required int userId,
    required PaymentStatus paymentStatus,
    required double amount,
    String? rideId,
    Map<String, dynamic>? additionalData,
  }) async {
    String templateKey;
    switch (paymentStatus) {
      case PaymentStatus.completed:
        templateKey = 'payment_completed';
        break;
      case PaymentStatus.failed:
        templateKey = 'payment_failed';
        break;
      case PaymentStatus.refunded:
        templateKey = 'payment_refunded';
        break;
      default:
        templateKey = 'payment_update';
    }

    final templateData = {
      'amount': amount.toStringAsFixed(2),
      'status': paymentStatus.toString(),
      'ride_id': rideId,
      ...?additionalData,
    };

    return await sendNotification(
      session,
      userId: userId,
      templateKey: templateKey,
      templateData: templateData,
      channels: [
        NotificationChannel.push,
        NotificationChannel.email,
        NotificationChannel.inApp,
      ],
      priority: paymentStatus == PaymentStatus.failed
          ? NotificationPriority.high
          : NotificationPriority.normal,
    );
  }

  /// Get user notification preferences
  static Future<NotificationPreference?> getUserNotificationPreferences(
    Session session,
    int userId,
  ) async {
    try {
      // This would typically fetch from database
      // For now, return default preferences
      return NotificationPreference(
        userId: userId,
        pushEnabled: true,
        emailEnabled: true,
        smsEnabled: false,
        inAppEnabled: true,
        rideUpdates: true,
        promotions: false,
        quietHoursStart: 22,
        quietHoursEnd: 7,
      );
    } catch (e) {
      session.log('$_className: Failed to get notification preferences: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Update user notification preferences
  static Future<bool> updateNotificationPreferences(
    Session session, {
    required int userId,
    required NotificationPreference preferences,
  }) async {
    try {
      // This would typically update in database
      session.log(
          '$_className: Updated notification preferences for user $userId',
          level: LogLevel.info);
      return true;
    } catch (e) {
      session.log('$_className: Failed to update notification preferences: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Mark notifications as read
  static Future<bool> markNotificationsAsRead(
    Session session, {
    required int userId,
    List<String>? notificationIds,
  }) async {
    try {
      if (notificationIds != null) {
        // Mark specific notifications as read
        for (final notificationId in notificationIds) {
          await MongoDBService.markNotificationAsRead(session, notificationId);
        }
      } else {
        // Mark all user notifications as read
        final notifications = await MongoDBService.getUserNotifications(
          session,
          userId: userId,
          isRead: false,
        );

        for (final notification in notifications) {
          if (notification.id != null) {
            await MongoDBService.markNotificationAsRead(
                session, notification.id!);
          }
        }
      }

      return true;
    } catch (e) {
      session.log('$_className: Failed to mark notifications as read: $e',
          level: LogLevel.error);
      return false;
    }
  }

  // Private helper methods

  static Future<bool> _sendPushNotification(
    Session session,
    int userId,
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      if (_fcmServerKey == null) {
        session.log('$_className: FCM not configured', level: LogLevel.warning);
        return false;
      }

      // Get user's FCM token (this would typically come from database)
      final fcmToken = await _getUserFCMToken(session, userId);
      if (fcmToken == null) {
        session.log('$_className: No FCM token for user $userId',
            level: LogLevel.warning);
        return false;
      }

      final payload = {
        'to': fcmToken,
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
          'badge': 1,
        },
        'data': {
          ...data.map((key, value) => MapEntry(key, value.toString())),
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
        'android': {
          'priority': 'high',
          'notification': {
            'channel_id': 'ride_updates',
            'icon': 'ic_notification',
            'color': '#007bff',
          },
        },
        'apns': {
          'payload': {
            'aps': {
              'alert': {
                'title': title,
                'body': body,
              },
              'badge': 1,
              'sound': 'default',
            },
          },
        },
      };

      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Authorization': 'key=$_fcmServerKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == 1) {
          session.log('$_className: Push notification sent successfully',
              level: LogLevel.info);
          return true;
        } else {
          session.log('$_className: FCM error: ${responseData['results']}',
              level: LogLevel.error);
          return false;
        }
      } else {
        session.log(
            '$_className: FCM HTTP error: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e) {
      session.log('$_className: Push notification error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<bool> _sendEmailNotification(
    Session session,
    int userId,
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      // Get user email (this would typically come from database)
      final userEmail = await _getUserEmail(session, userId);
      if (userEmail == null) {
        session.log('$_className: No email for user $userId',
            level: LogLevel.warning);
        return false;
      }

      return await EmailService.sendEmail(
        session,
        to: userEmail,
        subject: title,
        htmlContent: _buildEmailTemplate(title, body, data),
        textContent: body,
      );
    } catch (e) {
      session.log('$_className: Email notification error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<bool> _sendSmsNotification(
    Session session,
    int userId,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      if (_twilioAccountSid == null || _twilioAuthToken == null) {
        session.log('$_className: SMS not configured', level: LogLevel.warning);
        return false;
      }

      // Get user phone number (this would typically come from database)
      final userPhone = await _getUserPhone(session, userId);
      if (userPhone == null) {
        session.log('$_className: No phone number for user $userId',
            level: LogLevel.warning);
        return false;
      }

      // Send SMS via Twilio (simplified implementation)
      final auth =
          base64Encode(utf8.encode('$_twilioAccountSid:$_twilioAuthToken'));

      final response = await http.post(
        Uri.parse(
            'https://api.twilio.com/2010-04-01/Accounts/$_twilioAccountSid/Messages.json'),
        headers: {
          'Authorization': 'Basic $auth',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': _twilioPhoneNumber!,
          'To': userPhone,
          'Body': body,
        },
      );

      if (response.statusCode == 201) {
        session.log('$_className: SMS sent successfully', level: LogLevel.info);
        return true;
      } else {
        session.log(
            '$_className: SMS error: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e) {
      session.log('$_className: SMS notification error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<bool> _sendInAppNotification(
    Session session,
    int userId,
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      // In-app notifications are typically handled by storing in database
      // and delivering when user opens the app
      session.log('$_className: In-app notification stored for user $userId',
          level: LogLevel.info);
      return true;
    } catch (e) {
      session.log('$_className: In-app notification error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<bool> _sendWebSocketNotification(
    Session session,
    int userId,
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    try {
      final message = WebSocketMessage.notification(
        title: title,
        body: body,
        targetUserId: userId,
        additionalData: data,
      );

      await WebSocketService.sendToUser(session, userId, message);
      return true;
    } catch (e) {
      session.log('$_className: WebSocket notification error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static String _processTemplate(String template, Map<String, dynamic> data) {
    String processed = template;

    data.forEach((key, value) {
      processed = processed.replaceAll('{$key}', value.toString());
    });

    return processed;
  }

  static NotificationType _getNotificationTypeFromTemplate(String templateKey) {
    if (templateKey.startsWith('ride_')) {
      return NotificationType.rideUpdate;
    } else if (templateKey.startsWith('payment_')) {
      return NotificationType.payment;
    } else if (templateKey.startsWith('promo_')) {
      return NotificationType.promotion;
    }
    return NotificationType.other;
  }

  static String _getRideStatusTemplate(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return 'ride_request';
      case RideStatus.accepted:
        return 'ride_accepted';
      case RideStatus.driverArriving:
        return 'driver_arriving';
      case RideStatus.inProgress:
        return 'ride_started';
      case RideStatus.completed:
        return 'ride_completed';
      case RideStatus.cancelled:
        return 'ride_cancelled';
      default:
        return 'ride_update';
    }
  }

  static String _buildEmailTemplate(
      String title, String body, Map<String, dynamic> data) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <title>$title</title>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: #007bff; color: white; padding: 20px; text-align: center; }
          .content { padding: 20px; background: #f9f9f9; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>$title</h1>
          </div>
          <div class="content">
            <p>$body</p>
          </div>
        </div>
      </body>
      </html>
    ''';
  }

  static Future<String?> _getUserFCMToken(Session session, int userId) async {
    // This would typically query the database for user's FCM token
    return null;
  }

  static Future<String?> _getUserEmail(Session session, int userId) async {
    // This would typically query the database for user's email
    return null;
  }

  static Future<String?> _getUserPhone(Session session, int userId) async {
    // This would typically query the database for user's phone number
    return null;
  }

  static Future<List<int>> _getNearbyDrivers(
    Session session,
    double latitude,
    double longitude,
    double radiusKm,
    RideType? rideType,
    int maxDrivers,
  ) async {
    // This would typically use the location service to find nearby drivers
    return [];
  }
}

/// Result of a notification send operation
class NotificationResult {
  final String? notificationId;
  final bool success;
  final Map<NotificationChannel, bool> channelResults;
  final DateTime sentAt;
  final String? error;

  NotificationResult({
    required this.notificationId,
    required this.success,
    required this.channelResults,
    required this.sentAt,
    this.error,
  });
}
