// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => AuditLog(
      id: (json['id'] as num?)?.toInt(),
      auditId: json['auditId'] as String,
      action: json['action'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      userEmail: json['userEmail'] as String?,
      userName: json['userName'] as String?,
      entityType: $enumDecode(_$AuditEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String?,
      entityName: json['entityName'] as String?,
      oldValues: json['oldValues'] as Map<String, dynamic>?,
      newValues: json['newValues'] as Map<String, dynamic>?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      sessionId: json['sessionId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: $enumDecodeNullable(_$AuditSeverityEnumMap, json['severity']) ??
          AuditSeverity.info,
      result: $enumDecodeNullable(_$AuditResultEnumMap, json['result']) ??
          AuditResult.success,
      errorMessage: json['errorMessage'] as String?,
      context: json['context'] as Map<String, dynamic>?,
      source: json['source'] as String?,
    );

Map<String, dynamic> _$AuditLogToJson(AuditLog instance) => <String, dynamic>{
      'id': instance.id,
      'auditId': instance.auditId,
      'action': instance.action,
      'userId': instance.userId,
      'userEmail': instance.userEmail,
      'userName': instance.userName,
      'entityType': _$AuditEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'entityName': instance.entityName,
      'oldValues': instance.oldValues,
      'newValues': instance.newValues,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'sessionId': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'severity': _$AuditSeverityEnumMap[instance.severity]!,
      'result': _$AuditResultEnumMap[instance.result]!,
      'errorMessage': instance.errorMessage,
      'context': instance.context,
      'source': instance.source,
    };

const _$AuditEntityTypeEnumMap = {
  AuditEntityType.user: 'user',
  AuditEntityType.driver: 'driver',
  AuditEntityType.ride: 'ride',
  AuditEntityType.payment: 'payment',
  AuditEntityType.vehicle: 'vehicle',
  AuditEntityType.document: 'document',
  AuditEntityType.system: 'system',
  AuditEntityType.config: 'config',
  AuditEntityType.report: 'report',
  AuditEntityType.notification: 'notification',
};

const _$AuditSeverityEnumMap = {
  AuditSeverity.info: 'info',
  AuditSeverity.warning: 'warning',
  AuditSeverity.error: 'error',
  AuditSeverity.critical: 'critical',
};

const _$AuditResultEnumMap = {
  AuditResult.success: 'success',
  AuditResult.failure: 'failure',
  AuditResult.partial: 'partial',
};

AuditLogFilter _$AuditLogFilterFromJson(Map<String, dynamic> json) =>
    AuditLogFilter(
      id: (json['id'] as num?)?.toInt(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      actions:
          (json['actions'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userIds: (json['userIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      entityTypes: (json['entityTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AuditEntityTypeEnumMap, e))
          .toList(),
      severities: (json['severities'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AuditSeverityEnumMap, e))
          .toList(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AuditResultEnumMap, e))
          .toList(),
      ipAddress: json['ipAddress'] as String?,
      searchTerm: json['searchTerm'] as String?,
      sources:
          (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AuditLogFilterToJson(AuditLogFilter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'actions': instance.actions,
      'userIds': instance.userIds,
      'entityTypes': instance.entityTypes
          ?.map((e) => _$AuditEntityTypeEnumMap[e]!)
          .toList(),
      'severities':
          instance.severities?.map((e) => _$AuditSeverityEnumMap[e]!).toList(),
      'results':
          instance.results?.map((e) => _$AuditResultEnumMap[e]!).toList(),
      'ipAddress': instance.ipAddress,
      'searchTerm': instance.searchTerm,
      'sources': instance.sources,
    };

AuditLogSummary _$AuditLogSummaryFromJson(Map<String, dynamic> json) =>
    AuditLogSummary(
      id: (json['id'] as num?)?.toInt(),
      totalLogs: (json['totalLogs'] as num).toInt(),
      successfulActions: (json['successfulActions'] as num).toInt(),
      failedActions: (json['failedActions'] as num).toInt(),
      criticalEvents: (json['criticalEvents'] as num).toInt(),
      actionCounts: (json['actionCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      severityCounts: (json['severityCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      entityTypeCounts:
          (json['entityTypeCounts'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      topUsers: (json['topUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      topActions: (json['topActions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AuditLogSummaryToJson(AuditLogSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalLogs': instance.totalLogs,
      'successfulActions': instance.successfulActions,
      'failedActions': instance.failedActions,
      'criticalEvents': instance.criticalEvents,
      'actionCounts': instance.actionCounts,
      'severityCounts': instance.severityCounts,
      'entityTypeCounts': instance.entityTypeCounts,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'topUsers': instance.topUsers,
      'topActions': instance.topActions,
    };
