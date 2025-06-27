import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

@JsonSerializable()
class AdminUser extends SerializableEntity {
  @override
  int? id;

  int userId;
  AdminRole role;
  List<AdminPermission> permissions;
  DateTime assignedAt;
  int? assignedBy;
  bool isActive;
  DateTime? lastLoginAt;
  String? department;
  String? notes;

  AdminUser({
    this.id,
    required this.userId,
    required this.role,
    this.permissions = const [],
    required this.assignedAt,
    this.assignedBy,
    this.isActive = true,
    this.lastLoginAt,
    this.department,
    this.notes,
  });

  bool hasPermission(AdminPermission permission) {
    return permissions.contains(permission) ||
        permissions.contains(AdminPermission.all);
  }

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserToJson(this);
}

@JsonSerializable()
class SystemConfig extends SerializableEntity {
  @override
  int? id;

  String configKey;
  String configValue;
  ConfigType configType;
  String? description;
  bool isPublic;
  DateTime updatedAt;
  int? updatedBy;

  SystemConfig({
    this.id,
    required this.configKey,
    required this.configValue,
    required this.configType,
    this.description,
    this.isPublic = false,
    required this.updatedAt,
    this.updatedBy,
  });

  T getValue<T>() {
    switch (configType) {
      case ConfigType.string:
        return configValue as T;
      case ConfigType.integer:
        return int.parse(configValue) as T;
      case ConfigType.double:
        return double.parse(configValue) as T;
      case ConfigType.boolean:
        return (configValue.toLowerCase() == 'true') as T;
      case ConfigType.json:
        return jsonDecode(configValue) as T;
    }
  }

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);
  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}

@JsonSerializable()
class AnalyticsData extends SerializableEntity {
  @override
  int? id;

  String metricName;
  double value;
  String? unit;
  DateTime timestamp;
  String period; // 'hour', 'day', 'week', 'month'
  Map<String, dynamic>? dimensions;
  Map<String, dynamic>? metadata;

  AnalyticsData({
    this.id,
    required this.metricName,
    required this.value,
    this.unit,
    required this.timestamp,
    required this.period,
    this.dimensions,
    this.metadata,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsDataToJson(this);
}

@JsonSerializable()
class Report extends SerializableEntity {
  @override
  int? id;

  String reportId;
  String name;
  ReportType reportType;
  Map<String, dynamic> parameters;
  Map<String, dynamic>? data;
  ReportStatus status;
  DateTime requestedAt;
  DateTime? generatedAt;
  int requestedBy;
  String? fileUrl;
  String? errorMessage;

  Report({
    this.id,
    required this.reportId,
    required this.name,
    required this.reportType,
    required this.parameters,
    this.data,
    this.status = ReportStatus.pending,
    required this.requestedAt,
    this.generatedAt,
    required this.requestedBy,
    this.fileUrl,
    this.errorMessage,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class AuditLog extends SerializableEntity {
  @override
  int? id;

  String action;
  int? userId;
  String? userEmail;
  String entityType;
  String? entityId;
  Map<String, dynamic>? oldValues;
  Map<String, dynamic>? newValues;
  String? ipAddress;
  String? userAgent;
  DateTime timestamp;
  AuditSeverity severity;

  AuditLog({
    this.id,
    required this.action,
    this.userId,
    this.userEmail,
    required this.entityType,
    this.entityId,
    this.oldValues,
    this.newValues,
    this.ipAddress,
    this.userAgent,
    required this.timestamp,
    this.severity = AuditSeverity.info,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
  Map<String, dynamic> toJson() => _$AuditLogToJson(this);
}

@JsonSerializable()
class DashboardStats extends SerializableEntity {
  @override
  int? id;

  int totalUsers;
  int totalDrivers;
  int totalPassengers;
  int activeDrivers;
  int onlineDrivers;
  int totalRides;
  int completedRides;
  int cancelledRides;
  int ongoingRides;
  double totalRevenue;
  double todayRevenue;
  double averageRating;
  int totalDisputes;
  int pendingDisputes;
  DateTime calculatedAt;
  Map<String, dynamic>? additionalMetrics;

  DashboardStats({
    this.id,
    required this.totalUsers,
    required this.totalDrivers,
    required this.totalPassengers,
    required this.activeDrivers,
    required this.onlineDrivers,
    required this.totalRides,
    required this.completedRides,
    required this.cancelledRides,
    required this.ongoingRides,
    required this.totalRevenue,
    required this.todayRevenue,
    required this.averageRating,
    required this.totalDisputes,
    required this.pendingDisputes,
    required this.calculatedAt,
    this.additionalMetrics,
  });

  double get rideCompletionRate {
    if (totalRides == 0) return 0.0;
    return (completedRides / totalRides) * 100;
  }

  double get rideCancellationRate {
    if (totalRides == 0) return 0.0;
    return (cancelledRides / totalRides) * 100;
  }

  double get driverUtilizationRate {
    if (totalDrivers == 0) return 0.0;
    return (activeDrivers / totalDrivers) * 100;
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsToJson(this);
}

@JsonSerializable()
class SurgeConfig extends SerializableEntity {
  @override
  int? id;

  String configId;
  String name;
  bool isActive;
  double baseSurgeMultiplier;
  double maxSurgeMultiplier;
  int demandThreshold;
  int driverThreshold;
  List<String> applicableAreas;
  List<String> applicableRideTypes;
  Map<String, dynamic> timeRules; // Day/hour based rules
  DateTime createdAt;
  DateTime? updatedAt;
  int? updatedBy;

  SurgeConfig({
    this.id,
    required this.configId,
    required this.name,
    this.isActive = true,
    required this.baseSurgeMultiplier,
    required this.maxSurgeMultiplier,
    required this.demandThreshold,
    required this.driverThreshold,
    this.applicableAreas = const [],
    this.applicableRideTypes = const [],
    this.timeRules = const {},
    required this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  factory SurgeConfig.fromJson(Map<String, dynamic> json) =>
      _$SurgeConfigFromJson(json);
  Map<String, dynamic> toJson() => _$SurgeConfigToJson(this);
}

enum AdminRole {
  superAdmin,
  admin,
  moderator,
  support,
  analyst,
  readonly,
}

enum AdminPermission {
  all,
  userManagement,
  driverManagement,
  rideManagement,
  paymentManagement,
  disputeResolution,
  systemConfig,
  reports,
  analytics,
  supportTickets,
  notifications,
  auditLogs,
}

enum ConfigType {
  string,
  integer,
  double,
  boolean,
  json,
}

enum ReportType {
  userActivity,
  driverPerformance,
  rideAnalytics,
  revenue,
  disputes,
  customQuery,
}

enum ReportStatus {
  pending,
  generating,
  completed,
  failed,
}

enum AuditSeverity {
  info,
  warning,
  error,
  critical,
}
