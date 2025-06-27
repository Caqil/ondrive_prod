import 'dart:math' as math;

import 'package:ride_hailing_shared/src/protocol/tracking/location_update.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../rides/location_point.dart';
import '../rides/waypoint.dart';

part 'trip_tracking.g.dart';

@JsonSerializable()
class TripTracking extends SerializableEntity {
  @override
  int? id;

  String trackingId;
  String rideId;
  int driverId;
  int passengerId;

  // Route tracking
  List<LocationUpdate> route;
  List<Waypoint> waypoints;
  double totalDistance; // in meters
  int totalDuration; // in seconds
  DateTime? startTime;
  DateTime? endTime;

  // Current status
  TrackingStatus status;
  LocationPoint? currentLocation;
  double? currentSpeed; // km/h
  double? currentHeading; // degrees

  // Progress tracking
  double progressPercentage; // 0-100
  int? currentWaypointIndex;
  double? remainingDistance; // in meters
  int? remainingTime; // in seconds

  // Analytics and performance
  Map<String, dynamic>? analytics;
  double averageSpeed; // km/h
  double maxSpeed; // km/h
  int stopCount;
  int totalStopTime; // in seconds
  List<SpeedViolation>? speedViolations;
  List<GeofenceEvent>? geofenceEvents;

  // Environmental data
  double? fuelConsumed; // liters
  double? carbonEmission; // kg CO2

  // Safety and compliance
  List<SafetyEvent>? safetyEvents;
  bool isEmergencyModeActive;
  DateTime? lastHeartbeat;

  TripTracking({
    this.id,
    required this.trackingId,
    required this.rideId,
    required this.driverId,
    required this.passengerId,
    this.route = const [],
    this.waypoints = const [],
    this.totalDistance = 0.0,
    this.totalDuration = 0,
    this.startTime,
    this.endTime,
    this.status = TrackingStatus.idle,
    this.currentLocation,
    this.currentSpeed,
    this.currentHeading,
    this.progressPercentage = 0.0,
    this.currentWaypointIndex,
    this.remainingDistance,
    this.remainingTime,
    this.analytics,
    this.averageSpeed = 0.0,
    this.maxSpeed = 0.0,
    this.stopCount = 0,
    this.totalStopTime = 0,
    this.speedViolations,
    this.geofenceEvents,
    this.fuelConsumed,
    this.carbonEmission,
    this.safetyEvents,
    this.isEmergencyModeActive = false,
    this.lastHeartbeat,
  });

