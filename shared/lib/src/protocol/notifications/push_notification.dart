import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'push_notification.g.dart';

@JsonSerializable()
class PushNotification extends SerializableEntity {
  @override
  int? id;

  String notificationId;
  List<int> targetUserIds;
  List<String>? targetDeviceTokens;
  List<String>? targetTopics; // FCM topics
  String title;
  String body;
  Map<String, dynamic>? data;
  PushNotificationPriority priority;
  DateTime scheduledAt;
  DateTime? sentAt;
  DateTime? deliveredAt;
  PushNotificationStatus status;
  String? imageUrl;
  List<PushNotificationAction>? actions;

  // Platform-specific settings
  AndroidNotificationConfig? androidConfig;
  IosNotificationConfig? iosConfig;
  WebNotificationConfig? webConfig;

  // Delivery tracking
  int targetCount;
  int sentCount;
  int deliveredCount;
  int failedCount;
  Map<String, dynamic>? deliveryMetrics;

  // Campaign info
  String? campaignId;
  String? segmentId;
  Map<String, dynamic>? campaignMetadata;

  PushNotification({
    this.id,
    required this.notificationId,
    required this.targetUserIds,
    this.targetDeviceTokens,
    this.targetTopics,
    required this.title,
    required this.body,
    this.data,
    this.priority = PushNotificationPriority.normal,
    required this.scheduledAt,
    this.sentAt,
    this.deliveredAt,
    this.status = PushNotificationStatus.pending,
    this.imageUrl,
    this.actions,
    this.androidConfig,
    this.iosConfig,
    this.webConfig,
    this.targetCount = 0,
    this.sentCount = 0,
    this.deliveredCount = 0,
    this.failedCount = 0,
    this.deliveryMetrics,
    this.campaignId,
    this.segmentId,
    this.campaignMetadata,
  });

  // Check if notification is scheduled for future
  bool get isScheduled {
    return scheduledAt.isAfter(DateTime.now());
  }

  // Check if notification was delivered
  bool get wasDelivered {
    return deliveredAt != null || status == PushNotificationStatus.delivered;
  }

  // Get delivery rate percentage
  double get deliveryRate {
    if (targetCount == 0) return 0.0;
    return (deliveredCount / targetCount) * 100;
  }

  // Get failure rate percentage
  double get failureRate {
    if (targetCount == 0) return 0.0;
    return (failedCount / targetCount) * 100;
  }

  // Create FCM message payload
  Map<String, dynamic> toFcmPayload() {
    final payload = <String, dynamic>{
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'notificationId': notificationId,
        'priority': priority.toString(),
        ...?data,
      },
    };

    if (imageUrl != null) {
      payload['notification']['image'] = imageUrl;
    }

    if (androidConfig != null) {
      payload['android'] = androidConfig!.toFcmAndroid();
    }

    if (iosConfig != null) {
      payload['apns'] = iosConfig!.toFcmApns();
    }

    if (webConfig != null) {
      payload['webpush'] = webConfig!.toFcmWebpush();
    }

    return payload;
  }

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
  bool bringAppToForeground;
  Map<String, dynamic>? actionData;

  PushNotificationAction({
    this.id,
    required this.actionId,
    required this.title,
    this.icon,
    this.deepLink,
    this.bringAppToForeground = true,
    this.actionData,
  });

  factory PushNotificationAction.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationActionFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationActionToJson(this);
}

@JsonSerializable()
class AndroidNotificationConfig extends SerializableEntity {
  @override
  int? id;

  String? channelId;
  String? sound;
  String? icon;
  String? color;
  String? tag;
  bool? sticky;
  AndroidPriority? priority;
  AndroidVisibility? visibility;
  int? badgeCount;
  Map<String, dynamic>? customData;

  AndroidNotificationConfig({
    this.id,
    this.channelId,
    this.sound,
    this.icon,
    this.color,
    this.tag,
    this.sticky,
    this.priority,
    this.visibility,
    this.badgeCount,
    this.customData,
  });

