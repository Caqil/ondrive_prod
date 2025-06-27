import 'package:ride_hailing_shared/src/protocol/notifications/notification.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'dart:typed_data';

part 'websocket_message.g.dart';

@JsonSerializable()
class WebSocketMessage extends SerializableEntity {
  @override
  int? id;

  String type;
  dynamic data;
  String? messageId;
  DateTime timestamp;
  int? userId;
  String? room;
  Map<String, dynamic>? metadata;
  bool requiresAck;
  String? correlationId;

  WebSocketMessage({
    this.id,
    required this.type,
    this.data,
    this.messageId,
    required this.timestamp,
    this.userId,
    this.room,
    this.metadata,
    this.requiresAck = false,
    this.correlationId,
  });

  factory WebSocketMessage.create({
    required String type,
    dynamic data,
    int? userId,
    String? room,
    Map<String, dynamic>? metadata,
    bool requiresAck = false,
    String? correlationId,
  }) {
    return WebSocketMessage(
      type: type,
      data: data,
      messageId: _generateMessageId(),
      timestamp: DateTime.now(),
      userId: userId,
      room: room,
      metadata: metadata,
      requiresAck: requiresAck,
      correlationId: correlationId,
    );
  }

  // Ride-related message factory methods
  factory WebSocketMessage.rideRequested({
    required Map<String, dynamic> rideData,
    required int passengerId,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'ride_requested',
      data: rideData,
      userId: passengerId,
      requiresAck: true,
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.rideAccepted({
    required String rideId,
    required int driverId,
    required Map<String, dynamic> driverData,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'ride_accepted',
      data: {
        'rideId': rideId,
        'driverId': driverId,
        'driver': driverData,
      },
      room: 'ride_$rideId',
      requiresAck: true,
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.rideStatusUpdate({
    required String rideId,
    required String status,
    Map<String, dynamic>? additionalData,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'ride_status_update',
      data: {
        'rideId': rideId,
        'status': status,
        ...?additionalData,
      },
      room: 'ride_$rideId',
      correlationId: correlationId,
    );
  }

  // Location-related message factory methods
  factory WebSocketMessage.locationUpdate({
    required double latitude,
    required double longitude,
    int? userId,
    String? rideId,
    Map<String, dynamic>? additionalData,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'location_update',
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'rideId': rideId,
        ...?additionalData,
      },
      userId: userId,
      room: rideId != null ? 'ride_$rideId' : null,
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.etaUpdate({
    required String rideId,
    required int etaSeconds,
    required double distanceMeters,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'eta_update',
      data: {
        'rideId': rideId,
        'etaSeconds': etaSeconds,
        'distanceMeters': distanceMeters,
      },
      room: 'ride_$rideId',
      correlationId: correlationId,
    );
  }

  // Negotiation-related message factory methods
  factory WebSocketMessage.fareOffer({
    required String negotiationId,
    required double amount,
    required int fromUserId,
    String? message,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'fare_offer',
      data: {
        'negotiationId': negotiationId,
        'amount': amount,
        'fromUserId': fromUserId,
        'message': message,
      },
      requiresAck: true,
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.fareAccepted({
    required String negotiationId,
    required double finalAmount,
    required int acceptedBy,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'fare_accepted',
      data: {
        'negotiationId': negotiationId,
        'finalAmount': finalAmount,
        'acceptedBy': acceptedBy,
      },
      requiresAck: true,
      correlationId: correlationId,
    );
  }

  // Chat-related message factory methods
  factory WebSocketMessage.chatMessage({
    required String rideId,
    required String message,
    required int fromUserId,
    MessageType messageType = MessageType.text,
    String? mediaUrl,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'chat_message',
      data: {
        'rideId': rideId,
        'message': message,
        'fromUserId': fromUserId,
        'messageType': messageType.toString(),
        'mediaUrl': mediaUrl,
      },
      room: 'ride_$rideId',
      requiresAck: true,
      correlationId: correlationId,
    );
  }

  // System message factory methods
  factory WebSocketMessage.ping({String? correlationId}) {
    return WebSocketMessage.create(
      type: 'ping',
      data: {'timestamp': DateTime.now().millisecondsSinceEpoch},
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.pong({String? correlationId}) {
    return WebSocketMessage.create(
      type: 'pong',
      data: {'timestamp': DateTime.now().millisecondsSinceEpoch},
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.ack({
    required String originalMessageId,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'ack',
      data: {'originalMessageId': originalMessageId},
      correlationId: correlationId,
    );
  }

  factory WebSocketMessage.error({
    required String errorMessage,
    String? errorCode,
    String? originalMessageId,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'error',
      data: {
        'error': errorMessage,
        'errorCode': errorCode,
        'originalMessageId': originalMessageId,
      },
      correlationId: correlationId,
    );
  }

  // Notification-related message factory methods
  factory WebSocketMessage.notification({
    required String title,
    required String body,
    NotificationType notificationType = NotificationType.other,
    Map<String, dynamic>? additionalData,
    int? targetUserId,
    String? correlationId,
  }) {
    return WebSocketMessage.create(
      type: 'notification',
      data: {
        'title': title,
        'body': body,
        'notificationType': notificationType.toString(),
        'targetUserId': targetUserId,
        ...?additionalData,
      },
      userId: targetUserId,
      correlationId: correlationId,
    );
  }

  // Utility methods
  Uint8List toBytes() {
    final jsonString = jsonEncode(toJson());
    return Uint8List.fromList(utf8.encode(jsonString));
  }

  static WebSocketMessage fromBytes(ByteData bytes) {
    final jsonString = utf8.decode(bytes.buffer.asUint8List());
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return WebSocketMessage.fromJson(jsonMap);
  }

  static String _generateMessageId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_randomString(8)}';
  }

  static String _randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var result = '';
    for (var i = 0; i < length; i++) {
      result += chars[(random + i) % chars.length];
    }
    return result;
  }

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketMessageToJson(this);
}

enum MessageType {
  text,
  image,
  audio,
  location,
  system,
}


@JsonSerializable()
class WebSocketConnectionInfo extends SerializableEntity {
  @override
  int? id;

  String connectionId;
  int userId;
  DateTime connectedAt;
  DateTime? lastPingAt;
  List<String> subscribedRooms;
  Map<String, dynamic>? metadata;
  ConnectionStatus status;

  WebSocketConnectionInfo({
    this.id,
    required this.connectionId,
    required this.userId,
    required this.connectedAt,
    this.lastPingAt,
    this.subscribedRooms = const [],
    this.metadata,
    this.status = ConnectionStatus.connected,
  });

  factory WebSocketConnectionInfo.fromJson(Map<String, dynamic> json) =>
      _$WebSocketConnectionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WebSocketConnectionInfoToJson(this);
}

enum ConnectionStatus {
  connecting,
  connected,
  disconnected,
  reconnecting,
  error,
}
