import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report extends SerializableEntity {
  @override
  int? id;

  String reportId;
  String name;
  String? description;
  ReportType reportType;
  ReportFormat format;
  Map<String, dynamic> parameters;
  Map<String, dynamic>? data;
  ReportStatus status;
  DateTime requestedAt;
  DateTime? generatedAt;
  DateTime? completedAt;
  int requestedBy;
  String? fileUrl;
  String? fileName;
  int? fileSizeBytes;
  String? errorMessage;
  double? progressPercentage;
  DateTime? expiresAt;
  bool isPublic;
  List<String>? tags;
  Map<String, dynamic>? metadata;

  Report({
    this.id,
    required this.reportId,
    required this.name,
    this.description,
    required this.reportType,
    this.format = ReportFormat.pdf,
    required this.parameters,
    this.data,
    this.status = ReportStatus.pending,
    required this.requestedAt,
    this.generatedAt,
    this.completedAt,
    required this.requestedBy,
    this.fileUrl,
    this.fileName,
    this.fileSizeBytes,
    this.errorMessage,
    this.progressPercentage,
    this.expiresAt,
    this.isPublic = false,
    this.tags,
    this.metadata,
  });

  bool get isCompleted => status == ReportStatus.completed;
  bool get isFailed => status == ReportStatus.failed;
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  String get formattedFileSize {
    if (fileSizeBytes == null) return 'Unknown';
    final kb = fileSizeBytes! / 1024;
    final mb = kb / 1024;
    if (mb >= 1) return '${mb.toStringAsFixed(1)} MB';
    return '${kb.toStringAsFixed(1)} KB';
  }

  Duration? get generationDuration {
    if (generatedAt == null || completedAt == null) return null;
    return completedAt!.difference(generatedAt!);
  }

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class ReportTemplate extends SerializableEntity {
  @override
  int? id;

  String templateId;
  String name;
  String? description;
  ReportType reportType;
  Map<String, dynamic> defaultParameters;
  Map<String, dynamic> schema; // JSON schema for parameters
  String query; // SQL or aggregation query
  String? template; // Report template markup
  List<ReportFormat> supportedFormats;
  bool isActive;
  DateTime createdAt;
  DateTime? updatedAt;
  int createdBy;
  List<String> requiredPermissions;

  ReportTemplate({
    this.id,
    required this.templateId,
    required this.name,
    this.description,
    required this.reportType,
    this.defaultParameters = const {},
    this.schema = const {},
    required this.query,
    this.template,
    this.supportedFormats = const [ReportFormat.pdf],
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.requiredPermissions = const [],
  });

  factory ReportTemplate.fromJson(Map<String, dynamic> json) =>
      _$ReportTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ReportTemplateToJson(this);
}

@JsonSerializable()
class ReportSchedule extends SerializableEntity {
  @override
  int? id;

  String scheduleId;
  String name;
  String reportTemplateId;
  Map<String, dynamic> parameters;
  ReportFormat format;
  ScheduleFrequency frequency;
  String cronExpression;
  DateTime nextRunAt;
  DateTime? lastRunAt;
  bool isActive;
  List<String> emailRecipients;
  bool autoDelete;
  int? retentionDays;
  DateTime createdAt;
  int createdBy;

  ReportSchedule({
    this.id,
    required this.scheduleId,
    required this.name,
    required this.reportTemplateId,
    this.parameters = const {},
    this.format = ReportFormat.pdf,
    required this.frequency,
    required this.cronExpression,
    required this.nextRunAt,
    this.lastRunAt,
    this.isActive = true,
    this.emailRecipients = const [],
    this.autoDelete = true,
    this.retentionDays = 30,
    required this.createdAt,
    required this.createdBy,
  });

  factory ReportSchedule.fromJson(Map<String, dynamic> json) =>
      _$ReportScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$ReportScheduleToJson(this);
}

@JsonSerializable()
class ReportData extends SerializableEntity {
  @override
  int? id;

  String reportId;
  List<Map<String, dynamic>> rows;
  List<String> columns;
  Map<String, dynamic>? summary;
  Map<String, dynamic>? metadata;
  int totalRows;
  DateTime generatedAt;

  ReportData({
    this.id,
    required this.reportId,
    this.rows = const [],
    this.columns = const [],
    this.summary,
    this.metadata,
    required this.totalRows,
    required this.generatedAt,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}

enum ReportType {
  userActivity,
  driverPerformance,
  rideAnalytics,
  revenue,
  disputes,
  systemHealth,
  customQuery,
  auditLog,
  financial,
  operational,
}

enum ReportFormat {
  pdf,
  excel,
  csv,
  json,
  html,
}

enum ReportStatus {
  pending,
  generating,
  completed,
  failed,
  cancelled,
  expired,
}

enum ScheduleFrequency {
  hourly,
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}
