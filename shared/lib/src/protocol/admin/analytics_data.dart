import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'analytics_data.g.dart';

@JsonSerializable()
class AnalyticsData extends SerializableEntity {
  @override
  int? id;

  String metricName;
  double value;
  String? unit;
  DateTime timestamp;
  AnalyticsPeriod period;
  Map<String, dynamic>? dimensions;
  Map<String, dynamic>? metadata;
  String? source;
  AnalyticsCategory category;

  AnalyticsData({
    this.id,
    required this.metricName,
    required this.value,
    this.unit,
    required this.timestamp,
    required this.period,
    this.dimensions,
    this.metadata,
    this.source,
    required this.category,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsDataToJson(this);
}

@JsonSerializable()
class AnalyticsMetric extends SerializableEntity {
  @override
  int? id;

  String name;
  String displayName;
  String? description;
  AnalyticsCategory category;
  MetricType type;
  String? unit;
  Map<String, dynamic>? configuration;
  bool isActive;
  DateTime createdAt;
  DateTime? updatedAt;

  AnalyticsMetric({
    this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.category,
    required this.type,
    this.unit,
    this.configuration,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory AnalyticsMetric.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsMetricFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsMetricToJson(this);
}

@JsonSerializable()
class AnalyticsDashboard extends SerializableEntity {
  @override
  int? id;

  String dashboardId;
  String name;
  String? description;
  List<DashboardWidget> widgets;
  Map<String, dynamic>? layout;
  bool isPublic;
  int createdBy;
  DateTime createdAt;
  DateTime? updatedAt;
  List<String>? tags;

  AnalyticsDashboard({
    this.id,
    required this.dashboardId,
    required this.name,
    this.description,
    this.widgets = const [],
    this.layout,
    this.isPublic = false,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.tags,
  });

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDashboardFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsDashboardToJson(this);
}

@JsonSerializable()
class DashboardWidget extends SerializableEntity {
  @override
  int? id;

  String widgetId;
  String title;
  WidgetType type;
  String metricName;
  Map<String, dynamic> configuration;
  Map<String, dynamic>? filters;
  int? refreshInterval; // seconds
  int positionX;
  int positionY;
  int width;
  int height;

  DashboardWidget({
    this.id,
    required this.widgetId,
    required this.title,
    required this.type,
    required this.metricName,
    this.configuration = const {},
    this.filters,
    this.refreshInterval,
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) =>
      _$DashboardWidgetFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardWidgetToJson(this);
}

@JsonSerializable()
class AnalyticsQuery extends SerializableEntity {
  @override
  int? id;

  String queryId;
  String name;
  String? description;
  String query; // SQL or aggregation pipeline
  QueryType queryType;
  Map<String, dynamic>? parameters;
  List<String> requiredPermissions;
  bool isCached;
  int? cacheTimeoutSeconds;
  DateTime createdAt;
  int createdBy;

  AnalyticsQuery({
    this.id,
    required this.queryId,
    required this.name,
    this.description,
    required this.query,
    required this.queryType,
    this.parameters,
    this.requiredPermissions = const [],
    this.isCached = true,
    this.cacheTimeoutSeconds = 300,
    required this.createdAt,
    required this.createdBy,
  });

  factory AnalyticsQuery.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsQueryFromJson(json);
  Map<String, dynamic> toJson() => _$AnalyticsQueryToJson(this);
}

@JsonSerializable()
class KpiMetric extends SerializableEntity {
  @override
  int? id;

  String name;
  double currentValue;
  double? previousValue;
  double? targetValue;
  String? unit;
  KpiTrend trend;
  double? changePercentage;
  DateTime calculatedAt;
  AnalyticsPeriod period;
  Map<String, dynamic>? metadata;

  KpiMetric({
    this.id,
    required this.name,
    required this.currentValue,
    this.previousValue,
    this.targetValue,
    this.unit,
    required this.trend,
    this.changePercentage,
    required this.calculatedAt,
    required this.period,
    this.metadata,
  });

  bool get hasImproved => trend == KpiTrend.up;
  bool get hasDeclined => trend == KpiTrend.down;
  bool get isStable => trend == KpiTrend.stable;

  String get formattedChange {
    if (changePercentage == null) return 'N/A';
    final sign = changePercentage! >= 0 ? '+' : '';
    return '$sign${changePercentage!.toStringAsFixed(1)}%';
  }

  factory KpiMetric.fromJson(Map<String, dynamic> json) =>
      _$KpiMetricFromJson(json);
  Map<String, dynamic> toJson() => _$KpiMetricToJson(this);
}

enum AnalyticsPeriod {
  realTime,
  minute,
  hour,
  day,
  week,
  month,
  quarter,
  year,
}

enum AnalyticsCategory {
  rides,
  users,
  drivers,
  revenue,
  performance,
  system,
  marketing,
  support,
}

enum MetricType {
  counter,
  gauge,
  histogram,
  summary,
  rate,
  percentage,
}

enum WidgetType {
  chart,
  table,
  metric,
  map,
  funnel,
  heatmap,
  gauge,
  progress,
}

enum QueryType {
  sql,
  mongodb,
  aggregation,
  custom,
}

enum KpiTrend {
  up,
  down,
  stable,
  unknown,
}
