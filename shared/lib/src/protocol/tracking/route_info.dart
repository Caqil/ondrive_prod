import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../rides/location_point.dart';
import 'location_update.dart';

part 'route_info.g.dart';

@JsonSerializable()
class RouteInfo extends SerializableEntity {
  @override
  int? id;

  String routeId;
  String rideId;
  List<LocationPoint> waypoints;
  double totalDistance; // in meters
  int estimatedDuration; // in seconds
  String? encodedPolyline;
  List<RouteStep>? steps;
  TrafficInfo? trafficInfo;
  DateTime calculatedAt;
  DateTime? lastUpdatedAt;

  // Route options and preferences
  RouteType routeType;
  bool avoidTolls;
  bool avoidHighways;
  bool avoidFerries;

  // Alternative routes
  List<AlternativeRoute>? alternatives;

  // Real-time updates
  List<RouteUpdate>? updates;
  RouteStatus status;

  RouteInfo({
    this.id,
    required this.routeId,
    required this.rideId,
    this.waypoints = const [],
    required this.totalDistance,
    required this.estimatedDuration,
    this.encodedPolyline,
    this.steps,
    this.trafficInfo,
    required this.calculatedAt,
    this.lastUpdatedAt,
    this.routeType = RouteType.fastest,
    this.avoidTolls = false,
    this.avoidHighways = false,
    this.avoidFerries = false,
    this.alternatives,
    this.updates,
    this.status = RouteStatus.active,
  });