  // Trip duration calculations
  Duration? get currentDuration {
    if (startTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(startTime!);
  }

  Duration? get estimatedRemainingTime {
    if (remainingTime == null) return null;
    return Duration(seconds: remainingTime!);
  }

  // Speed analysis
  bool get isMoving => currentSpeed != null && currentSpeed! > 1.0;
  bool get isSpeeding =>
      speedViolations != null && speedViolations!.any((v) => v.isActive);

  // Progress calculations
  Waypoint? get currentWaypoint {
    if (currentWaypointIndex == null ||
        currentWaypointIndex! >= waypoints.length) return null;
    return waypoints[currentWaypointIndex!];
  }

  Waypoint? get nextWaypoint {
    final nextIndex = (currentWaypointIndex ?? 0) + 1;
    if (nextIndex >= waypoints.length) return null;
    return waypoints[nextIndex];
  }

  double get completedDistance => totalDistance * (progressPercentage / 100);

  // Environmental impact
  double get fuelEfficiency {
    if (fuelConsumed == null || totalDistance == 0) return 0.0;
    return (totalDistance / 1000) / fuelConsumed!; // km per liter
  }

  double get carbonEfficiency {
    if (carbonEmission == null || totalDistance == 0) return 0.0;
    return carbonEmission! / (totalDistance / 1000); // kg CO2 per km
  }

  // Safety assessment
  int get safetyScore {
    int score = 100;

    // Deduct for speed violations
    if (speedViolations != null) {
      score -= speedViolations!.length * 10;
    }

    // Deduct for safety events
    if (safetyEvents != null) {
      for (final event in safetyEvents!) {
        switch (event.severity) {
          case SafetySeverity.low:
            score -= 5;
            break;
          case SafetySeverity.medium:
            score -= 15;
            break;
          case SafetySeverity.high:
            score -= 30;
            break;
          case SafetySeverity.critical:
            score -= 50;
            break;
        }
      }
    }

    return math.max(0, score);
  }

  // Update tracking data
  void updateLocation(LocationUpdate locationUpdate) {
    route.add(locationUpdate);
    currentLocation = LocationPoint(
      latitude: locationUpdate.latitude,
      longitude: locationUpdate.longitude,
    );
    currentSpeed = locationUpdate.speed != null
        ? locationUpdate.speed! * 3.6
        : null; // Convert m/s to km/h
    currentHeading = locationUpdate.heading;
    lastHeartbeat = DateTime.now();

    // Update max speed
    if (currentSpeed != null && currentSpeed! > maxSpeed) {
      maxSpeed = currentSpeed!;
    }

    // Calculate progress
    _updateProgress();
  }

  void _updateProgress() {
    if (waypoints.isEmpty) return;

    // Simple progress calculation based on current waypoint
    if (currentWaypointIndex != null) {
      progressPercentage = (currentWaypointIndex! / waypoints.length) * 100;
    }
  }

  // Start/stop tracking
  void startTracking() {
    status = TrackingStatus.tracking;
    startTime = DateTime.now();
    lastHeartbeat = DateTime.now();
  }

  void pauseTracking() {
    status = TrackingStatus.paused;
  }

  void resumeTracking() {
    status = TrackingStatus.tracking;
    lastHeartbeat = DateTime.now();
  }

  void completeTracking() {
    status = TrackingStatus.completed;
    endTime = DateTime.now();
    progressPercentage = 100.0;

    // Calculate final analytics
    _calculateFinalAnalytics();
  }

  void _calculateFinalAnalytics() {
    if (route.isEmpty || totalDuration == 0) return;

    // Calculate average speed
    if (totalDistance > 0 && totalDuration > 0) {
      averageSpeed = (totalDistance / 1000) / (totalDuration / 3600);
    }

    // Update analytics
    analytics = {
      'total_distance_km': totalDistance / 1000,
      'total_duration_hours': totalDuration / 3600,
      'average_speed_kmh': averageSpeed,
      'max_speed_kmh': maxSpeed,
      'stop_count': stopCount,
      'total_stop_time_minutes': totalStopTime / 60,
      'safety_score': safetyScore,
      'route_points_count': route.length,
      'fuel_efficiency': fuelEfficiency,
      'carbon_footprint': carbonEmission,
    };
  }

  factory TripTracking.fromJson(Map<String, dynamic> json) =>
      _$TripTrackingFromJson(json);
  Map<String, dynamic> toJson() => _$TripTrackingToJson(this);
}

@JsonSerializable()
class SpeedViolation extends SerializableEntity {
  @override
  int? id;

  String violationId;
  String trackingId;
  double speedLimit; // km/h
  double recordedSpeed; // km/h
  double excessSpeed; // km/h over limit
  LocationPoint location;
  DateTime timestamp;
  int duration; // seconds of violation
  bool isActive;
  ViolationSeverity severity;

  SpeedViolation({
    this.id,
    required this.violationId,
    required this.trackingId,
    required this.speedLimit,
    required this.recordedSpeed,
    required this.excessSpeed,
    required this.location,
    required this.timestamp,
    this.duration = 0,
    this.isActive = true,
    required this.severity,
  });

  double get violationPercentage => (excessSpeed / speedLimit) * 100;

  factory SpeedViolation.fromJson(Map<String, dynamic> json) =>
      _$SpeedViolationFromJson(json);
  Map<String, dynamic> toJson() => _$SpeedViolationToJson(this);
}

@JsonSerializable()
class GeofenceEvent extends SerializableEntity {
  @override
  int? id;

  String eventId;
  String trackingId;
  String geofenceId;
  String geofenceName;
  GeofenceEventType eventType;
  LocationPoint location;
  DateTime timestamp;
  Map<String, dynamic>? eventData;

  GeofenceEvent({
    this.id,
    required this.eventId,
    required this.trackingId,
    required this.geofenceId,
    required this.geofenceName,
    required this.eventType,
    required this.location,
    required this.timestamp,
    this.eventData,
  });

