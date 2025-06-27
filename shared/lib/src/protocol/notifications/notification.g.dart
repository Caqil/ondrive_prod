// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      id: (json['id'] as num?)?.toInt(),
      notificationId: json['notificationId'] as String,
      userId: (json['userId'] as num).toInt(),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      priority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['priority']) ??
          NotificationPriority.normal,
      isRead: json['isRead'] as bool? ?? false,
      isActionable: json['isActionable'] as bool? ?? false,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => NotificationAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      deepLink: json['deepLink'] as String?,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notificationId': instance.notificationId,
      'userId': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'isRead': instance.isRead,
      'isActionable': instance.isActionable,
      'actions': instance.actions,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'deepLink': instance.deepLink,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.rideRequested: 'rideRequested',
  NotificationType.rideAccepted: 'rideAccepted',
  NotificationType.rideStarted: 'rideStarted',
  NotificationType.rideCompleted: 'rideCompleted',
  NotificationType.rideCancelled: 'rideCancelled',
  NotificationType.driverArrived: 'driverArrived',
  NotificationType.fareNegotiation: 'fareNegotiation',
  NotificationType.paymentProcessed: 'paymentProcessed',
  NotificationType.paymentFailed: 'paymentFailed',
  NotificationType.refundProcessed: 'refundProcessed',
  NotificationType.documentExpiring: 'documentExpiring',
  NotificationType.documentRejected: 'documentRejected',
  NotificationType.promoCode: 'promoCode',
  NotificationType.systemMaintenance: 'systemMaintenance',
  NotificationType.securityAlert: 'securityAlert',
  NotificationType.accountUpdate: 'accountUpdate',
  NotificationType.other: 'other',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};

NotificationAction _$NotificationActionFromJson(Map<String, dynamic> json) =>
    NotificationAction(
      id: (json['id'] as num?)?.toInt(),
      actionId: json['actionId'] as String,
      label: json['label'] as String,
      type: $enumDecode(_$ActionTypeEnumMap, json['type']),
      deepLink: json['deepLink'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationActionToJson(NotificationAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionId': instance.actionId,
      'label': instance.label,
      'type': _$ActionTypeEnumMap[instance.type]!,
      'deepLink': instance.deepLink,
      'data': instance.data,
    };

const _$ActionTypeEnumMap = {
  ActionType.dismiss: 'dismiss',
  ActionType.viewRide: 'viewRide',
  ActionType.acceptRide: 'acceptRide',
  ActionType.declineRide: 'declineRide',
  ActionType.navigate: 'navigate',
  ActionType.contact: 'contact',
  ActionType.retry: 'retry',
  ActionType.other: 'other',
};
