// server/lib/src/services/redis_service.dart

import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:redis/redis.dart';
import '../utils/error_codes.dart';

/// Redis service for caching, session management, and real-time data
class RedisService {
  static const String _className = 'RedisService';

  static RedisConnection? _connection;
  static Command? _command;
  static bool _isInitialized = false;

  // Default configurations
  static const int _defaultTtl = 3600; // 1 hour
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);

  /// Initialize Redis connection
  static Future<void> initialize(
    Session session, {
    required String host,
    required int port,
    String? password,
    int database = 0,
  }) async {
    try {
      if (_isInitialized) return;

      session.log('$_className: Initializing Redis connection to $host:$port',
          level: LogLevel.info);

      _connection = RedisConnection();
      _command = await _connection!.connect(host, port);

      // Authenticate if password provided
      if (password != null && password.isNotEmpty) {
        await _command!.send_object(['AUTH', password]);
      }

      // Select database
      if (database != 0) {
        await _command!.send_object(['SELECT', database.toString()]);
      }

      // Test connection
      final response = await _command!.send_object(['PING']);
      if (response != 'PONG') {
        throw Exception('Redis ping failed');
      }

      _isInitialized = true;
      session.log('$_className: Redis connection established successfully',
          level: LogLevel.info);
    } catch (e, stackTrace) {
      session.log('$_className: Failed to initialize Redis: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Close Redis connection
  static Future<void> close(Session session) async {
    try {
      if (_connection != null) {
        await _connection!.close();
        _connection = null;
        _command = null;
        _isInitialized = false;
        session.log('$_className: Redis connection closed',
            level: LogLevel.info);
      }
    } catch (e) {
      session.log('$_className: Error closing Redis connection: $e',
          level: LogLevel.error);
    }
  }

  /// Check if Redis is connected
  static bool get isConnected => _isInitialized && _connection != null;

  // =============================================================================
  // BASIC STRING OPERATIONS
  // =============================================================================

  /// Set a key-value pair
  static Future<bool> set(
    Session session,
    String key,
    String value, {
    int? ttlSeconds,
  }) async {
    try {
      _ensureConnected();

      final command = ['SET', key, value];
      if (ttlSeconds != null) {
        command.addAll(['EX', ttlSeconds.toString()]);
      }

      final response =
          await _executeWithRetry(() => _command!.send_object(command));
      return response == 'OK';
    } catch (e) {
      session.log('$_className: Failed to set key $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Set a key-value pair with expiry
  static Future<bool> setWithExpiry(
    Session session,
    String key,
    String value,
    Duration expiry,
  ) async {
    return await set(session, key, value, ttlSeconds: expiry.inSeconds);
  }

  /// Get value by key
  static Future<String?> get(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['GET', key]));
      return response as String?;
    } catch (e) {
      session.log('$_className: Failed to get key $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Delete a key
  static Future<bool> delete(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['DEL', key]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to delete key $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Check if key exists
  static Future<bool> exists(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['EXISTS', key]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to check existence of key $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Set expiry for a key
  static Future<bool> expire(
      Session session, String key, Duration expiry) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(() =>
          _command!.send_object(['EXPIRE', key, expiry.inSeconds.toString()]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to set expiry for key $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get TTL for a key
  static Future<int?> getTtl(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['TTL', key]));
      final ttl = response as int;
      return ttl >= 0 ? ttl : null;
    } catch (e) {
      session.log('$_className: Failed to get TTL for key $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  // =============================================================================
  // HASH OPERATIONS
  // =============================================================================

  /// Set field in hash
  static Future<bool> hset(
    Session session,
    String key,
    String field,
    String value,
  ) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['HSET', key, field, value]));
      return response != null;
    } catch (e) {
      session.log('$_className: Failed to set hash field $key.$field: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get field from hash
  static Future<String?> hget(Session session, String key, String field) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['HGET', key, field]));
      return response as String?;
    } catch (e) {
      session.log('$_className: Failed to get hash field $key.$field: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Get all fields from hash
  static Future<Map<String, String>> hgetAll(
      Session session, String key) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['HGETALL', key]));
      final list = response as List<dynamic>;

      final result = <String, String>{};
      for (int i = 0; i < list.length; i += 2) {
        if (i + 1 < list.length) {
          result[list[i].toString()] = list[i + 1].toString();
        }
      }

      return result;
    } catch (e) {
      session.log('$_className: Failed to get all hash fields for $key: $e',
          level: LogLevel.error);
      return {};
    }
  }

  /// Delete field from hash
  static Future<bool> hdel(Session session, String key, String field) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['HDEL', key, field]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to delete hash field $key.$field: $e',
          level: LogLevel.error);
      return false;
    }
  }

  // =============================================================================
  // LIST OPERATIONS
  // =============================================================================

  /// Push value to left of list
  static Future<int?> lpush(Session session, String key, String value) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['LPUSH', key, value]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to lpush to $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Push value to right of list
  static Future<int?> rpush(Session session, String key, String value) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['RPUSH', key, value]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to rpush to $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Pop value from left of list
  static Future<String?> lpop(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['LPOP', key]));
      return response as String?;
    } catch (e) {
      session.log('$_className: Failed to lpop from $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Pop value from right of list
  static Future<String?> rpop(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['RPOP', key]));
      return response as String?;
    } catch (e) {
      session.log('$_className: Failed to rpop from $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Get list length
  static Future<int?> llen(Session session, String key) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['LLEN', key]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to get length of $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Get range of list elements
  static Future<List<String>> lrange(
    Session session,
    String key,
    int start,
    int stop,
  ) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(() => _command!
          .send_object(['LRANGE', key, start.toString(), stop.toString()]));
      final list = response as List<dynamic>;

      return list.map((item) => item.toString()).toList();
    } catch (e) {
      session.log('$_className: Failed to get range from $key: $e',
          level: LogLevel.error);
      return [];
    }
  }

  // =============================================================================
  // SET OPERATIONS
  // =============================================================================

  /// Add member to set
  static Future<bool> addToSet(
      Session session, String key, String member) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['SADD', key, member]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to add to set $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Remove member from set
  static Future<bool> removeFromSet(
      Session session, String key, String member) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['SREM', key, member]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to remove from set $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get all members of set
  static Future<Set<String>> getSet(Session session, String key) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['SMEMBERS', key]));
      final list = response as List<dynamic>;

      return list.map((item) => item.toString()).toSet();
    } catch (e) {
      session.log('$_className: Failed to get set $key: $e',
          level: LogLevel.error);
      return <String>{};
    }
  }

  /// Check if member exists in set
  static Future<bool> isInSet(
      Session session, String key, String member) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['SISMEMBER', key, member]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to check set membership $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  // =============================================================================
  // SORTED SET OPERATIONS
  // =============================================================================

  /// Add member to sorted set with score
  static Future<bool> zadd(
    Session session,
    String key,
    double score,
    String member,
  ) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['ZADD', key, score.toString(), member]));
      return response != null;
    } catch (e) {
      session.log('$_className: Failed to zadd to $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get range from sorted set
  static Future<List<String>> zrange(
    Session session,
    String key,
    int start,
    int stop, {
    bool withScores = false,
  }) async {
    try {
      _ensureConnected();

      final command = ['ZRANGE', key, start.toString(), stop.toString()];
      if (withScores) {
        command.add('WITHSCORES');
      }

      final response =
          await _executeWithRetry(() => _command!.send_object(command));
      final list = response as List<dynamic>;

      return list.map((item) => item.toString()).toList();
    } catch (e) {
      session.log('$_className: Failed to zrange from $key: $e',
          level: LogLevel.error);
      return [];
    }
  }

  /// Remove member from sorted set
  static Future<bool> zrem(Session session, String key, String member) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['ZREM', key, member]));
      return response == 1;
    } catch (e) {
      session.log('$_className: Failed to zrem from $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  // =============================================================================
  // PUBLISH/SUBSCRIBE OPERATIONS
  // =============================================================================

  /// Publish message to channel
  static Future<int?> publish(
      Session session, String channel, String message) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['PUBLISH', channel, message]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to publish to $channel: $e',
          level: LogLevel.error);
      return null;
    }
  }

  // =============================================================================
  // UTILITY OPERATIONS
  // =============================================================================

  /// Get multiple keys
  static Future<List<String?>> mget(Session session, List<String> keys) async {
    try {
      _ensureConnected();

      final command = ['MGET', ...keys];
      final response =
          await _executeWithRetry(() => _command!.send_object(command));
      final list = response as List<dynamic>;

      return list.map((item) => item as String?).toList();
    } catch (e) {
      session.log('$_className: Failed to mget keys: $e',
          level: LogLevel.error);
      return List.filled(keys.length, null);
    }
  }

  /// Set multiple key-value pairs
  static Future<bool> mset(
      Session session, Map<String, String> keyValues) async {
    try {
      _ensureConnected();

      final command = ['MSET'];
      keyValues.forEach((key, value) {
        command.addAll([key, value]);
      });

      final response =
          await _executeWithRetry(() => _command!.send_object(command));
      return response == 'OK';
    } catch (e) {
      session.log('$_className: Failed to mset: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Get keys matching pattern
  static Future<List<String>> keys(Session session, String pattern) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['KEYS', pattern]));
      final list = response as List<dynamic>;

      return list.map((item) => item.toString()).toList();
    } catch (e) {
      session.log('$_className: Failed to get keys with pattern $pattern: $e',
          level: LogLevel.error);
      return [];
    }
  }

  /// Increment value by amount
  static Future<int?> incrBy(Session session, String key, int amount) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['INCRBY', key, amount.toString()]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to increment $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Decrement value by amount
  static Future<int?> decrBy(Session session, String key, int amount) async {
    try {
      _ensureConnected();

      final response = await _executeWithRetry(
          () => _command!.send_object(['DECRBY', key, amount.toString()]));
      return response as int?;
    } catch (e) {
      session.log('$_className: Failed to decrement $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  // =============================================================================
  // JSON OPERATIONS (CONVENIENCE METHODS)
  // =============================================================================

  /// Set JSON object
  static Future<bool> setJson(
    Session session,
    String key,
    Map<String, dynamic> object, {
    int? ttlSeconds,
  }) async {
    try {
      final jsonString = jsonEncode(object);
      return await set(session, key, jsonString, ttlSeconds: ttlSeconds);
    } catch (e) {
      session.log('$_className: Failed to set JSON for key $key: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get JSON object
  static Future<Map<String, dynamic>?> getJson(
      Session session, String key) async {
    try {
      final jsonString = await get(session, key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      session.log('$_className: Failed to get JSON for key $key: $e',
          level: LogLevel.error);
      return null;
    }
  }

  // =============================================================================
  // PRIVATE HELPER METHODS
  // =============================================================================

  static void _ensureConnected() {
    if (!_isInitialized || _command == null) {
      throw Exception(ErrorCodes.databaseConnectionFailed);
    }
  }

  static Future<T> _executeWithRetry<T>(Future<T> Function() operation) async {
    Exception? lastException;

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        if (attempt < _maxRetries - 1) {
          await Future.delayed(_retryDelay * (attempt + 1));
        }
      }
    }

    throw lastException!;
  }

  /// Flush all data (use with caution)
  static Future<bool> flushAll(Session session) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['FLUSHALL']));
      session.log('$_className: All Redis data flushed',
          level: LogLevel.warning);
      return response == 'OK';
    } catch (e) {
      session.log('$_className: Failed to flush all data: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Get Redis info
  static Future<Map<String, String>> info(Session session) async {
    try {
      _ensureConnected();

      final response =
          await _executeWithRetry(() => _command!.send_object(['INFO']));
      final infoString = response as String;

      final info = <String, String>{};
      for (final line in infoString.split('\n')) {
        if (line.contains(':') && !line.startsWith('#')) {
          final parts = line.split(':');
          if (parts.length >= 2) {
            info[parts[0].trim()] = parts[1].trim();
          }
        }
      }

      return info;
    } catch (e) {
      session.log('$_className: Failed to get Redis info: $e',
          level: LogLevel.error);
      return {};
    }
  }
}
