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
