import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import '../rides/location_point.dart';

part 'eta_update.g.dart';

@JsonSerializable()
class EtaUpdate extends SerializableEntity {
  @override
  int? id;

  String updateId;
  String rideId;
  int? driverId;
  EtaType etaType;

  // ETA information
  int etaSeconds;
  double distanceMeters;
  DateTime timestamp;
  LocationPoint? currentLocation;
  LocationPoint? targetLocation;

  // Traffic and route information
  TrafficCondition trafficCondition;
  String? routeInfo;
  double? averageSpeed; // km/h
  List<TrafficIncident>? incidents;

  // Accuracy and confidence
  double confidenceLevel; // 0-1
  String dataSource; // 'gps', 'maps_api', 'estimated'
  DateTime? lastLocationUpdate;

  // Historical comparison
  int? previousEtaSeconds;
  EtaChangeReason? changeReason;
  int? originalEtaSeconds; // ETA when ride started

  EtaUpdate({
    this.id,
    required this.updateId,
    required this.rideId,
    this.driverId,
    required this.etaType,
    required this.etaSeconds,
    required this.distanceMeters,
    required this.timestamp,
    this.currentLocation,
    this.targetLocation,
    this.trafficCondition = TrafficCondition.unknown,
    this.routeInfo,
    this.averageSpeed,
    this.incidents,
    this.confidenceLevel = 1.0,
    this.dataSource = 'gps',
    this.lastLocationUpdate,
    this.previousEtaSeconds,
    this.changeReason,
    this.originalEtaSeconds,
  });

  // Formatted display strings
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

  String get formattedSpeed {
    if (averageSpeed == null) return 'Unknown';
    return '${averageSpeed!.round()} km/h';
  }

  // ETA change analysis
  int? get etaChangeDelta {
    if (previousEtaSeconds == null) return null;
    return etaSeconds - previousEtaSeconds!;
  }

  bool get etaImproved => etaChangeDelta != null && etaChangeDelta! < 0;
  bool get etaWorsened => etaChangeDelta != null && etaChangeDelta! > 0;
  bool get etaUnchanged => etaChangeDelta != null && etaChangeDelta! == 0;

  String? get etaChangeDescription {
    if (etaChangeDelta == null) return null;

    final deltaMinutes = (etaChangeDelta!.abs() / 60).round();
    if (deltaMinutes == 0) return 'No change';

    final direction = etaImproved ? 'faster' : 'slower';
    return '$deltaMinutes min $direction';
  }

  // Reliability assessment
  ReliabilityLevel get reliabilityLevel {
    if (confidenceLevel >= 0.9) return ReliabilityLevel.high;
    if (confidenceLevel >= 0.7) return ReliabilityLevel.medium;
    if (confidenceLevel >= 0.5) return ReliabilityLevel.low;
    return ReliabilityLevel.veryLow;
  }

  // Traffic impact assessment
  bool get hasTrafficImpact => incidents != null && incidents!.isNotEmpty;

  int get totalTrafficDelay {
    if (incidents == null) return 0;
    return incidents!.fold(
        0, (sum, incident) => sum + (incident.estimatedDelaySeconds ?? 0));
  }

  factory EtaUpdate.fromJson(Map<String, dynamic> json) =>
      _$EtaUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$EtaUpdateToJson(this);
}

@JsonSerializable()
class TrafficIncident extends SerializableEntity {
  @override
  int? id;

  String incidentId;
  IncidentType type;
  String description;
  LocationPoint location;
  IncidentSeverity severity;
  int? estimatedDelaySeconds;
  DateTime? estimatedClearanceTime;
  bool isActive;
  DateTime reportedAt;
  String? source; // 'traffic_api', 'user_report', 'sensor'

  TrafficIncident({
    this.id,
    required this.incidentId,
    required this.type,
    required this.description,
    required this.location,
    required this.severity,
    this.estimatedDelaySeconds,
    this.estimatedClearanceTime,
    this.isActive = true,
    required this.reportedAt,
    this.source,
  });

  String get formattedDelay {
    if (estimatedDelaySeconds == null) return 'Unknown delay';
    final minutes = (estimatedDelaySeconds! / 60).round();
    return '$minutes min delay';
  }

  bool get isCleared =>
      !isActive ||
      (estimatedClearanceTime != null &&
          DateTime.now().isAfter(estimatedClearanceTime!));

  factory TrafficIncident.fromJson(Map<String, dynamic> json) =>
      _$TrafficIncidentFromJson(json);
  Map<String, dynamic> toJson() => _$TrafficIncidentToJson(this);
}

@JsonSerializable()
class EtaHistory extends SerializableEntity {
  @override
  int? id;

  String rideId;
  List<EtaUpdate> updates;
  DateTime startTime;
  DateTime? endTime;

  // Summary statistics
  int? initialEtaSeconds;
  int? finalEtaSeconds;
  int? actualDurationSeconds;
  double averageAccuracy;
  int totalUpdates;

  EtaHistory({
    this.id,
    required this.rideId,
    this.updates = const [],
    required this.startTime,
    this.endTime,
    this.initialEtaSeconds,
    this.finalEtaSeconds,
    this.actualDurationSeconds,
    this.averageAccuracy = 0.0,
    this.totalUpdates = 0,
  });

  // Calculate ETA accuracy
  double? get finalAccuracy {
    if (finalEtaSeconds == null || actualDurationSeconds == null) return null;
    final error = (finalEtaSeconds! - actualDurationSeconds!).abs();
    final errorPercentage = error / actualDurationSeconds! * 100;
    return math.max(0, 100 - errorPercentage);
  }

  // Get ETA trend
  EtaTrend get etaTrend {
    if (updates.length < 2) return EtaTrend.stable;

    final recent = updates.take(3).toList();
    if (recent.length < 2) return EtaTrend.stable;

    final isImproving = recent.last.etaSeconds < recent.first.etaSeconds;
    final isWorsening = recent.last.etaSeconds > recent.first.etaSeconds;

    if (isImproving) return EtaTrend.improving;
    if (isWorsening) return EtaTrend.worsening;
    return EtaTrend.stable;
  }

  factory EtaHistory.fromJson(Map<String, dynamic> json) =>
      _$EtaHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$EtaHistoryToJson(this);
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
  vehicleBreakdown,
  specialEvent,
  other,
}

enum IncidentSeverity {
  low,
  medium,
  high,
  critical,
}

enum EtaChangeReason {
  trafficImproved,
  trafficWorsened,
  routeChanged,
  speedChanged,
  incidentCleared,
  newIncident,
  gpsUpdate,
  recalculation,
}

enum ReliabilityLevel {
  veryLow,
  low,
  medium,
  high,
}

enum EtaTrend {
  improving,
  stable,
  worsening,
}
