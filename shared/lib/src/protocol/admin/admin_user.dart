import 'dart:convert';

import 'package:ride_hailing_shared/src/protocol/admin/report.dart';
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


enum AuditSeverity {
  info,
  warning,
  error,
  critical,
}
