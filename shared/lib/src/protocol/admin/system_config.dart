import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'system_config.g.dart';

@JsonSerializable()
class SystemConfig extends SerializableEntity {
  @override
  int? id;

  String configKey;
  String configValue;
  ConfigType configType;
  String? description;
  String? category;
  bool isPublic;
  bool isEditable;
  bool requiresRestart;
  Map<String, dynamic>? validation;
  Map<String, dynamic>? metadata;
  DateTime createdAt;
  DateTime updatedAt;
  int? updatedBy;
  String? environment; // 'development', 'staging', 'production'

  SystemConfig({
    this.id,
    required this.configKey,
    required this.configValue,
    required this.configType,
    this.description,
    this.category,
    this.isPublic = false,
    this.isEditable = true,
    this.requiresRestart = false,
    this.validation,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
    this.environment,
  });

  T getValue<T>() {
    try {
      switch (configType) {
        case ConfigType.string:
          return configValue as T;
        case ConfigType.integer:
          return int.parse(configValue) as T;
        case ConfigType.double:
          return double.parse(configValue) as T;
        case ConfigType.boolean:
          return (configValue.toLowerCase() == 'true' || configValue == '1')
              as T;
        case ConfigType.json:
          return jsonDecode(configValue) as T;
        case ConfigType.array:
          final decoded = jsonDecode(configValue);
          return (decoded is List ? decoded : [decoded]) as T;
        case ConfigType.object:
          return jsonDecode(configValue) as T;
      }
    } catch (e) {
      throw Exception(
          'Failed to parse config value for key: $configKey, error: $e');
    }
  }

  bool isValid() {
    if (validation == null) return true;

    try {
      final value = getValue();

      // Check required
      if (validation!['required'] == true &&
          (value == null || value.toString().isEmpty)) {
        return false;
      }

      // Check min/max for numbers
      if (configType == ConfigType.integer || configType == ConfigType.double) {
        final numValue = value as num;
        if (validation!['min'] != null && numValue < validation!['min'])
          return false;
        if (validation!['max'] != null && numValue > validation!['max'])
          return false;
      }

      // Check length for strings
      if (configType == ConfigType.string) {
        final strValue = value as String;
        if (validation!['minLength'] != null &&
            strValue.length < validation!['minLength']) return false;
        if (validation!['maxLength'] != null &&
            strValue.length > validation!['maxLength']) return false;
        if (validation!['pattern'] != null) {
          final regex = RegExp(validation!['pattern']);
          if (!regex.hasMatch(strValue)) return false;
        }
      }

      // Check allowed values
      if (validation!['allowedValues'] != null) {
        final allowedValues = validation!['allowedValues'] as List;
        if (!allowedValues.contains(value)) return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);
  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}

@JsonSerializable()
class ConfigCategory extends SerializableEntity {
  @override
  int? id;

  String name;
  String displayName;
  String? description;
  String? icon;
  int sortOrder;
  bool isActive;
  List<SystemConfig>? configs;

  ConfigCategory({
    this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.icon,
    this.sortOrder = 0,
    this.isActive = true,
    this.configs,
  });

  factory ConfigCategory.fromJson(Map<String, dynamic> json) =>
      _$ConfigCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigCategoryToJson(this);
}

@JsonSerializable()
class ConfigHistory extends SerializableEntity {
  @override
  int? id;

  String configKey;
  String oldValue;
  String newValue;
  int changedBy;
  DateTime changedAt;
  String? reason;
  String? ipAddress;

  ConfigHistory({
    this.id,
    required this.configKey,
    required this.oldValue,
    required this.newValue,
    required this.changedBy,
    required this.changedAt,
    this.reason,
    this.ipAddress,
  });

  factory ConfigHistory.fromJson(Map<String, dynamic> json) =>
      _$ConfigHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigHistoryToJson(this);
}

@JsonSerializable()
class FeatureFlag extends SerializableEntity {
  @override
  int? id;

  String flagKey;
  String name;
  String? description;
  bool isEnabled;
  double rolloutPercentage;
  Map<String, dynamic>? conditions;
  List<String>? targetUserIds;
  List<String>? targetUserTypes;
  DateTime createdAt;
  DateTime? updatedAt;
  int createdBy;
  DateTime? expiresAt;
  String? environment;

  FeatureFlag({
    this.id,
    required this.flagKey,
    required this.name,
    this.description,
    this.isEnabled = false,
    this.rolloutPercentage = 0.0,
    this.conditions,
    this.targetUserIds,
    this.targetUserTypes,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.expiresAt,
    this.environment,
  });

  bool isActiveForUser(int userId, String userType) {
    if (!isEnabled) return false;
    if (isExpired) return false;

    // Check if user is specifically targeted
    if (targetUserIds != null && targetUserIds!.contains(userId.toString())) {
      return true;
    }

    // Check if user type is targeted
    if (targetUserTypes != null && targetUserTypes!.contains(userType)) {
      return true;
    }

    // Check rollout percentage
    if (rolloutPercentage >= 100.0) return true;
    if (rolloutPercentage <= 0.0) return false;

    // Use user ID for consistent rollout
    final hash = userId.hashCode.abs();
    final percentage = (hash % 100) + 1;
    return percentage <= rolloutPercentage;
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory FeatureFlag.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagFromJson(json);
  Map<String, dynamic> toJson() => _$FeatureFlagToJson(this);
}

@JsonSerializable()
class SystemHealth extends SerializableEntity {
  @override
  int? id;

  HealthStatus overallStatus;
  Map<String, ServiceHealth> services;
  Map<String, double> metrics;
  DateTime timestamp;
  String? version;
  Map<String, dynamic>? metadata;

  SystemHealth({
    this.id,
    required this.overallStatus,
    this.services = const {},
    this.metrics = const {},
    required this.timestamp,
    this.version,
    this.metadata,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthFromJson(json);
  Map<String, dynamic> toJson() => _$SystemHealthToJson(this);
}

@JsonSerializable()
class ServiceHealth extends SerializableEntity {
  @override
  int? id;

  String serviceName;
  HealthStatus status;
  String? message;
  double? responseTime;
  DateTime lastChecked;
  Map<String, dynamic>? details;

  ServiceHealth({
    this.id,
    required this.serviceName,
    required this.status,
    this.message,
    this.responseTime,
    required this.lastChecked,
    this.details,
  });

  factory ServiceHealth.fromJson(Map<String, dynamic> json) =>
      _$ServiceHealthFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceHealthToJson(this);
}

enum ConfigType {
  string,
  integer,
  double,
  boolean,
  json,
  array,
  object,
}

enum HealthStatus {
  healthy,
  degraded,
  unhealthy,
  unknown,
}
