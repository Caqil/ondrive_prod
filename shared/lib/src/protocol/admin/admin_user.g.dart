// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      role: $enumDecode(_$AdminRoleEnumMap, json['role']),
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AdminPermissionEnumMap, e))
              .toList() ??
          const [],
      assignedAt: DateTime.parse(json['assignedAt'] as String),
      assignedBy: (json['assignedBy'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      department: json['department'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'role': _$AdminRoleEnumMap[instance.role]!,
      'permissions': instance.permissions
          .map((e) => _$AdminPermissionEnumMap[e]!)
          .toList(),
      'assignedAt': instance.assignedAt.toIso8601String(),
      'assignedBy': instance.assignedBy,
      'isActive': instance.isActive,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'department': instance.department,
      'notes': instance.notes,
    };

const _$AdminRoleEnumMap = {
  AdminRole.superAdmin: 'superAdmin',
  AdminRole.admin: 'admin',
  AdminRole.moderator: 'moderator',
  AdminRole.support: 'support',
  AdminRole.analyst: 'analyst',
  AdminRole.readonly: 'readonly',
};

const _$AdminPermissionEnumMap = {
  AdminPermission.all: 'all',
  AdminPermission.userManagement: 'userManagement',
  AdminPermission.driverManagement: 'driverManagement',
  AdminPermission.rideManagement: 'rideManagement',
  AdminPermission.paymentManagement: 'paymentManagement',
  AdminPermission.disputeResolution: 'disputeResolution',
  AdminPermission.systemConfig: 'systemConfig',
  AdminPermission.reports: 'reports',
  AdminPermission.analytics: 'analytics',
  AdminPermission.supportTickets: 'supportTickets',
  AdminPermission.notifications: 'notifications',
  AdminPermission.auditLogs: 'auditLogs',
};

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) => SystemConfig(
      id: (json['id'] as num?)?.toInt(),
      configKey: json['configKey'] as String,
      configValue: json['configValue'] as String,
      configType: $enumDecode(_$ConfigTypeEnumMap, json['configType']),
      description: json['description'] as String?,
      isPublic: json['isPublic'] as bool? ?? false,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: (json['updatedBy'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SystemConfigToJson(SystemConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'configKey': instance.configKey,
      'configValue': instance.configValue,
      'configType': _$ConfigTypeEnumMap[instance.configType]!,
      'description': instance.description,
      'isPublic': instance.isPublic,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };

const _$ConfigTypeEnumMap = {
  ConfigType.string: 'string',
  ConfigType.integer: 'integer',
  ConfigType.double: 'double',
  ConfigType.boolean: 'boolean',
  ConfigType.json: 'json',
};

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) =>
    AnalyticsData(
      id: (json['id'] as num?)?.toInt(),
      metricName: json['metricName'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      period: json['period'] as String,
      dimensions: json['dimensions'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AnalyticsDataToJson(AnalyticsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'metricName': instance.metricName,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp.toIso8601String(),
      'period': instance.period,
      'dimensions': instance.dimensions,
      'metadata': instance.metadata,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: (json['id'] as num?)?.toInt(),
      reportId: json['reportId'] as String,
      name: json['name'] as String,
      reportType: $enumDecode(_$ReportTypeEnumMap, json['reportType']),
      parameters: json['parameters'] as Map<String, dynamic>,
      data: json['data'] as Map<String, dynamic>?,
      status: $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.pending,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
      requestedBy: (json['requestedBy'] as num).toInt(),
      fileUrl: json['fileUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'reportId': instance.reportId,
      'name': instance.name,
      'reportType': _$ReportTypeEnumMap[instance.reportType]!,
      'parameters': instance.parameters,
      'data': instance.data,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'generatedAt': instance.generatedAt?.toIso8601String(),
      'requestedBy': instance.requestedBy,
      'fileUrl': instance.fileUrl,
      'errorMessage': instance.errorMessage,
    };

const _$ReportTypeEnumMap = {
  ReportType.userActivity: 'userActivity',
  ReportType.driverPerformance: 'driverPerformance',
  ReportType.rideAnalytics: 'rideAnalytics',
  ReportType.revenue: 'revenue',
  ReportType.disputes: 'disputes',
  ReportType.customQuery: 'customQuery',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.generating: 'generating',
  ReportStatus.completed: 'completed',
  ReportStatus.failed: 'failed',
};

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
      id: (json['id'] as num?)?.toInt(),
      action: json['action'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      userEmail: json['userEmail'] as String?,
      entityType: json['entityType'] as String,
      entityId: json['entityId'] as String?,
      oldValues: json['oldValues'] as Map<String, dynamic>?,
      newValues: json['newValues'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: $enumDecodeNullable(_$AuditSeverityEnumMap, json['severity']) ??
          AuditSeverity.info,
    );

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'oldValues': instance.oldValues,
      'newValues': instance.newValues,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'timestamp': instance.timestamp.toIso8601String(),
      'severity': _$AuditSeverityEnumMap[instance.severity]!,
    };

const _$AuditSeverityEnumMap = {
  AuditSeverity.info: 'info',
  AuditSeverity.warning: 'warning',
  AuditSeverity.error: 'error',
  AuditSeverity.critical: 'critical',
};

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) =>
    DashboardStats(
      id: (json['id'] as num?)?.toInt(),
      totalUsers: (json['totalUsers'] as num).toInt(),
      totalDrivers: (json['totalDrivers'] as num).toInt(),
      totalPassengers: (json['totalPassengers'] as num).toInt(),
      activeDrivers: (json['activeDrivers'] as num).toInt(),
      onlineDrivers: (json['onlineDrivers'] as num).toInt(),
      totalRides: (json['totalRides'] as num).toInt(),
      completedRides: (json['completedRides'] as num).toInt(),
      cancelledRides: (json['cancelledRides'] as num).toInt(),
      ongoingRides: (json['ongoingRides'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      todayRevenue: (json['todayRevenue'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalDisputes: (json['totalDisputes'] as num).toInt(),
      pendingDisputes: (json['pendingDisputes'] as num).toInt(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      additionalMetrics: json['additionalMetrics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DashboardStatsToJson(DashboardStats instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalUsers': instance.totalUsers,
      'totalDrivers': instance.totalDrivers,
      'totalPassengers': instance.totalPassengers,
      'activeDrivers': instance.activeDrivers,
      'onlineDrivers': instance.onlineDrivers,
      'totalRides': instance.totalRides,
      'completedRides': instance.completedRides,
      'cancelledRides': instance.cancelledRides,
      'ongoingRides': instance.ongoingRides,
      'totalRevenue': instance.totalRevenue,
      'todayRevenue': instance.todayRevenue,
      'averageRating': instance.averageRating,
      'totalDisputes': instance.totalDisputes,
      'pendingDisputes': instance.pendingDisputes,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'additionalMetrics': instance.additionalMetrics,
    };

SurgeConfig _$SurgeConfigFromJson(Map<String, dynamic> json) => SurgeConfig(
      id: (json['id'] as num?)?.toInt(),
      configId: json['configId'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
      baseSurgeMultiplier: (json['baseSurgeMultiplier'] as num).toDouble(),
      maxSurgeMultiplier: (json['maxSurgeMultiplier'] as num).toDouble(),
      demandThreshold: (json['demandThreshold'] as num).toInt(),
      driverThreshold: (json['driverThreshold'] as num).toInt(),
      applicableAreas: (json['applicableAreas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      applicableRideTypes: (json['applicableRideTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      timeRules: json['timeRules'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updatedBy: (json['updatedBy'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SurgeConfigToJson(SurgeConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'configId': instance.configId,
      'name': instance.name,
      'isActive': instance.isActive,
      'baseSurgeMultiplier': instance.baseSurgeMultiplier,
      'maxSurgeMultiplier': instance.maxSurgeMultiplier,
      'demandThreshold': instance.demandThreshold,
      'driverThreshold': instance.driverThreshold,
      'applicableAreas': instance.applicableAreas,
      'applicableRideTypes': instance.applicableRideTypes,
      'timeRules': instance.timeRules,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