  // Formatted display values
  String get formattedDistance {
    if (totalDistance < 1000) {
      return '${totalDistance.round()} m';
    } else {
      final km = totalDistance / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  String get formattedDuration {
    final minutes = (estimatedDuration / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  // Route analysis
  double get averageSpeed {
    if (estimatedDuration == 0) return 0;
    return (totalDistance / 1000) / (estimatedDuration / 3600); // km/h
  }

  bool get hasTrafficDelays => trafficInfo != null && trafficInfo!.hasDelays;

  int get trafficDelaySeconds => trafficInfo?.totalDelaySeconds ?? 0;

  String get trafficDescription =>
      trafficInfo?.description ?? 'No traffic data';

  // Route comparison with alternatives
  AlternativeRoute? get fastestAlternative {
    if (alternatives == null || alternatives!.isEmpty) return null;
    return alternatives!
        .reduce((a, b) => a.estimatedDuration < b.estimatedDuration ? a : b);
  }

  AlternativeRoute? get shortestAlternative {
    if (alternatives == null || alternatives!.isEmpty) return null;
    return alternatives!
        .reduce((a, b) => a.totalDistance < b.totalDistance ? a : b);
  }

  // Update route with new information
  void updateRoute({
    double? newDistance,
    int? newDuration,
    TrafficInfo? newTrafficInfo,
    List<RouteStep>? newSteps,
  }) {
    if (newDistance != null) totalDistance = newDistance;
    if (newDuration != null) estimatedDuration = newDuration;
    if (newTrafficInfo != null) trafficInfo = newTrafficInfo;
    if (newSteps != null) steps = newSteps;
    lastUpdatedAt = DateTime.now();

    // Add update record
    final update = RouteUpdate(
      updateId: 'update_${DateTime.now().millisecondsSinceEpoch}',
      routeId: routeId,
      updateType: RouteUpdateType.recalculation,
      timestamp: DateTime.now(),
      previousDistance: totalDistance,
      newDistance: newDistance,
      previousDuration: estimatedDuration,
      newDuration: newDuration,
    );

    final newUpdates = List<RouteUpdate>.from(updates ?? []);
    newUpdates.add(update);
  }

  factory RouteInfo.fromJson(Map<String, dynamic> json) =>
      _$RouteInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);
}

@JsonSerializable()
class RouteStep extends SerializableEntity {
  @override
  int? id;

  int stepNumber;
  String instruction;
  double distance; // in meters
  int duration; // in seconds
  LocationPoint startLocation;
  LocationPoint endLocation;
  String? maneuver; // 'turn-left', 'turn-right', 'straight', etc.
  String? roadName;

  // Navigation details
  double? heading; // degrees
  String? exitNumber;
  String? signpostText;

  RouteStep({
    this.id,
    required this.stepNumber,
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    this.maneuver,
    this.roadName,
    this.heading,
    this.exitNumber,
    this.signpostText,
  });

  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      final km = distance / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  factory RouteStep.fromJson(Map<String, dynamic> json) =>
      _$RouteStepFromJson(json);
  Map<String, dynamic> toJson() => _$RouteStepToJson(this);
}

@JsonSerializable()
class TrafficInfo extends SerializableEntity {
  @override
  int? id;

  TrafficCondition overallCondition;
  int totalDelaySeconds;
  String description;
  List<TrafficSegment>? segments;
  List<TrafficIncident>? incidents;
  DateTime lastUpdatedAt;

  TrafficInfo({
    this.id,
    required this.overallCondition,
    this.totalDelaySeconds = 0,
    required this.description,
    this.segments,
    this.incidents,
    required this.lastUpdatedAt,
  });

  bool get hasDelays => totalDelaySeconds > 0;

  String get formattedDelay {
    if (totalDelaySeconds == 0) return 'No delays';
    final minutes = (totalDelaySeconds / 60).round();
    return '$minutes min delay';
  }


  factory TrafficInfo.fromJson(Map<String, dynamic> json) =>
      _$TrafficInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficInfoToJson(this);
}

@JsonSerializable()
class TrafficSegment extends SerializableEntity {
  @override
  int? id;

  LocationPoint startLocation;
  LocationPoint endLocation;
  double segmentDistance; // in meters
  TrafficCondition condition;
  double averageSpeed; // km/h
  double freeFlowSpeed; // km/h
  int delaySeconds;

  TrafficSegment({
    this.id,
    required this.startLocation,
    required this.endLocation,
    required this.segmentDistance,
    required this.condition,
    required this.averageSpeed,
    required this.freeFlowSpeed,
    this.delaySeconds = 0,
  });

  double get speedRatio => averageSpeed / freeFlowSpeed;
  bool get isCongested => speedRatio < 0.5;

  factory TrafficSegment.fromJson(Map<String, dynamic> json) =>
      _$TrafficSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficSegmentToJson(this);
}

@JsonSerializable()
class AlternativeRoute extends SerializableEntity {
  @override
  int? id;

  String alternativeId;
  String name;
  String description;
  double totalDistance; // in meters
  int estimatedDuration; // in seconds
  String? encodedPolyline;
  List<RouteStep>? steps;
  TrafficInfo? trafficInfo;

  // Comparison with main route
  double distanceDifference; // in meters
  int timeDifference; // in seconds
  bool isRecommended;
  String? recommendationReason;

  AlternativeRoute({
    this.id,
    required this.alternativeId,
    required this.name,
    required this.description,
    required this.totalDistance,
    required this.estimatedDuration,
    this.encodedPolyline,
    this.steps,
    this.trafficInfo,
    required this.distanceDifference,
    required this.timeDifference,
    this.isRecommended = false,
    this.recommendationReason,
  });

  bool get isFaster => timeDifference < 0;
  bool get isShorter => distanceDifference < 0;

  String get comparisonText {
    final timeDesc = isFaster
        ? '${(-timeDifference / 60).round()} min faster'
        : '${(timeDifference / 60).round()} min slower';
    final distDesc = isShorter
        ? '${(-distanceDifference / 1000).toStringAsFixed(1)} km shorter'
        : '${(distanceDifference / 1000).toStringAsFixed(1)} km longer';
    return '$timeDesc, $distDesc';
  }

  factory AlternativeRoute.fromJson(Map<String, dynamic> json) =>
      _$AlternativeRouteFromJson(json);
  Map<String, dynamic> toJson() => _$AlternativeRouteToJson(this);
}

@JsonSerializable()
class RouteUpdate extends SerializableEntity {
  @override
  int? id;

  String updateId;
  String routeId;
  RouteUpdateType updateType;
  DateTime timestamp;
  String? reason;

  // Before/after comparison
  double? previousDistance;
  double? newDistance;
  int? previousDuration;
  int? newDuration;

  Map<String, dynamic>? updateData;

  RouteUpdate({
    this.id,
    required this.updateId,
    required this.routeId,
    required this.updateType,
    required this.timestamp,
    this.reason,
    this.previousDistance,
    this.newDistance,
    this.previousDuration,
    this.newDuration,
    this.updateData,
  });

  double? get distanceChange =>
      (newDistance != null && previousDistance != null)
          ? newDistance! - previousDistance!
          : null;

  int? get durationChange => (newDuration != null && previousDuration != null)
      ? newDuration! - previousDuration!
      : null;

  factory RouteUpdate.fromJson(Map<String, dynamic> json) =>
      _$RouteUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$RouteUpdateToJson(this);
}

enum RouteType {
  fastest,
  shortest,
  balanced,
  scenic,
  ecoFriendly,
}

enum RouteStatus {
  active,
  completed,
  cancelled,
  rerouted,
}

enum RouteUpdateType {
  trafficUpdate,
  recalculation,
  incidentDetected,
  incidentCleared,
  wayPointAdded,
  wayPointRemoved,
  reroute,
}
