// server/lib/src/services/email_service.dart

import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';

/// Email service for sending notifications and transactional emails
class EmailService {
  static const String _className = 'EmailService';

  // SendGrid configuration
  static const String _sendGridApiUrl = 'https://api.sendgrid.com/v3/mail/send';
  static String? _sendGridApiKey;
  static String? _fromEmail;
  static String? _fromName;

  // SMTP configuration (fallback)
  static SmtpServer? _smtpServer;

  /// Initialize email service with configuration
  static void initialize({
    String? sendGridApiKey,
    String? fromEmail,
    String? fromName,
    SmtpServer? smtpServer,
  }) {
    _sendGridApiKey = sendGridApiKey;
    _fromEmail = fromEmail ?? 'noreply@ridehailing.com';
    _fromName = fromName ?? 'RideHailing App';
    _smtpServer = smtpServer;
  }

  /// Send email using SendGrid
  static Future<bool> sendEmail(
    Session session, {
    required String to,
    required String subject,
    required String htmlContent,
    String? textContent,
    List<String>? cc,
    List<String>? bcc,
    Map<String, String>? attachments,
    String? templateId,
    Map<String, dynamic>? templateData,
  }) async {
    try {
      session.log('$_className: Sending email to: $to, subject: $subject',
          level: LogLevel.info);

      if (_sendGridApiKey != null) {
        return await _sendViaSendGrid(
          session,
          to: to,
          subject: subject,
          htmlContent: htmlContent,
          textContent: textContent,
          cc: cc,
          bcc: bcc,
          templateId: templateId,
          templateData: templateData,
        );
      } else if (_smtpServer != null) {
        return await _sendViaSmtp(
          session,
          to: to,
          subject: subject,
          htmlContent: htmlContent,
          textContent: textContent,
          cc: cc,
          bcc: bcc,
        );
      } else {
        throw Exception('No email provider configured');
      }
    } catch (e, stackTrace) {
      session.log('$_className: Failed to send email: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Send welcome email to new users
  static Future<bool> sendWelcomeEmail(
    Session session, {
    required String to,
    required String firstName,
    required String verificationToken,
    required UserType userType,
  }) async {
    try {
      final verificationUrl = _buildVerificationUrl(verificationToken);
      final userTypeText = userType == UserType.driver ? 'Driver' : 'Passenger';

      final htmlContent = '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>Welcome to RideHailing</title>
          <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #007bff; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .button { 
              display: inline-block; 
              background: #007bff; 
              color: white; 
              padding: 12px 24px; 
              text-decoration: none; 
              border-radius: 4px; 
              margin: 20px 0;
            }
            .footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Welcome to RideHailing!</h1>
            </div>
            <div class="content">
              <h2>Hello $firstName,</h2>
              <p>Welcome to RideHailing! We're excited to have you join our community as a $userTypeText.</p>
              
              <p>To get started, please verify your email address by clicking the button below:</p>
              
              <a href="$verificationUrl" class="button">Verify Email Address</a>
              
              <p>If the button doesn't work, you can copy and paste this link into your browser:</p>
              <p><a href="$verificationUrl">$verificationUrl</a></p>
              
              <p>This verification link will expire in 24 hours for security reasons.</p>
              
              ${userType == UserType.driver ? _getDriverOnboardingContent() : _getPassengerOnboardingContent()}
              
              <p>If you have any questions, feel free to contact our support team.</p>
              
              <p>Best regards,<br>The RideHailing Team</p>
            </div>
            <div class="footer">
              <p>&copy; 2024 RideHailing. All rights reserved.</p>
              <p>This email was sent to $to. If you didn't create an account, please ignore this email.</p>
            </div>
          </div>
        </body>
        </html>
      ''';

      return await sendEmail(
        session,
        to: to,
        subject: 'Welcome to RideHailing - Verify Your Email',
        htmlContent: htmlContent,
        textContent:
            'Welcome to RideHailing! Please verify your email: $verificationUrl',
      );
    } catch (e) {
      session.log('$_className: Failed to send welcome email: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Send password reset email
  static Future<bool> sendPasswordResetEmail(
    Session session, {
    required String to,
    required String firstName,
    required String resetToken,
  }) async {
    try {
      final resetUrl = _buildPasswordResetUrl(resetToken);

      final htmlContent = '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>Reset Your Password</title>
          <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #dc3545; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .button { 
              display: inline-block; 
              background: #dc3545; 
              color: white; 
              padding: 12px 24px; 
              text-decoration: none; 
              border-radius: 4px; 
              margin: 20px 0;
            }
            .warning { background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 4px; margin: 20px 0; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Password Reset Request</h1>
            </div>
            <div class="content">
              <h2>Hello $firstName,</h2>
              <p>We received a request to reset your password for your RideHailing account.</p>
              
              <p>Click the button below to reset your password:</p>
              
              <a href="$resetUrl" class="button">Reset Password</a>
              
              <p>If the button doesn't work, you can copy and paste this link into your browser:</p>
              <p><a href="$resetUrl">$resetUrl</a></p>
              
              <div class="warning">
                <strong>Security Notice:</strong>
                <ul>
                  <li>This link will expire in 1 hour for security reasons</li>
                  <li>If you didn't request this reset, please ignore this email</li>
                  <li>Never share this link with anyone</li>
                </ul>
              </div>
              
              <p>If you continue to have problems, please contact our support team.</p>
              
              <p>Best regards,<br>The RideHailing Team</p>
            </div>
            <div class="footer">
              <p>&copy; 2024 RideHailing. All rights reserved.</p>
            </div>
          </div>
        </body>
        </html>
      ''';

      return await sendEmail(
        session,
        to: to,
        subject: 'Reset Your RideHailing Password',
        htmlContent: htmlContent,
        textContent: 'Reset your password: $resetUrl',
      );
    } catch (e) {
      session.log('$_className: Failed to send password reset email: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Send ride notification email
  static Future<bool> sendRideNotificationEmail(
    Session session, {
    required String to,
    required String firstName,
    required String rideId,
    required String status,
    required Map<String, dynamic> rideDetails,
  }) async {
    try {
      final statusText = _getRideStatusText(status);
      final subject = 'Ride Update: $statusText';

      final htmlContent = '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>$subject</title>
          <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #28a745; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .ride-details { background: white; padding: 15px; border-radius: 4px; margin: 20px 0; }
            .detail-row { display: flex; justify-content: space-between; padding: 5px 0; border-bottom: 1px solid #eee; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Ride Update</h1>
            </div>
            <div class="content">
              <h2>Hello $firstName,</h2>
              <p>Your ride has been updated. Current status: <strong>$statusText</strong></p>
              
              <div class="ride-details">
                <h3>Ride Details</h3>
                <div class="detail-row">
                  <span>Ride ID:</span>
                  <span>$rideId</span>
                </div>
                ${_buildRideDetailsHtml(rideDetails)}
              </div>
              
              <p>You can track your ride in real-time through the RideHailing app.</p>
              
              <p>Thank you for choosing RideHailing!</p>
              
              <p>Best regards,<br>The RideHailing Team</p>
            </div>
          </div>
        </body>
        </html>
      ''';

      return await sendEmail(
        session,
        to: to,
        subject: subject,
        htmlContent: htmlContent,
        textContent: 'Ride $rideId status: $statusText',
      );
    } catch (e) {
      session.log('$_className: Failed to send ride notification email: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Send receipt email
  static Future<bool> sendReceiptEmail(
    Session session, {
    required String to,
    required String firstName,
    required String rideId,
    required FareBreakdown fareBreakdown,
    required Map<String, dynamic> rideDetails,
  }) async {
    try {
      final htmlContent = '''
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <title>Your Ride Receipt</title>
          <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background: #6c757d; color: white; padding: 20px; text-align: center; }
            .content { padding: 20px; background: #f9f9f9; }
            .receipt { background: white; padding: 20px; border-radius: 4px; margin: 20px 0; }
            .fare-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
            .total-row { display: flex; justify-content: space-between; padding: 15px 0; border-top: 2px solid #333; font-weight: bold; font-size: 18px; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>Ride Receipt</h1>
            </div>
            <div class="content">
              <h2>Hello $firstName,</h2>
              <p>Thank you for choosing RideHailing! Here's your receipt for ride $rideId.</p>
              
              <div class="receipt">
                <h3>Trip Details</h3>
                ${_buildRideDetailsHtml(rideDetails)}
                
                <h3>Fare Breakdown</h3>
                ${_buildFareBreakdownHtml(fareBreakdown)}
              </div>
              
              <p>We hope you had a great experience with RideHailing!</p>
              
              <p>Best regards,<br>The RideHailing Team</p>
            </div>
          </div>
        </body>
        </html>
      ''';

      return await sendEmail(
        session,
        to: to,
        subject: 'Your RideHailing Receipt - $rideId',
        htmlContent: htmlContent,
        textContent:
            'Receipt for ride $rideId. Total: \$${fareBreakdown.totalFare.toStringAsFixed(2)}',
      );
    } catch (e) {
      session.log('$_className: Failed to send receipt email: $e',
          level: LogLevel.error);
      return false;
    }
  }

  // Private helper methods

  static Future<bool> _sendViaSendGrid(
    Session session, {
    required String to,
    required String subject,
    required String htmlContent,
    String? textContent,
    List<String>? cc,
    List<String>? bcc,
    String? templateId,
    Map<String, dynamic>? templateData,
  }) async {
    try {
      final payload = {
        'personalizations': [
          {
            'to': [
              {'email': to}
            ],
            if (cc != null && cc.isNotEmpty)
              'cc': cc.map((e) => {'email': e}).toList(),
            if (bcc != null && bcc.isNotEmpty)
              'bcc': bcc.map((e) => {'email': e}).toList(),
            'subject': subject,
            if (templateData != null) 'dynamic_template_data': templateData,
          }
        ],
        'from': {
          'email': _fromEmail,
          'name': _fromName,
        },
        if (templateId != null) 'template_id': templateId,
        if (templateId == null)
          'content': [
            if (textContent != null)
              {
                'type': 'text/plain',
                'value': textContent,
              },
            {
              'type': 'text/html',
              'value': htmlContent,
            },
          ],
      };

      final response = await http.post(
        Uri.parse(_sendGridApiUrl),
        headers: {
          'Authorization': 'Bearer $_sendGridApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 202) {
        session.log('$_className: Email sent successfully via SendGrid',
            level: LogLevel.info);
        return true;
      } else {
        session.log(
            '$_className: SendGrid API error: ${response.statusCode} - ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e) {
      session.log('$_className: SendGrid send error: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<bool> _sendViaSmtp(
    Session session, {
    required String to,
    required String subject,
    required String htmlContent,
    String? textContent,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    try {
      final message = Message()
        ..from = Address(_fromEmail!, _fromName)
        ..recipients.add(to)
        ..subject = subject
        ..html = htmlContent;

      if (textContent != null) {
        message.text = textContent;
      }

      if (cc != null) {
        message.ccRecipients.addAll(cc);
      }

      if (bcc != null) {
        message.bccRecipients.addAll(bcc);
      }

      final sendReport = await send(message, _smtpServer!);

      session.log('$_className: Email sent successfully via SMTP: $sendReport',
          level: LogLevel.info);
      return true;
    } catch (e) {
      session.log('$_className: SMTP send error: $e', level: LogLevel.error);
      return false;
    }
  }

  static String _buildVerificationUrl(String token) {
    // TODO: Get base URL from configuration
    return 'https://your-app.com/verify-email?token=$token';
  }

  static String _buildPasswordResetUrl(String token) {
    // TODO: Get base URL from configuration
    return 'https://your-app.com/reset-password?token=$token';
  }

  static String _getRideStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Ride Requested';
      case 'accepted':
        return 'Driver Assigned';
      case 'driver_arriving':
        return 'Driver En Route';
      case 'driver_arrived':
        return 'Driver Arrived';
      case 'in_progress':
        return 'Trip in Progress';
      case 'completed':
        return 'Trip Completed';
      case 'cancelled':
        return 'Trip Cancelled';
      default:
        return 'Status Updated';
    }
  }

  static String _buildRideDetailsHtml(Map<String, dynamic> details) {
    final buffer = StringBuffer();

    details.forEach((key, value) {
      final displayKey = _formatDetailKey(key);
      buffer.writeln('<div class="detail-row">');
      buffer.writeln('<span>$displayKey:</span>');
      buffer.writeln('<span>$value</span>');
      buffer.writeln('</div>');
    });

    return buffer.toString();
  }

  static String _buildFareBreakdownHtml(FareBreakdown breakdown) {
    return '''
      <div class="fare-row">
        <span>Base Fare:</span>
        <span>\$${breakdown.baseFare.toStringAsFixed(2)}</span>
      </div>
      <div class="fare-row">
        <span>Distance Fare:</span>
        <span>\$${breakdown.distanceFare.toStringAsFixed(2)}</span>
      </div>
      <div class="fare-row">
        <span>Time Fare:</span>
        <span>\$${breakdown.timeFare.toStringAsFixed(2)}</span>
      </div>
      ${breakdown.surgeFare > 0 ? '''
      <div class="fare-row">
        <span>Surge Fare:</span>
        <span>\$${breakdown.surgeFare.toStringAsFixed(2)}</span>
      </div>
      ''' : ''}
      <div class="fare-row">
        <span>Service Fee:</span>
        <span>\$${breakdown.serviceFee.toStringAsFixed(2)}</span>
      </div>
      <div class="fare-row">
        <span>Tax:</span>
        <span>\$${breakdown.additionalFees.toStringAsFixed(2)}</span>
      </div>
      ${breakdown.tips > 0 ? '''
      <div class="fare-row">
        <span>Tip:</span>
        <span>\$${breakdown.tips.toStringAsFixed(2)}</span>
      </div>
      ''' : ''}
      <div class="total-row">
        <span>Total:</span>
        <span>\$${breakdown.totalFare.toStringAsFixed(2)}</span>
      </div>
    ''';
  }

  static String _formatDetailKey(String key) {
    return key
        .split('_')
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join(' ');
  }

  static String _getDriverOnboardingContent() {
    return '''
      <div style="background: #e7f3ff; padding: 15px; border-radius: 4px; margin: 20px 0;">
        <h3>Next Steps for Drivers:</h3>
        <ol>
          <li>Complete your driver profile</li>
          <li>Upload required documents</li>
          <li>Add your vehicle information</li>
          <li>Pass the background check</li>
          <li>Start earning!</li>
        </ol>
      </div>
    ''';
  }

  static String _getPassengerOnboardingContent() {
    return '''
      <div style="background: #e7f3ff; padding: 15px; border-radius: 4px; margin: 20px 0;">
        <h3>Getting Started:</h3>
        <ol>
          <li>Complete your profile</li>
          <li>Add a payment method</li>
          <li>Set your home and work addresses</li>
          <li>Book your first ride</li>
        </ol>
      </div>
    ''';
  }
}
