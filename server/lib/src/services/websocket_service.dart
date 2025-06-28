// server/lib/src/services/websocket_service.dart

import 'dart:convert';
import 'dart:async';
import 'package:serverpod/serverpod.dart' hide WebSocketMessage;
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';
import 'redis_service.dart';

/// Service for managing WebSocket connections and real-time messaging
class WebSocketService {
  static const String _className = 'WebSocketService';

  // Connection management
  static final Map<String, WebSocketConnectionInfo> _connections = {};
  static final Map<int, Set<String>> _userConnections = {};
  static final Map<String, Set<String>> _roomSubscriptions = {};

  // Configuration
  static const int _maxConnectionsPerUser = 5;
  static const Duration _pingInterval = Duration(seconds: 30);
  static const Duration _connectionTimeout = Duration(minutes: 5);
  static const int _maxMessageSize = 1024 * 1024; // 1MB

  // Timers
  static Timer? _pingTimer;
  static Timer? _cleanupTimer;

  /// Initialize WebSocket service
  static void initialize(Session session) {
    session.log('$_className: Initializing WebSocket service',
        level: LogLevel.info);

    // Start ping timer
    _pingTimer = Timer.periodic(_pingInterval, (timer) {
      _sendPingToAllConnections(session);
    });

    // Start cleanup timer
    _cleanupTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _cleanupStaleConnections(session);
    });

    session.log('$_className: WebSocket service initialized successfully',
        level: LogLevel.info);
  }

  /// Cleanup WebSocket service
  static void cleanup(Session session) {
    session.log('$_className: Cleaning up WebSocket service',
        level: LogLevel.info);

    _pingTimer?.cancel();
    _cleanupTimer?.cancel();

    // Close all connections
    for (final connectionId in _connections.keys.toList()) {
      disconnectUser(session, connectionId);
    }

    _connections.clear();
    _userConnections.clear();
    _roomSubscriptions.clear();
  }

  /// Handle new WebSocket connection
  static Future<String> connectUser(
    Session session, {
    required int userId,
    String? deviceId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: User $userId connecting via WebSocket',
          level: LogLevel.info);

      // Generate unique connection ID
      final connectionId = _generateConnectionId(userId, deviceId);

      // Check connection limits
      final userConnections = _userConnections[userId] ?? <String>{};
      if (userConnections.length >= _maxConnectionsPerUser) {
        // Remove oldest connection
        final oldestConnectionId = userConnections.first;
        await disconnectUser(session, oldestConnectionId);
      }

      // Create connection info
      final connectionInfo = WebSocketConnectionInfo(
        connectionId: connectionId,
        userId: userId,
        connectedAt: DateTime.now(),
        lastPingAt: DateTime.now(),
        subscribedRooms: [],
        metadata: {
          'device_id': deviceId,
          'user_agent': metadata?['user_agent'],
          'ip_address': metadata?['ip_address'],
          ...?metadata,
        },
        status: ConnectionStatus.connected,
      );

      // Store connection
      _connections[connectionId] = connectionInfo;
      _userConnections[userId] = (userConnections..add(connectionId));

      // Store in Redis for distributed systems
      await RedisService.setWithExpiry(
        session,
        'ws_connection:$connectionId',
        jsonEncode(connectionInfo.toJson()),
        _connectionTimeout,
      );

      // Auto-subscribe to user's personal room
      await subscribeToRoom(session, connectionId, 'user_$userId');

      // Send connection acknowledgment
      final welcomeMessage = WebSocketMessage.create(
        type: 'connection_established',
        data: {
          'connection_id': connectionId,
          'user_id': userId,
          'server_time': DateTime.now().toIso8601String(),
        },
      );

      await _sendToConnection(session, connectionId, welcomeMessage);

      session.log(
          '$_className: User $userId connected successfully: $connectionId',
          level: LogLevel.info);
      return connectionId;
    } catch (e, stackTrace) {
      session.log('$_className: Failed to connect user $userId: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.websocketConnectionFailed);
    }
  }

  /// Handle WebSocket disconnection
  static Future<void> disconnectUser(
      Session session, String connectionId) async {
    try {
      final connection = _connections[connectionId];
      if (connection == null) return;

      session.log(
          '$_className: Disconnecting user ${connection.userId}: $connectionId',
          level: LogLevel.info);

      // Remove from all subscribed rooms
      for (final room in connection.subscribedRooms.toList()) {
        await unsubscribeFromRoom(session, connectionId, room);
      }

      // Remove from user connections
      final userConnections = _userConnections[connection.userId];
      if (userConnections != null) {
        userConnections.remove(connectionId);
        if (userConnections.isEmpty) {
          _userConnections.remove(connection.userId);
        }
      }

      // Remove connection
      _connections.remove(connectionId);

      // Remove from Redis
      await RedisService.delete(session, 'ws_connection:$connectionId');

      session.log('$_className: User disconnected successfully: $connectionId',
          level: LogLevel.info);
    } catch (e) {
      session.log('$_className: Error disconnecting user: $e',
          level: LogLevel.error);
    }
  }

  /// Subscribe connection to a room
  static Future<bool> subscribeToRoom(
    Session session,
    String connectionId,
    String room,
  ) async {
    try {
      final connection = _connections[connectionId];
      if (connection == null) return false;

      // Add to room subscriptions
      final roomConnections = _roomSubscriptions[room] ?? <String>{};
      roomConnections.add(connectionId);
      _roomSubscriptions[room] = roomConnections;

      // Update connection info
      connection.subscribedRooms.add(room);
      _connections[connectionId] = connection;

      // Store in Redis
      await RedisService.addToSet(session, 'ws_room:$room', connectionId);

      session.log(
          '$_className: Connection $connectionId subscribed to room: $room',
          level: LogLevel.debug);
      return true;
    } catch (e) {
      session.log('$_className: Failed to subscribe to room: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Unsubscribe connection from a room
  static Future<bool> unsubscribeFromRoom(
    Session session,
    String connectionId,
    String room,
  ) async {
    try {
      final connection = _connections[connectionId];
      if (connection == null) return false;

      // Remove from room subscriptions
      final roomConnections = _roomSubscriptions[room];
      if (roomConnections != null) {
        roomConnections.remove(connectionId);
        if (roomConnections.isEmpty) {
          _roomSubscriptions.remove(room);
        }
      }

      // Update connection info
      connection.subscribedRooms.remove(room);
      _connections[connectionId] = connection;

      // Remove from Redis
      await RedisService.removeFromSet(session, 'ws_room:$room', connectionId);

      session.log(
          '$_className: Connection $connectionId unsubscribed from room: $room',
          level: LogLevel.debug);
      return true;
    } catch (e) {
      session.log('$_className: Failed to unsubscribe from room: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Send message to specific user
  static Future<bool> sendToUser(
    Session session,
    int userId,
    WebSocketMessage message,
  ) async {
    try {
      final userConnections = _userConnections[userId];
      if (userConnections == null || userConnections.isEmpty) {
        session.log('$_className: No active connections for user $userId',
            level: LogLevel.debug);
        return false;
      }

      bool sentToAny = false;
      for (final connectionId in userConnections) {
        final sent = await _sendToConnection(session, connectionId, message);
        if (sent) sentToAny = true;
      }

      return sentToAny;
    } catch (e) {
      session.log('$_className: Failed to send message to user $userId: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Send message to all connections in a room
  static Future<int> sendToRoom(
    Session session,
    String room,
    WebSocketMessage message,
  ) async {
    try {
      final roomConnections = _roomSubscriptions[room];
      if (roomConnections == null || roomConnections.isEmpty) {
        session.log('$_className: No connections in room: $room',
            level: LogLevel.debug);
        return 0;
      }

      int sentCount = 0;
      for (final connectionId in roomConnections.toList()) {
        final sent = await _sendToConnection(session, connectionId, message);
        if (sent) sentCount++;
      }

      session.log(
          '$_className: Sent message to $sentCount connections in room: $room',
          level: LogLevel.debug);
      return sentCount;
    } catch (e) {
      session.log('$_className: Failed to send message to room $room: $e',
          level: LogLevel.error);
      return 0;
    }
  }

  /// Broadcast message to all connected users
  static Future<int> broadcast(
    Session session,
    WebSocketMessage message,
  ) async {
    try {
      int sentCount = 0;
      for (final connectionId in _connections.keys.toList()) {
        final sent = await _sendToConnection(session, connectionId, message);
        if (sent) sentCount++;
      }

      session.log(
          '$_className: Broadcast message sent to $sentCount connections',
          level: LogLevel.info);
      return sentCount;
    } catch (e) {
      session.log('$_className: Failed to broadcast message: $e',
          level: LogLevel.error);
      return 0;
    }
  }

  /// Handle incoming message from client
  static Future<void> handleIncomingMessage(
    Session session,
    String connectionId,
    String messageData,
  ) async {
    try {
      final connection = _connections[connectionId];
      if (connection == null) {
        session.log(
            '$_className: Received message from unknown connection: $connectionId',
            level: LogLevel.warning);
        return;
      }

      // Check message size
      if (messageData.length > _maxMessageSize) {
        await _sendError(session, connectionId, 'Message too large',
            ErrorCodes.websocketMessageTooLarge);
        return;
      }

      // Parse message
      final messageJson = jsonDecode(messageData);
      final message = WebSocketMessage.fromJson(messageJson);

      // Update last activity
      connection.lastPingAt = DateTime.now();
      _connections[connectionId] = connection;

      // Handle different message types
      switch (message.type) {
        case 'ping':
          await _handlePing(session, connectionId);
          break;

        case 'pong':
          await _handlePong(session, connectionId);
          break;

        case 'subscribe':
          await _handleSubscribe(session, connectionId, message);
          break;

        case 'unsubscribe':
          await _handleUnsubscribe(session, connectionId, message);
          break;

        case 'chat_message':
          await _handleChatMessage(session, connectionId, message);
          break;

        case 'location_update':
          await _handleLocationUpdate(session, connectionId, message);
          break;

        case 'fare_offer':
          await _handleFareOffer(session, connectionId, message);
          break;

        case 'fare_response':
          await _handleFareResponse(session, connectionId, message);
          break;

        default:
          session.log('$_className: Unknown message type: ${message.type}',
              level: LogLevel.warning);
          await _sendError(session, connectionId, 'Unknown message type',
              ErrorCodes.websocketMessageInvalid);
      }
    } catch (e, stackTrace) {
      session.log('$_className: Error handling incoming message: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      await _sendError(session, connectionId, 'Message processing failed',
          ErrorCodes.websocketMessageInvalid);
    }
  }

  /// Get connection statistics
  static Map<String, dynamic> getConnectionStats(Session session) {
    final totalConnections = _connections.length;
    final uniqueUsers = _userConnections.length;
    final totalRooms = _roomSubscriptions.length;

    final connectionsByStatus = <ConnectionStatus, int>{};
    for (final connection in _connections.values) {
      connectionsByStatus[connection.status] =
          (connectionsByStatus[connection.status] ?? 0) + 1;
    }

    return {
      'total_connections': totalConnections,
      'unique_users': uniqueUsers,
      'total_rooms': totalRooms,
      'connections_by_status':
          connectionsByStatus.map((k, v) => MapEntry(k.toString(), v)),
      'average_rooms_per_connection': totalConnections > 0
          ? _connections.values
                  .map((c) => c.subscribedRooms.length)
                  .reduce((a, b) => a + b) /
              totalConnections
          : 0,
    };
  }

  /// Get user's active connections
  static List<WebSocketConnectionInfo> getUserConnections(
      Session session, int userId) {
    final connectionIds = _userConnections[userId] ?? <String>{};
    return connectionIds
        .map((id) => _connections[id])
        .where((conn) => conn != null)
        .cast<WebSocketConnectionInfo>()
        .toList();
  }

  /// Check if user is online
  static bool isUserOnline(Session session, int userId) {
    final connections = _userConnections[userId];
    return connections != null && connections.isNotEmpty;
  }

  // Private helper methods

  static String _generateConnectionId(int userId, String? deviceId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final deviceSuffix = deviceId != null ? '_$deviceId' : '';
    return 'ws_${userId}_${timestamp}$deviceSuffix';
  }

  static Future<bool> _sendToConnection(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    try {
      final connection = _connections[connectionId];
      if (connection == null ||
          connection.status != ConnectionStatus.connected) {
        return false;
      }

      // In a real implementation, this would send via the actual WebSocket connection
      // For now, we'll simulate successful sending
      session.log(
          '$_className: Sending message to connection $connectionId: ${message.type}',
          level: LogLevel.debug);

      // Store message for potential delivery retry
      await RedisService.setWithExpiry(
        session,
        'ws_last_message:$connectionId',
        jsonEncode(message.toJson()),
        Duration(minutes: 5),
      );

      return true;
    } catch (e) {
      session.log('$_className: Failed to send to connection $connectionId: $e',
          level: LogLevel.error);
      return false;
    }
  }

  static Future<void> _sendError(
    Session session,
    String connectionId,
    String errorMessage,
    String errorCode,
  ) async {
    final errorMsg = WebSocketMessage.error(
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
    await _sendToConnection(session, connectionId, errorMsg);
  }

  static Future<void> _handlePing(Session session, String connectionId) async {
    final pongMessage = WebSocketMessage.pong();
    await _sendToConnection(session, connectionId, pongMessage);
  }

  static Future<void> _handlePong(Session session, String connectionId) async {
    final connection = _connections[connectionId];
    if (connection != null) {
      connection.lastPingAt = DateTime.now();
      _connections[connectionId] = connection;
    }
  }

  static Future<void> _handleSubscribe(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final room = message.data?['room'] as String?;
    if (room != null) {
      await subscribeToRoom(session, connectionId, room);

      final ackMessage =
          WebSocketMessage.ack(originalMessageId: message.messageId!);
      await _sendToConnection(session, connectionId, ackMessage);
    }
  }

  static Future<void> _handleUnsubscribe(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final room = message.data?['room'] as String?;
    if (room != null) {
      await unsubscribeFromRoom(session, connectionId, room);

      final ackMessage =
          WebSocketMessage.ack(originalMessageId: message.messageId!);
      await _sendToConnection(session, connectionId, ackMessage);
    }
  }

  static Future<void> _handleChatMessage(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final connection = _connections[connectionId];
    if (connection == null) return;

    final rideId = message.data?['rideId'] as String?;
    if (rideId != null) {
      // Forward message to ride room
      await sendToRoom(session, 'ride_$rideId', message);

      // Store message in database (would be implemented)
      // await MongoDBService.storeChatMessage(session, ...);

      final ackMessage =
          WebSocketMessage.ack(originalMessageId: message.messageId)!;
      await _sendToConnection(session, connectionId, ackMessage);
    }
  }

  static Future<void> _handleLocationUpdate(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final connection = _connections[connectionId];
    if (connection == null) return;

    final latitude = message.data?['latitude'] as double?;
    final longitude = message.data?['longitude'] as double?;
    final rideId = message.data?['rideId'] as String?;

    if (latitude != null && longitude != null) {
      // Update location in location service
      // await LocationService.updateDriverLocation(session, ...);

      // Broadcast to interested parties
      if (rideId != null) {
        await sendToRoom(session, 'ride_$rideId', message);
      }
    }
  }

  static Future<void> _handleFareOffer(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final connection = _connections[connectionId];
    if (connection == null) return;

    final negotiationId = message.data?['negotiationId'] as String?;
    final toUserId = message.data?['toUserId'] as int?;

    if (negotiationId != null && toUserId != null) {
      // Send offer to target user
      await sendToUser(session, toUserId, message);

      // Store offer in database
      // await MongoDBService.storeNegotiation(session, ...);

      final ackMessage =
          WebSocketMessage.ack(originalMessageId: message.messageId!);
      await _sendToConnection(session, connectionId, ackMessage);
    }
  }

  static Future<void> _handleFareResponse(
    Session session,
    String connectionId,
    WebSocketMessage message,
  ) async {
    final connection = _connections[connectionId];
    if (connection == null) return;

    final negotiationId = message.data?['negotiationId'] as String?;
    final toUserId = message.data?['toUserId'] as int?;
    final accepted = message.data?['accepted'] as bool?;

    if (negotiationId != null && toUserId != null) {
      // Send response to original offerer
      await sendToUser(session, toUserId, message);

      // Update negotiation status
      // await MongoDBService.updateNegotiation(session, ...);

      final ackMessage =
          WebSocketMessage.ack(originalMessageId: message.messageId!);
      await _sendToConnection(session, connectionId, ackMessage);
    }
  }

  static void _sendPingToAllConnections(Session session) {
    for (final connectionId in _connections.keys.toList()) {
      final pingMessage = WebSocketMessage.ping();
      _sendToConnection(session, connectionId, pingMessage);
    }
  }

  static void _cleanupStaleConnections(Session session) {
    final now = DateTime.now();
    final staleConnections = <String>[];

    for (final entry in _connections.entries) {
      final connectionId = entry.key;
      final connection = entry.value;

      final timeSinceLastPing =
          now.difference(connection.lastPingAt ?? connection.connectedAt);

      if (timeSinceLastPing > _connectionTimeout) {
        staleConnections.add(connectionId);
      }
    }

    for (final connectionId in staleConnections) {
      session.log('$_className: Cleaning up stale connection: $connectionId',
          level: LogLevel.info);
      disconnectUser(session, connectionId);
    }
  }
}