  Map<String, dynamic> toFcmAndroid() {
    final config = <String, dynamic>{};

    if (channelId != null) config['channel_id'] = channelId;
    if (sound != null) config['sound'] = sound;
    if (icon != null) config['icon'] = icon;
    if (color != null) config['color'] = color;
    if (tag != null) config['tag'] = tag;
    if (sticky != null) config['sticky'] = sticky;
    if (priority != null)
      config['priority'] = priority.toString().split('.').last;
    if (visibility != null)
      config['visibility'] = visibility.toString().split('.').last;

    return {'notification': config};
  }

  factory AndroidNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$AndroidNotificationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AndroidNotificationConfigToJson(this);
}

@JsonSerializable()
class IosNotificationConfig extends SerializableEntity {
  @override
  int? id;

  String? sound;
  int? badge;
  bool? contentAvailable;
  bool? mutableContent;
  String? category;
  String? threadId;
  Map<String, dynamic>? customData;

  IosNotificationConfig({
    this.id,
    this.sound,
    this.badge,
    this.contentAvailable,
    this.mutableContent,
    this.category,
    this.threadId,
    this.customData,
  });

  Map<String, dynamic> toFcmApns() {
    final aps = <String, dynamic>{};

    if (sound != null) aps['sound'] = sound;
    if (badge != null) aps['badge'] = badge;
    if (contentAvailable != null)
      aps['content-available'] = contentAvailable! ? 1 : 0;
    if (mutableContent != null)
      aps['mutable-content'] = mutableContent! ? 1 : 0;
    if (category != null) aps['category'] = category;
    if (threadId != null) aps['thread-id'] = threadId;

    return {
      'payload': {
        'aps': aps,
        ...?customData,
      },
    };
  }

  factory IosNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$IosNotificationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$IosNotificationConfigToJson(this);
}

@JsonSerializable()
class WebNotificationConfig extends SerializableEntity {
  @override
  int? id;

  String? icon;
  String? badge;
  String? image;
  String? tag;
  bool? requireInteraction;
  bool? silent;
  int? ttl; // Time to live in seconds
  Map<String, dynamic>? customData;

  WebNotificationConfig({
    this.id,
    this.icon,
    this.badge,
    this.image,
    this.tag,
    this.requireInteraction,
    this.silent,
    this.ttl,
    this.customData,
  });

  Map<String, dynamic> toFcmWebpush() {
    final config = <String, dynamic>{};

    if (icon != null) config['icon'] = icon;
    if (badge != null) config['badge'] = badge;
    if (image != null) config['image'] = image;
    if (tag != null) config['tag'] = tag;
    if (requireInteraction != null)
      config['require_interaction'] = requireInteraction;
    if (silent != null) config['silent'] = silent;
    if (ttl != null) config['headers'] = {'TTL': ttl.toString()};

    return {
      'notification': config,
      'data': customData,
    };
  }

  factory WebNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$WebNotificationConfigFromJson(json);
  Map<String, dynamic> toJson() => _$WebNotificationConfigToJson(this);
}

@JsonSerializable()
class NotificationDeliveryResult extends SerializableEntity {
  @override
  int? id;

  String notificationId;
  String deviceToken;
  int? userId;
  DeliveryStatus status;
  DateTime attemptedAt;
  DateTime? deliveredAt;
  String? failureReason;
  String? externalMessageId;
  Map<String, dynamic>? platformResponse;

  NotificationDeliveryResult({
    this.id,
    required this.notificationId,
    required this.deviceToken,
    this.userId,
    required this.status,
    required this.attemptedAt,
    this.deliveredAt,
    this.failureReason,
    this.externalMessageId,
    this.platformResponse,
  });

  bool get wasSuccessful => status == DeliveryStatus.delivered;
  bool get failed => status == DeliveryStatus.failed;

  factory NotificationDeliveryResult.fromJson(Map<String, dynamic> json) =>
      _$NotificationDeliveryResultFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDeliveryResultToJson(this);
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
  sending,
  sent,
  delivered,
  failed,
  cancelled,
}

enum AndroidPriority {
  min,
  low,
  normal,
  high,
  max,
}

enum AndroidVisibility {
  public,
  private,
  secret,
}

enum DeliveryStatus {
  pending,
  sent,
  delivered,
  failed,
  bounced,
}
