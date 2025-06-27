import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_log.g.dart';

@JsonSerializable()
class AuditLog extends SerializableEntity {
  @override
  int? id;

  String auditId;
  String action;
  int? userId;
  String? userEmail;
  String? userName;
  AuditEntityType entityType;
  String? entityId;
  String? entityName;
  Map<String, dynamic>? oldValues;
  Map<String, dynamic>? newValues;
  String? ipAddress;
  String? userAgent;
  String? sessionId;
  DateTime timestamp;
  AuditSeverity severity;
  AuditResult result;
  String? errorMessage;
  Map<String, dynamic>? context;
  String? source; // 'web', 'mobile', 'api', 'system'

  AuditLog({
    this.id,
    required this.auditId,
    required this.action,
    this.userId,
    this.userEmail,
    this.userName,
    required this.entityType,
    this.entityId,
    this.entityName,
    this.oldValues,
    this.newValues,
    this.ipAddress,
    this.userAgent,
    this.sessionId,
    required this.timestamp,
    this.severity = AuditSeverity.info,
    this.result = AuditResult.success,
    this.errorMessage,
    this.context,
    this.source,
  });

  String get formattedAction {
    final parts = action.split('_');
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  bool get isSuccessful => result == AuditResult.success;
  bool get isFailed => result == AuditResult.failure;
  bool get isCritical => severity == AuditSeverity.critical;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
  Map<String, dynamic> toJson() => _$AuditLogToJson(this);
}

@JsonSerializable()
class AuditLogFilter extends SerializableEntity {
  @override
  int? id;

  DateTime? startDate;
  DateTime? endDate;
  List<String>? actions;
  List<int>? userIds;
  List<AuditEntityType>? entityTypes;
  List<AuditSeverity>? severities;
  List<AuditResult>? results;
  String? ipAddress;
  String? searchTerm;
  List<String>? sources;

  AuditLogFilter({
    this.id,
    this.startDate,
    this.endDate,
    this.actions,
    this.userIds,
    this.entityTypes,
    this.severities,
    this.results,
    this.ipAddress,
    this.searchTerm,
    this.sources,
  });

  factory AuditLogFilter.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFilterFromJson(json);
  Map<String, dynamic> toJson() => _$AuditLogFilterToJson(this);
}

@JsonSerializable()
class AuditLogSummary extends SerializableEntity {
  @override
  int? id;

  int totalLogs;
  int successfulActions;
  int failedActions;
  int criticalEvents;
  Map<String, int> actionCounts;
  Map<String, int> severityCounts;
  Map<String, int> entityTypeCounts;
  DateTime periodStart;
  DateTime periodEnd;
  List<String> topUsers;
  List<String> topActions;

  AuditLogSummary({
    this.id,
    required this.totalLogs,
    required this.successfulActions,
    required this.failedActions,
    required this.criticalEvents,
    this.actionCounts = const {},
    this.severityCounts = const {},
    this.entityTypeCounts = const {},
    required this.periodStart,
    required this.periodEnd,
    this.topUsers = const [],
    this.topActions = const [],
  });

  double get successRate {
    if (totalLogs == 0) return 0.0;
    return (successfulActions / totalLogs) * 100;
  }

  double get failureRate {
    if (totalLogs == 0) return 0.0;
    return (failedActions / totalLogs) * 100;
  }

  factory AuditLogSummary.fromJson(Map<String, dynamic> json) =>
      _$AuditLogSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$AuditLogSummaryToJson(this);
}

enum AuditEntityType {
  user,
  driver,
  ride,
  payment,
  vehicle,
  document,
  system,
  config,
  report,
  notification,
}

enum AuditSeverity {
  info,
  warning,
  error,
  critical,
}

enum AuditResult {
  success,
  failure,
  partial,
}