  factory GeofenceEvent.fromJson(Map<String, dynamic> json) =>
      _$GeofenceEventFromJson(json);
  Map<String, dynamic> toJson() => _$GeofenceEventToJson(this);
}

@JsonSerializable()
class SafetyEvent extends SerializableEntity {
  @override
  int? id;

  String eventId;
  String trackingId;
  SafetyEventType eventType;
  SafetySeverity severity;
  String description;
  LocationPoint location;
  DateTime timestamp;
  bool isResolved;
  DateTime? resolvedAt;
  Map<String, dynamic>? eventData;

  SafetyEvent({
    this.id,
    required this.eventId,
    required this.trackingId,
    required this.eventType,
    required this.severity,
    required this.description,
    required this.location,
    required this.timestamp,
    this.isResolved = false,
    this.resolvedAt,
    this.eventData,
  });

  void resolve() {
    isResolved = true;
    resolvedAt = DateTime.now();
  }

  factory SafetyEvent.fromJson(Map<String, dynamic> json) =>
      _$SafetyEventFromJson(json);
  Map<String, dynamic> toJson() => _$SafetyEventToJson(this);
}

@JsonSerializable()
class TripSummary extends SerializableEntity {
  @override
  int? id;

  String rideId;
  String trackingId;
  DateTime startTime;
  DateTime endTime;

  // Distance and time
  double totalDistance; // in meters
  Duration totalDuration;
  Duration movingTime;
  Duration stoppedTime;

  // Speed analytics
  double averageSpeed; // km/h
  double maxSpeed; // km/h
  double averageMovingSpeed; // km/h

  // Route efficiency
  double routeEfficiency; // percentage vs optimal route
  int totalStops;
  double longestStop; // minutes

  // Safety metrics
  int safetyScore; // 0-100
  int speedViolations;
  int safetyEvents;

  // Environmental impact
  double? fuelConsumed; // liters
  double? carbonEmission; // kg CO2
  double? fuelEfficiency; // km/l

  // Cost analysis
  double? operatingCost;
  double? fuelCost;

  TripSummary({
    this.id,
    required this.rideId,
    required this.trackingId,
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.totalDuration,
    required this.movingTime,
    required this.stoppedTime,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.averageMovingSpeed,
    required this.routeEfficiency,
    required this.totalStops,
    required this.longestStop,
    required this.safetyScore,
    required this.speedViolations,
    required this.safetyEvents,
    this.fuelConsumed,
    this.carbonEmission,
    this.fuelEfficiency,
    this.operatingCost,
    this.fuelCost,
  });

  // Performance indicators
  String get efficiencyRating {
    if (routeEfficiency >= 90) return 'Excellent';
    if (routeEfficiency >= 80) return 'Good';
    if (routeEfficiency >= 70) return 'Fair';
    return 'Poor';
  }

  String get safetyRating {
    if (safetyScore >= 90) return 'Excellent';
    if (safetyScore >= 80) return 'Good';
    if (safetyScore >= 70) return 'Fair';
    return 'Poor';
  }

  // Environmental impact assessment
  String get ecoRating {
    if (fuelEfficiency == null) return 'Unknown';
    if (fuelEfficiency! >= 15) return 'Excellent';
    if (fuelEfficiency! >= 12) return 'Good';
    if (fuelEfficiency! >= 10) return 'Fair';
    return 'Poor';
  }

  factory TripSummary.fromJson(Map<String, dynamic> json) =>
      _$TripSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$TripSummaryToJson(this);
}

// Enums
enum TrackingStatus {
  idle,
  tracking,
  paused,
  completed,
  error,
}

enum LocationQuality {
  high,
  medium,
  low,
  poor,
  unknown,
}

enum ViolationSeverity {
  minor,
  moderate,
  major,
  severe,
}

enum GeofenceEventType {
  entered,
  exited,
  dwelling,
}

enum SafetyEventType {
  hardBraking,
  rapidAcceleration,
  sharpTurn,
  phoneUsage,
  fatigueDriving,
  emergencyStop,
  accident,
  other,
}

enum SafetySeverity {
  low,
  medium,
  high,
  critical,
}
