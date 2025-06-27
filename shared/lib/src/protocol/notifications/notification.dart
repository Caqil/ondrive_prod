import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends SerializableEntity {
  @override
  int? id;

  String notificationId;
  int userId;
  NotificationType type;
  String title;
  String body;
  Map<String, dynamic>? data;
  NotificationPriority priority;
  bool isRead;
  bool isActionable;
  List<NotificationAction>? actions;
  DateTime createdAt;
  DateTime? readAt;
  DateTime? expiresAt;
  String? imageUrl;
  String? deepLink;

  Notification({
    this.id,
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.priority = NotificationPriority.normal,
    this.isRead = false,
    this.isActionable = false,
    this.actions,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
    this.imageUrl,
    this.deepLink,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}

@JsonSerializable()
class NotificationAction extends SerializableEntity {
  @override
  int? id;

  String actionId;
  String label;
  ActionType type;
  String? deepLink;
  Map<String, dynamic>? data;

  NotificationAction({
    this.id,
    required this.actionId,
    required this.label,
    required this.type,
    this.deepLink,
    this.data,
  });

  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationActionToJson(this);
}

@JsonSerializable()
class PushNotification extends SerializableEntity {
  @override
  int? id;

  String notificationId;
  List<int> targetUserIds;
  List<String>? targetDeviceTokens;
  String title;
  String body;
  Map<String, dynamic>? data;
  PushNotificationPriority priority;
  DateTime scheduledAt;
  DateTime? sentAt;
  PushNotificationStatus status;
  String? imageUrl;
  List<PushNotificationAction>? actions;

  PushNotification({
    this.id,
    required this.notificationId,
    required this.targetUserIds,
    this.targetDeviceTokens,
    required this.title,
    required this.body,
    this.data,
    this.priority = PushNotificationPriority.normal,
    required this.scheduledAt,
    this.sentAt,
    this.status = PushNotificationStatus.pending,
    this.imageUrl,
    this.actions,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}

@JsonSerializable()
class PushNotificationAction extends SerializableEntity {
  @override
  int? id;

  String actionId;
  String title;
  String? icon;
  String? deepLink;

  PushNotificationAction({
    this.id,
    required this.actionId,
    required this.title,
    this.icon,
    this.deepLink,
  });

  factory PushNotificationAction.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationActionFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationActionToJson(this);
}

@JsonSerializable()
class EmailTemplate extends SerializableEntity {
  @override
  int? id;

  String templateId;
  String name;
  String subject;
  String htmlContent;
  String? textContent;
  EmailType emailType;
  Map<String, dynamic>? defaultVariables;
  bool isActive;
  DateTime createdAt;
  DateTime? updatedAt;

  EmailTemplate({
    this.id,
    required this.templateId,
    required this.name,
    required this.subject,
    required this.htmlContent,
    this.textContent,
    required this.emailType,
    this.defaultVariables,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory EmailTemplate.fromJson(Map<String, dynamic> json) =>
      _$EmailTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$EmailTemplateToJson(this);
}

@JsonSerializable()
class NotificationPreference extends SerializableEntity {
  @override
  int? id;

  int userId;
  bool pushNotificationsEnabled;
  bool emailNotificationsEnabled;
  bool smsNotificationsEnabled;
  Map<NotificationType, bool> typePreferences;
  List<String> mutedHours; // ["22:00", "08:00"] for Do Not Disturb
  bool weekendNotifications;
  DateTime? updatedAt;

  NotificationPreference({
    this.id,
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = false,
    this.typePreferences = const {},
    this.mutedHours = const [],
    this.weekendNotifications = true,
    this.updatedAt,
  });

  bool isNotificationAllowed(NotificationType type) {
    return typePreferences[type] ?? true;
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferenceToJson(this);
}

enum NotificationType {
  rideRequested,
  rideAccepted,
  rideStarted,
  rideCompleted,
  rideCancelled,
  driverArrived,
  fareNegotiation,
  paymentProcessed,
  paymentFailed,
  refundProcessed,
  documentExpiring,
  documentRejected,
  promoCode,
  systemMaintenance,
  securityAlert,
  accountUpdate,
  other,
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

enum ActionType {
  dismiss,
  viewRide,
  acceptRide,
  declineRide,
  navigate,
  contact,
  retry,
  other,
}

enum PushNotificationPriority {
  min,
  low,
  normal,
  high,
  max,
}

enum PushNotificationStatus {
  pending,
  sent,
  delivered,
  failed,
  cancelled,
}

enum EmailType {
  verification,
  passwordReset,
  rideReceipt,
  welcome,
  promotional,
  notification,
  support,
  other,
}
