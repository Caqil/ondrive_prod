// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) =>
    WebSocketMessage(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String,
      data: json['data'],
      messageId: json['messageId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: (json['userId'] as num?)?.toInt(),
      room: json['room'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      requiresAck: json['requiresAck'] as bool? ?? false,
      correlationId: json['correlationId'] as String?,
    );

Map<String, dynamic> _$WebSocketMessageToJson(WebSocketMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'data': instance.data,
      'messageId': instance.messageId,
      'timestamp': instance.timestamp.toIso8601String(),
      'userId': instance.userId,
      'room': instance.room,
      'metadata': instance.metadata,
      'requiresAck': instance.requiresAck,
      'correlationId': instance.correlationId,
    };

WebSocketConnectionInfo _$WebSocketConnectionInfoFromJson(
        Map<String, dynamic> json) =>
    WebSocketConnectionInfo(
      id: (json['id'] as num?)?.toInt(),
      connectionId: json['connectionId'] as String,
      userId: (json['userId'] as num).toInt(),
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      lastPingAt: json['lastPingAt'] == null
          ? null
          : DateTime.parse(json['lastPingAt'] as String),
      subscribedRooms: (json['subscribedRooms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      status: $enumDecodeNullable(_$ConnectionStatusEnumMap, json['status']) ??
          ConnectionStatus.connected,
    );

Map<String, dynamic> _$WebSocketConnectionInfoToJson(
        WebSocketConnectionInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'connectionId': instance.connectionId,
      'userId': instance.userId,
      'connectedAt': instance.connectedAt.toIso8601String(),
      'lastPingAt': instance.lastPingAt?.toIso8601String(),
      'subscribedRooms': instance.subscribedRooms,
      'metadata': instance.metadata,
      'status': _$ConnectionStatusEnumMap[instance.status]!,
    };

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.connecting: 'connecting',
  ConnectionStatus.connected: 'connected',
  ConnectionStatus.disconnected: 'disconnected',
  ConnectionStatus.reconnecting: 'reconnecting',
  ConnectionStatus.error: 'error',
};
