import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'notification.dart';

part 'notification_preference.g.dart';

@JsonSerializable()
class NotificationPreference extends SerializableEntity {
  @override
  int? id;

  int userId;
  bool pushNotificationsEnabled;
  bool emailNotificationsEnabled;
  bool smsNotificationsEnabled;
  bool inAppNotificationsEnabled;
  Map<NotificationType, NotificationChannelSettings> typePreferences;
  List<String> mutedHours; // ["22:00", "08:00"] for Do Not Disturb
  bool weekendNotifications;
  bool locationBasedNotifications;
  String? timezone;
  DateTime? updatedAt;

  // Quiet hours settings
  QuietHoursSettings? quietHours;

  // Channel-specific settings
  PushNotificationSettings? pushSettings;
  EmailNotificationSettings? emailSettings;
  SmsNotificationSettings? smsSettings;

  NotificationPreference({
    this.id,
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = false,
    this.inAppNotificationsEnabled = true,
    this.typePreferences = const {},
    this.mutedHours = const [],
    this.weekendNotifications = true,
    this.locationBasedNotifications = true,
    this.timezone,
    this.updatedAt,
    this.quietHours,
    this.pushSettings,
    this.emailSettings,
    this.smsSettings,
  });

  // Check if notification type is allowed
  bool isNotificationAllowed(NotificationType type) {
    final settings = typePreferences[type];
    if (settings == null) return true;

    return settings.isEnabled;
  }

  // Check if specific channel is allowed for notification type
  bool isChannelAllowed(NotificationType type, NotificationChannel channel) {
    if (!isNotificationAllowed(type)) return false;

    final settings = typePreferences[type];
    if (settings == null) {
      // Default channel preferences
      switch (channel) {
        case NotificationChannel.push:
          return pushNotificationsEnabled;
        case NotificationChannel.email:
          return emailNotificationsEnabled;
        case NotificationChannel.sms:
          return smsNotificationsEnabled;
        case NotificationChannel.inApp:
          return inAppNotificationsEnabled;
      }
    }

    return settings.enabledChannels.contains(channel);
  }

  // Check if current time is in quiet hours
  bool isInQuietHours() {
    if (quietHours == null || !quietHours!.enabled) return false;

    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    return quietHours!.isInQuietPeriod(currentTime);
  }

  // Check if notifications are allowed on weekends
  bool isWeekendNotificationAllowed() {
    if (!weekendNotifications) {
      final now = DateTime.now();
      return !(now.weekday == DateTime.saturday ||
          now.weekday == DateTime.sunday);
    }
    return true;
  }

  // Get notification priority threshold
  NotificationPriority getMinimumPriority(NotificationType type) {
    final settings = typePreferences[type];
    return settings?.minimumPriority ?? NotificationPriority.normal;
  }

  // Update preference for specific notification type
  void updateTypePreference(
    NotificationType type,
    NotificationChannelSettings settings,
  ) {
    final newPreferences =
        Map<NotificationType, NotificationChannelSettings>.from(
            typePreferences);
    newPreferences[type] = settings;
    // Note: In a real implementation, this would trigger an update
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferenceToJson(this);
}

@JsonSerializable()
class NotificationChannelSettings extends SerializableEntity {
  @override
  int? id;

  bool isEnabled;
  List<NotificationChannel> enabledChannels;
  NotificationPriority minimumPriority;
  bool respectQuietHours;
  Map<String, dynamic>? customSettings;

  NotificationChannelSettings({
    this.id,
    this.isEnabled = true,
    this.enabledChannels = const [],
    this.minimumPriority = NotificationPriority.normal,
    this.respectQuietHours = true,
    this.customSettings,
  });

  factory NotificationChannelSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationChannelSettingsToJson(this);
}

@JsonSerializable()
class QuietHoursSettings extends SerializableEntity {
  @override
  int? id;

  bool enabled;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<int> activeDays; // 1=Monday, 7=Sunday
  bool allowUrgentNotifications;
  List<NotificationType> exemptTypes;

  QuietHoursSettings({
    this.id,
    this.enabled = false,
    required this.startTime,
    required this.endTime,
    this.activeDays = const [1, 2, 3, 4, 5, 6, 7], // All days
    this.allowUrgentNotifications = true,
    this.exemptTypes = const [],
  });

  // Check if current time is in quiet period
  bool isInQuietPeriod(TimeOfDay currentTime) {
    if (!enabled) return false;

    final now = DateTime.now();
    if (!activeDays.contains(now.weekday)) return false;

    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    if (startMinutes <= endMinutes) {
      // Same day period (e.g., 9 AM to 5 PM)
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Overnight period (e.g., 10 PM to 6 AM)
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }

  factory QuietHoursSettings.fromJson(Map<String, dynamic> json) =>
      _$QuietHoursSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$QuietHoursSettingsToJson(this);
}

@JsonSerializable()
class TimeOfDay extends SerializableEntity {
  @override
  int? id;

  int hour; // 0-23
  int minute; // 0-59

  TimeOfDay({
    this.id,
    required this.hour,
    required this.minute,
  });

  String get formatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  factory TimeOfDay.fromJson(Map<String, dynamic> json) =>
      _$TimeOfDayFromJson(json);
  Map<String, dynamic> toJson() => _$TimeOfDayToJson(this);
}

@JsonSerializable()
class PushNotificationSettings extends SerializableEntity {
  @override
  int? id;

  bool soundEnabled;
  bool vibrationEnabled;
  bool badgeEnabled;
  String? customSound;
  NotificationStyle style;
  bool showPreview;

  PushNotificationSettings({
    this.id,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.badgeEnabled = true,
    this.customSound,
    this.style = NotificationStyle.standard,
    this.showPreview = true,
  });

  factory PushNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationSettingsToJson(this);
}

@JsonSerializable()
class EmailNotificationSettings extends SerializableEntity {
  @override
  int? id;

  String? alternativeEmail;
  bool htmlFormat;
  EmailFrequency frequency;
  bool includeAttachments;

  EmailNotificationSettings({
    this.id,
    this.alternativeEmail,
    this.htmlFormat = true,
    this.frequency = EmailFrequency.immediate,
    this.includeAttachments = true,
  });

  factory EmailNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$EmailNotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$EmailNotificationSettingsToJson(this);
}

@JsonSerializable()
class SmsNotificationSettings extends SerializableEntity {
  @override
  int? id;

  String? alternativePhone;
  bool shortFormat;
  SmsFrequency frequency;

  SmsNotificationSettings({
    this.id,
    this.alternativePhone,
    this.shortFormat = true,
    this.frequency = SmsFrequency.urgent,
  });

  factory SmsNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$SmsNotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SmsNotificationSettingsToJson(this);
}

enum NotificationChannel {
  push,
  email,
  sms,
  inApp,
}

enum NotificationStyle {
  standard,
  minimal,
  detailed,
}

enum EmailFrequency {
  immediate,
  hourly,
  daily,
  weekly,
  never,
}

enum SmsFrequency {
  immediate,
  urgent,
  daily,
  never,
}
