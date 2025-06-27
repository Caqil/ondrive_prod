import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_status.g.dart';

@JsonSerializable()
class DriverStatus extends SerializableEntity {
  @override
  int? id;

  int driverId;
  DriverAvailabilityStatus availabilityStatus;
  DriverOnlineStatus onlineStatus;
  DriverVerificationStatus verificationStatus;
  DriverActivityStatus activityStatus;
  DateTime lastStatusChange;
  DateTime? lastActiveAt;
  String? currentRideId;
  Map<String, dynamic>? statusMetadata;

  // Work session info
  DateTime? workSessionStarted;
  Duration? workSessionDuration;
  int ridesCompletedToday;
  double earningsToday;

  // Vehicle status
  String? currentVehicleId;
  VehicleStatus? vehicleStatus;

  // Location context
  String? currentCity;
  String? currentArea;
  bool isInServiceArea;

  DriverStatus({
    this.id,
    required this.driverId,
    this.availabilityStatus = DriverAvailabilityStatus.unavailable,
    this.onlineStatus = DriverOnlineStatus.offline,
    this.verificationStatus = DriverVerificationStatus.pending,
    this.activityStatus = DriverActivityStatus.idle,
    required this.lastStatusChange,
    this.lastActiveAt,
    this.currentRideId,
    this.statusMetadata,
    this.workSessionStarted,
    this.workSessionDuration,
    this.ridesCompletedToday = 0,
    this.earningsToday = 0.0,
    this.currentVehicleId,
    this.vehicleStatus,
    this.currentCity,
    this.currentArea,
    this.isInServiceArea = true,
  });

  // Check if driver can accept rides
  bool get canAcceptRides {
    return onlineStatus == DriverOnlineStatus.online &&
        availabilityStatus == DriverAvailabilityStatus.available &&
        verificationStatus == DriverVerificationStatus.approved &&
        currentRideId == null &&
        isInServiceArea;
  }

  // Check if driver is actively working
  bool get isWorking {
    return workSessionStarted != null &&
        onlineStatus == DriverOnlineStatus.online;
  }

  // Get current work session duration
  Duration get currentWorkDuration {
    if (workSessionStarted == null) return Duration.zero;
    return DateTime.now().difference(workSessionStarted!);
  }

  // Check if driver has been inactive too long
  bool get isInactive {
    if (lastActiveAt == null) return false;
    return DateTime.now().difference(lastActiveAt!).inMinutes > 15;
  }

  // Get status summary
  String get statusSummary {
    if (!canAcceptRides) {
      if (verificationStatus != DriverVerificationStatus.approved) {
        return 'Verification Required';
      }
      if (!isInServiceArea) {
        return 'Outside Service Area';
      }
      if (currentRideId != null) {
        return 'On Trip';
      }
      return 'Unavailable';
    }
    return 'Available for Rides';
  }

  // Get detailed status description
  String get detailedStatus {
    final parts = <String>[];

    parts.add('Online: ${onlineStatus.name}');
    parts.add('Available: ${availabilityStatus.name}');
    parts.add('Verified: ${verificationStatus.name}');

    if (currentRideId != null) {
      parts.add('Current ride: $currentRideId');
    }

    if (ridesCompletedToday > 0) {
      parts.add('Rides today: $ridesCompletedToday');
    }

    return parts.join(', ');
  }

  factory DriverStatus.fromJson(Map<String, dynamic> json) =>
      _$DriverStatusFromJson(json);
  Map<String, dynamic> toJson() => _$DriverStatusToJson(this);
}

@JsonSerializable()
class DriverStatusHistory extends SerializableEntity {
  @override
  int? id;

  int driverId;
  DriverAvailabilityStatus previousStatus;
  DriverAvailabilityStatus newStatus;
  DateTime changedAt;
  String? reason;
  String? changedBy; // 'driver', 'system', 'admin'
  Map<String, dynamic>? context;

  DriverStatusHistory({
    this.id,
    required this.driverId,
    required this.previousStatus,
    required this.newStatus,
    required this.changedAt,
    this.reason,
    this.changedBy,
    this.context,
  });

  Duration get duration {
    // This would typically be calculated when the next status change occurs
    return Duration.zero;
  }

  factory DriverStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$DriverStatusHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$DriverStatusHistoryToJson(this);
}

@JsonSerializable()
class WorkSession extends SerializableEntity {
  @override
  int? id;

  String sessionId;
  int driverId;
  DateTime startTime;
  DateTime? endTime;
  Duration? totalDuration;
  int ridesCompleted;
  double totalEarnings;
  double totalDistance; // km
  WorkSessionStatus status;
  String? endReason;
  Map<String, dynamic>? analytics;

  WorkSession({
    this.id,
    required this.sessionId,
    required this.driverId,
    required this.startTime,
    this.endTime,
    this.totalDuration,
    this.ridesCompleted = 0,
    this.totalEarnings = 0.0,
    this.totalDistance = 0.0,
    this.status = WorkSessionStatus.active,
    this.endReason,
    this.analytics,
  });

  // Calculate session duration
  Duration get currentDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  // Calculate hourly earnings
  double get hourlyEarnings {
    final hours = currentDuration.inMinutes / 60.0;
    return hours > 0 ? totalEarnings / hours : 0.0;
  }

  // Calculate average earnings per ride
  double get averageEarningsPerRide {
    return ridesCompleted > 0 ? totalEarnings / ridesCompleted : 0.0;
  }

  factory WorkSession.fromJson(Map<String, dynamic> json) =>
      _$WorkSessionFromJson(json);
  Map<String, dynamic> toJson() => _$WorkSessionToJson(this);
}

enum DriverAvailabilityStatus {
  available,
  unavailable,
  busy,
  onTrip,
  breakTime,
  maintenance,
}

enum DriverOnlineStatus {
  online,
  offline,
  away,
  doNotDisturb,
}

enum DriverVerificationStatus {
  pending,
  documentsSubmitted,
  underReview,
  approved,
  rejected,
  requiresUpdate,
  suspended,
}

enum DriverActivityStatus {
  idle,
  driving,
  pickingUp,
  onTrip,
  waiting,
  refueling,
  maintenance,
}

enum VehicleStatus {
  operational,
  maintenance,
  refueling,
  inspection,
  outOfService,
}

enum WorkSessionStatus {
  active,
  completed,
  terminated,
  suspended,
}
