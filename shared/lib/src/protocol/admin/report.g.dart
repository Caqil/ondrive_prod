// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: (json['id'] as num?)?.toInt(),
      reportId: json['reportId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      reportType: $enumDecode(_$ReportTypeEnumMap, json['reportType']),
      format: $enumDecodeNullable(_$ReportFormatEnumMap, json['format']) ??
          ReportFormat.pdf,
      parameters: json['parameters'] as Map<String, dynamic>,
      data: json['data'] as Map<String, dynamic>?,
      status: $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.pending,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      requestedBy: (json['requestedBy'] as num).toInt(),
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble(),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isPublic: json['isPublic'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'reportId': instance.reportId,
      'name': instance.name,
      'description': instance.description,
      'reportType': _$ReportTypeEnumMap[instance.reportType]!,
      'format': _$ReportFormatEnumMap[instance.format]!,
      'parameters': instance.parameters,
      'data': instance.data,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'generatedAt': instance.generatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'requestedBy': instance.requestedBy,
      'fileUrl': instance.fileUrl,
      'fileName': instance.fileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'errorMessage': instance.errorMessage,
      'progressPercentage': instance.progressPercentage,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isPublic': instance.isPublic,
      'tags': instance.tags,
      'metadata': instance.metadata,
    };

const _$ReportTypeEnumMap = {
  ReportType.userActivity: 'userActivity',
  ReportType.driverPerformance: 'driverPerformance',
  ReportType.rideAnalytics: 'rideAnalytics',
  ReportType.revenue: 'revenue',
  ReportType.disputes: 'disputes',
  ReportType.systemHealth: 'systemHealth',
  ReportType.customQuery: 'customQuery',
  ReportType.auditLog: 'auditLog',
  ReportType.financial: 'financial',
  ReportType.operational: 'operational',
};

const _$ReportFormatEnumMap = {
  ReportFormat.pdf: 'pdf',
  ReportFormat.excel: 'excel',
  ReportFormat.csv: 'csv',
  ReportFormat.json: 'json',
  ReportFormat.html: 'html',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.generating: 'generating',
  ReportStatus.completed: 'completed',
  ReportStatus.failed: 'failed',
  ReportStatus.cancelled: 'cancelled',
  ReportStatus.expired: 'expired',
};

ReportTemplate _$ReportTemplateFromJson(Map<String, dynamic> json) =>
    ReportTemplate(
      id: (json['id'] as num?)?.toInt(),
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      reportType: $enumDecode(_$ReportTypeEnumMap, json['reportType']),
      defaultParameters:
          json['defaultParameters'] as Map<String, dynamic>? ?? const {},
      schema: json['schema'] as Map<String, dynamic>? ?? const {},
      query: json['query'] as String,
      template: json['template'] as String?,
      supportedFormats: (json['supportedFormats'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ReportFormatEnumMap, e))
              .toList() ??
          const [ReportFormat.pdf],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: (json['createdBy'] as num).toInt(),
      requiredPermissions: (json['requiredPermissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReportTemplateToJson(ReportTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'templateId': instance.templateId,
      'name': instance.name,
      'description': instance.description,
      'reportType': _$ReportTypeEnumMap[instance.reportType]!,
      'defaultParameters': instance.defaultParameters,
      'schema': instance.schema,
      'query': instance.query,
      'template': instance.template,
      'supportedFormats': instance.supportedFormats
          .map((e) => _$ReportFormatEnumMap[e]!)
          .toList(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'requiredPermissions': instance.requiredPermissions,
    };

ReportSchedule _$ReportScheduleFromJson(Map<String, dynamic> json) =>
    ReportSchedule(
      id: (json['id'] as num?)?.toInt(),
      scheduleId: json['scheduleId'] as String,
      name: json['name'] as String,
      reportTemplateId: json['reportTemplateId'] as String,
      parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
      format: $enumDecodeNullable(_$ReportFormatEnumMap, json['format']) ??
          ReportFormat.pdf,
      frequency: $enumDecode(_$ScheduleFrequencyEnumMap, json['frequency']),
      cronExpression: json['cronExpression'] as String,
      nextRunAt: DateTime.parse(json['nextRunAt'] as String),
      lastRunAt: json['lastRunAt'] == null
          ? null
          : DateTime.parse(json['lastRunAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      emailRecipients: (json['emailRecipients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      autoDelete: json['autoDelete'] as bool? ?? true,
      retentionDays: (json['retentionDays'] as num?)?.toInt() ?? 30,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: (json['createdBy'] as num).toInt(),
    );

Map<String, dynamic> _$ReportScheduleToJson(ReportSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'name': instance.name,
      'reportTemplateId': instance.reportTemplateId,
      'parameters': instance.parameters,
      'format': _$ReportFormatEnumMap[instance.format]!,
      'frequency': _$ScheduleFrequencyEnumMap[instance.frequency]!,
      'cronExpression': instance.cronExpression,
      'nextRunAt': instance.nextRunAt.toIso8601String(),
      'lastRunAt': instance.lastRunAt?.toIso8601String(),
      'isActive': instance.isActive,
      'emailRecipients': instance.emailRecipients,
      'autoDelete': instance.autoDelete,
      'retentionDays': instance.retentionDays,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$ScheduleFrequencyEnumMap = {
  ScheduleFrequency.hourly: 'hourly',
  ScheduleFrequency.daily: 'daily',
  ScheduleFrequency.weekly: 'weekly',
  ScheduleFrequency.monthly: 'monthly',
  ScheduleFrequency.quarterly: 'quarterly',
  ScheduleFrequency.yearly: 'yearly',
  ScheduleFrequency.custom: 'custom',
};

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
      id: (json['id'] as num?)?.toInt(),
      reportId: json['reportId'] as String,
      rows: (json['rows'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      columns: (json['columns'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      summary: json['summary'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      totalRows: (json['totalRows'] as num).toInt(),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reportId': instance.reportId,
      'rows': instance.rows,
      'columns': instance.columns,
      'summary': instance.summary,
      'metadata': instance.metadata,
      'totalRows': instance.totalRows,
      'generatedAt': instance.generatedAt.toIso8601String(),
    };
