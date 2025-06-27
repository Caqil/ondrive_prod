import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../rides/location_point.dart';

part 'location_update.g.dart';

@JsonSerializable()
class LocationUpdate extends SerializableEntity {
  @override
  int? id;

  int userId;
  String? rideId;
  double latitude;
  double longitude;
  double? altitude;
  double? accuracy;
  double? heading;
  double? speed;
  DateTime timestamp;
  LocationSource source;
  Map<String, dynamic>? metadata;

  LocationUpdate({
    this.id,
    required this.userId,
    this.rideId,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    required this.timestamp,
    this.source = LocationSource.gps,
    this.metadata,
  });

  factory LocationUpdate.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateToJson(this);
}

@JsonSerializable()
class TripTracking extends SerializableEntity {
  @override
  int? id;

  String rideId;
  List<LocationUpdate> route;
  double totalDistance; // in meters
  int totalDuration; // in seconds
  DateTime? startTime;
  DateTime? endTime;
  TrackingStatus status;
  Map<String, dynamic>? analytics;

  TripTracking({
    this.id,
    required this.rideId,
    this.route = const [],
    this.totalDistance = 0.0,
    this.totalDuration = 0,
    this.startTime,
    this.endTime,
    this.status = TrackingStatus.idle,
    this.analytics,
  });

  double get averageSpeed {
    if (totalDuration == 0) return 0.0;
    return (totalDistance / 1000) / (totalDuration / 3600); // km/h
  }

  factory TripTracking.fromJson(Map<String, dynamic> json) =>
      _$TripTrackingFromJson(json);
  Map<String, dynamic> toJson() => _$TripTrackingToJson(this);
}

@JsonSerializable()
class EtaUpdate extends SerializableEntity {
  @override
  int? id;

  String rideId;
  int etaSeconds;
  double distanceMeters;
  DateTime timestamp;
  EtaType etaType;
  String? trafficCondition;

  EtaUpdate({
    this.id,
    required this.rideId,
    required this.etaSeconds,
    required this.distanceMeters,
    required this.timestamp,
    required this.etaType,
    this.trafficCondition,
  });

  String get formattedEta {
    final minutes = (etaSeconds / 60).round();
    if (minutes < 1) return 'Less than 1 min';
    if (minutes == 1) return '1 min';
    if (minutes < 60) return '$minutes mins';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '$hours hr${hours > 1 ? 's' : ''}';
    return '$hours hr${hours > 1 ? 's' : ''} $remainingMinutes min${remainingMinutes > 1 ? 's' : ''}';
  }

  String get formattedDistance {
    if (distanceMeters < 1000) {
      return '${distanceMeters.round()} m';
    } else {
      final km = distanceMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  factory EtaUpdate.fromJson(Map<String, dynamic> json) =>
      _$EtaUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$EtaUpdateToJson(this);
}

@JsonSerializable()
class RouteInfo extends SerializableEntity {
  @override
  int? id;

  String rideId;
  List<LocationPoint> waypoints;
  double totalDistance; // in meters
  int estimatedDuration; // in seconds
  String? encodedPolyline;
  List<RouteStep>? steps;
  TrafficInfo? trafficInfo;
  DateTime calculatedAt;

  RouteInfo({
    this.id,
    required this.rideId,
    this.waypoints = const [],
    required this.totalDistance,
    required this.estimatedDuration,
    this.encodedPolyline,
    this.steps,
    this.trafficInfo,
    required this.calculatedAt,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) =>
      _$RouteInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);
}

@JsonSerializable()
class RouteStep extends SerializableEntity {
  @override
  int? id;

  String instruction;
  double distance; // in meters
  int duration; // in seconds
  LocationPoint startLocation;
  LocationPoint endLocation;
  String? maneuver;

  RouteStep({
    this.id,
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    this.maneuver,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) =>
      _$RouteStepFromJson(json);
  Map<String, dynamic> toJson() => _$RouteStepToJson(this);
}

@JsonSerializable()
class TrafficInfo extends SerializableEntity {
  @override
  int? id;

  TrafficCondition condition;
  int delaySeconds;
  String description;
  List<TrafficIncident>? incidents;

  TrafficInfo({
    this.id,
    required this.condition,
    this.delaySeconds = 0,
    required this.description,
    this.incidents,
  });

  factory TrafficInfo.fromJson(Map<String, dynamic> json) =>
      _$TrafficInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficInfoToJson(this);
}

@JsonSerializable()
class TrafficIncident extends SerializableEntity {
  @override
  int? id;

  String description;
  IncidentType type;
  LocationPoint location;
  int severityLevel; // 1-5
  int? estimatedClearanceTime;

  TrafficIncident({
    this.id,
    required this.description,
    required this.type,
    required this.location,
    required this.severityLevel,
    this.estimatedClearanceTime,
  });

  factory TrafficIncident.fromJson(Map<String, dynamic> json) =>
      _$TrafficIncidentFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficIncidentToJson(this);
}

enum LocationSource {
  gps,
  network,
  passive,
  manual,
}

enum TrackingStatus {
  idle,
  tracking,
  paused,
  completed,
  error,
}

enum EtaType {
  pickup,
  dropoff,
  waypoint,
}

enum TrafficCondition {
  light,
  moderate,
  heavy,
  severe,
  unknown,
}

enum IncidentType {
  accident,
  construction,
  roadClosure,
  weatherCondition,
  other,
}
