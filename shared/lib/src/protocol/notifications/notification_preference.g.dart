// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreference _$NotificationPreferenceFromJson(
        Map<String, dynamic> json) =>
    NotificationPreference(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled:
          json['smsNotificationsEnabled'] as bool? ?? false,
      inAppNotificationsEnabled:
          json['inAppNotificationsEnabled'] as bool? ?? true,
      typePreferences: (json['typePreferences'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                $enumDecode(_$NotificationTypeEnumMap, k),
                NotificationChannelSettings.fromJson(
                    e as Map<String, dynamic>)),
          ) ??
          const {},
      mutedHours: (json['mutedHours'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      weekendNotifications: json['weekendNotifications'] as bool? ?? true,
      locationBasedNotifications:
          json['locationBasedNotifications'] as bool? ?? true,
      timezone: json['timezone'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      quietHours: json['quietHours'] == null
          ? null
          : QuietHoursSettings.fromJson(
              json['quietHours'] as Map<String, dynamic>),
      pushSettings: json['pushSettings'] == null
          ? null
          : PushNotificationSettings.fromJson(
              json['pushSettings'] as Map<String, dynamic>),
      emailSettings: json['emailSettings'] == null
          ? null
          : EmailNotificationSettings.fromJson(
              json['emailSettings'] as Map<String, dynamic>),
      smsSettings: json['smsSettings'] == null
          ? null
          : SmsNotificationSettings.fromJson(
              json['smsSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationPreferenceToJson(
        NotificationPreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'smsNotificationsEnabled': instance.smsNotificationsEnabled,
      'inAppNotificationsEnabled': instance.inAppNotificationsEnabled,
      'typePreferences': instance.typePreferences
          .map((k, e) => MapEntry(_$NotificationTypeEnumMap[k]!, e)),
      'mutedHours': instance.mutedHours,
      'weekendNotifications': instance.weekendNotifications,
      'locationBasedNotifications': instance.locationBasedNotifications,
      'timezone': instance.timezone,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'quietHours': instance.quietHours,
      'pushSettings': instance.pushSettings,
      'emailSettings': instance.emailSettings,
      'smsSettings': instance.smsSettings,
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

NotificationChannelSettings _$NotificationChannelSettingsFromJson(
        Map<String, dynamic> json) =>
    NotificationChannelSettings(
      id: (json['id'] as num?)?.toInt(),
      isEnabled: json['isEnabled'] as bool? ?? true,
      enabledChannels: (json['enabledChannels'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$NotificationChannelEnumMap, e))
              .toList() ??
          const [],
      minimumPriority: $enumDecodeNullable(
              _$NotificationPriorityEnumMap, json['minimumPriority']) ??
          NotificationPriority.normal,
      respectQuietHours: json['respectQuietHours'] as bool? ?? true,
      customSettings: json['customSettings'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NotificationChannelSettingsToJson(
        NotificationChannelSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isEnabled': instance.isEnabled,
      'enabledChannels': instance.enabledChannels
          .map((e) => _$NotificationChannelEnumMap[e]!)
          .toList(),
      'minimumPriority':
          _$NotificationPriorityEnumMap[instance.minimumPriority]!,
      'respectQuietHours': instance.respectQuietHours,
      'customSettings': instance.customSettings,
    };

const _$NotificationChannelEnumMap = {
  NotificationChannel.push: 'push',
  NotificationChannel.email: 'email',
  NotificationChannel.sms: 'sms',
  NotificationChannel.inApp: 'inApp',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};

QuietHoursSettings _$QuietHoursSettingsFromJson(Map<String, dynamic> json) =>
    QuietHoursSettings(
      id: (json['id'] as num?)?.toInt(),
      enabled: json['enabled'] as bool? ?? false,
      startTime: TimeOfDay.fromJson(json['startTime'] as Map<String, dynamic>),
      endTime: TimeOfDay.fromJson(json['endTime'] as Map<String, dynamic>),
      activeDays: (json['activeDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [1, 2, 3, 4, 5, 6, 7],
      allowUrgentNotifications:
          json['allowUrgentNotifications'] as bool? ?? true,
      exemptTypes: (json['exemptTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$NotificationTypeEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuietHoursSettingsToJson(QuietHoursSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enabled': instance.enabled,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'activeDays': instance.activeDays,
      'allowUrgentNotifications': instance.allowUrgentNotifications,
      'exemptTypes': instance.exemptTypes
          .map((e) => _$NotificationTypeEnumMap[e]!)
          .toList(),
    };

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) => TimeOfDay(
      id: (json['id'] as num?)?.toInt(),
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$TimeOfDayToJson(TimeOfDay instance) => <String, dynamic>{
      'id': instance.id,
      'hour': instance.hour,
      'minute': instance.minute,
    };

PushNotificationSettings _$PushNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    PushNotificationSettings(
      id: (json['id'] as num?)?.toInt(),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      badgeEnabled: json['badgeEnabled'] as bool? ?? true,
      customSound: json['customSound'] as String?,
      style: $enumDecodeNullable(_$NotificationStyleEnumMap, json['style']) ??
          NotificationStyle.standard,
      showPreview: json['showPreview'] as bool? ?? true,
    );

Map<String, dynamic> _$PushNotificationSettingsToJson(
        PushNotificationSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'badgeEnabled': instance.badgeEnabled,
      'customSound': instance.customSound,
      'style': _$NotificationStyleEnumMap[instance.style]!,
      'showPreview': instance.showPreview,
    };

const _$NotificationStyleEnumMap = {
  NotificationStyle.standard: 'standard',
  NotificationStyle.minimal: 'minimal',
  NotificationStyle.detailed: 'detailed',
};

EmailNotificationSettings _$EmailNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    EmailNotificationSettings(
      id: (json['id'] as num?)?.toInt(),
      alternativeEmail: json['alternativeEmail'] as String?,
      htmlFormat: json['htmlFormat'] as bool? ?? true,
      frequency:
          $enumDecodeNullable(_$EmailFrequencyEnumMap, json['frequency']) ??
              EmailFrequency.immediate,
      includeAttachments: json['includeAttachments'] as bool? ?? true,
    );

Map<String, dynamic> _$EmailNotificationSettingsToJson(
        EmailNotificationSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alternativeEmail': instance.alternativeEmail,
      'htmlFormat': instance.htmlFormat,
      'frequency': _$EmailFrequencyEnumMap[instance.frequency]!,
      'includeAttachments': instance.includeAttachments,
    };

const _$EmailFrequencyEnumMap = {
  EmailFrequency.immediate: 'immediate',
  EmailFrequency.hourly: 'hourly',
  EmailFrequency.daily: 'daily',
  EmailFrequency.weekly: 'weekly',
  EmailFrequency.never: 'never',
};

SmsNotificationSettings _$SmsNotificationSettingsFromJson(
        Map<String, dynamic> json) =>
    SmsNotificationSettings(
      id: (json['id'] as num?)?.toInt(),
      alternativePhone: json['alternativePhone'] as String?,
      shortFormat: json['shortFormat'] as bool? ?? true,
      frequency:
          $enumDecodeNullable(_$SmsFrequencyEnumMap, json['frequency']) ??
              SmsFrequency.urgent,
    );

Map<String, dynamic> _$SmsNotificationSettingsToJson(
        SmsNotificationSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alternativePhone': instance.alternativePhone,
      'shortFormat': instance.shortFormat,
      'frequency': _$SmsFrequencyEnumMap[instance.frequency]!,
    };

const _$SmsFrequencyEnumMap = {
  SmsFrequency.immediate: 'immediate',
  SmsFrequency.urgent: 'urgent',
  SmsFrequency.daily: 'daily',
  SmsFrequency.never: 'never',
};
