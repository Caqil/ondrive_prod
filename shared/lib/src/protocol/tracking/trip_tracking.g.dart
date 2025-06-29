// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripTracking _$TripTrackingFromJson(Map<String, dynamic> json) => TripTracking(
      id: (json['id'] as num?)?.toInt(),
      trackingId: json['trackingId'] as String,
      rideId: json['rideId'] as String,
      driverId: (json['driverId'] as num).toInt(),
      passengerId: (json['passengerId'] as num).toInt(),
      route: (json['route'] as List<dynamic>?)
              ?.map((e) => LocationUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => Waypoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalDuration: (json['totalDuration'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: $enumDecodeNullable(_$TrackingStatusEnumMap, json['status']) ??
          TrackingStatus.idle,
      currentLocation: json['currentLocation'] == null
          ? null
          : LocationPoint.fromJson(
              json['currentLocation'] as Map<String, dynamic>),
      currentSpeed: (json['currentSpeed'] as num?)?.toDouble(),
      currentHeading: (json['currentHeading'] as num?)?.toDouble(),
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      currentWaypointIndex: (json['currentWaypointIndex'] as num?)?.toInt(),
      remainingDistance: (json['remainingDistance'] as num?)?.toDouble(),
      remainingTime: (json['remainingTime'] as num?)?.toInt(),
      analytics: json['analytics'] as Map<String, dynamic>?,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0.0,
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble() ?? 0.0,
      stopCount: (json['stopCount'] as num?)?.toInt() ?? 0,
      totalStopTime: (json['totalStopTime'] as num?)?.toInt() ?? 0,
      speedViolations: (json['speedViolations'] as List<dynamic>?)
          ?.map((e) => SpeedViolation.fromJson(e as Map<String, dynamic>))
          .toList(),
      geofenceEvents: (json['geofenceEvents'] as List<dynamic>?)
          ?.map((e) => GeofenceEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      fuelConsumed: (json['fuelConsumed'] as num?)?.toDouble(),
      carbonEmission: (json['carbonEmission'] as num?)?.toDouble(),
      safetyEvents: (json['safetyEvents'] as List<dynamic>?)
          ?.map((e) => SafetyEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      isEmergencyModeActive: json['isEmergencyModeActive'] as bool? ?? false,
      lastHeartbeat: json['lastHeartbeat'] == null
          ? null
          : DateTime.parse(json['lastHeartbeat'] as String),
    );

Map<String, dynamic> _$TripTrackingToJson(TripTracking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackingId': instance.trackingId,
      'rideId': instance.rideId,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'route': instance.route,
      'waypoints': instance.waypoints,
      'totalDistance': instance.totalDistance,
      'totalDuration': instance.totalDuration,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$TrackingStatusEnumMap[instance.status]!,
      'currentLocation': instance.currentLocation,
      'currentSpeed': instance.currentSpeed,
      'currentHeading': instance.currentHeading,
      'progressPercentage': instance.progressPercentage,
      'currentWaypointIndex': instance.currentWaypointIndex,
      'remainingDistance': instance.remainingDistance,
      'remainingTime': instance.remainingTime,
      'analytics': instance.analytics,
      'averageSpeed': instance.averageSpeed,
      'maxSpeed': instance.maxSpeed,
      'stopCount': instance.stopCount,
      'totalStopTime': instance.totalStopTime,
      'speedViolations': instance.speedViolations,
      'geofenceEvents': instance.geofenceEvents,
      'fuelConsumed': instance.fuelConsumed,
      'carbonEmission': instance.carbonEmission,
      'safetyEvents': instance.safetyEvents,
      'isEmergencyModeActive': instance.isEmergencyModeActive,
      'lastHeartbeat': instance.lastHeartbeat?.toIso8601String(),
    };

const _$TrackingStatusEnumMap = {
  TrackingStatus.idle: 'idle',
  TrackingStatus.tracking: 'tracking',
  TrackingStatus.paused: 'paused',
  TrackingStatus.completed: 'completed',
  TrackingStatus.error: 'error',
};

SpeedViolation _$SpeedViolationFromJson(Map<String, dynamic> json) =>
    SpeedViolation(
      id: (json['id'] as num?)?.toInt(),
      violationId: json['violationId'] as String,
      trackingId: json['trackingId'] as String,
      speedLimit: (json['speedLimit'] as num).toDouble(),
      recordedSpeed: (json['recordedSpeed'] as num).toDouble(),
      excessSpeed: (json['excessSpeed'] as num).toDouble(),
      location:
          LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      severity: $enumDecode(_$ViolationSeverityEnumMap, json['severity']),
    );

Map<String, dynamic> _$SpeedViolationToJson(SpeedViolation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'violationId': instance.violationId,
      'trackingId': instance.trackingId,
      'speedLimit': instance.speedLimit,
      'recordedSpeed': instance.recordedSpeed,
      'excessSpeed': instance.excessSpeed,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration,
      'isActive': instance.isActive,
      'severity': _$ViolationSeverityEnumMap[instance.severity]!,
    };

const _$ViolationSeverityEnumMap = {
  ViolationSeverity.minor: 'minor',
  ViolationSeverity.moderate: 'moderate',
  ViolationSeverity.major: 'major',
  ViolationSeverity.severe: 'severe',
};

GeofenceEvent _$GeofenceEventFromJson(Map<String, dynamic> json) =>
    GeofenceEvent(
      id: (json['id'] as num?)?.toInt(),
      eventId: json['eventId'] as String,
      trackingId: json['trackingId'] as String,
      geofenceId: json['geofenceId'] as String,
      geofenceName: json['geofenceName'] as String,
      eventType: $enumDecode(_$GeofenceEventTypeEnumMap, json['eventType']),
      location:
          LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      eventData: json['eventData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$GeofenceEventToJson(GeofenceEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'trackingId': instance.trackingId,
      'geofenceId': instance.geofenceId,
      'geofenceName': instance.geofenceName,
      'eventType': _$GeofenceEventTypeEnumMap[instance.eventType]!,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'eventData': instance.eventData,
    };

const _$GeofenceEventTypeEnumMap = {
  GeofenceEventType.entered: 'entered',
  GeofenceEventType.exited: 'exited',
  GeofenceEventType.dwelling: 'dwelling',
};

SafetyEvent _$SafetyEventFromJson(Map<String, dynamic> json) => SafetyEvent(
      id: (json['id'] as num?)?.toInt(),
      eventId: json['eventId'] as String,
      trackingId: json['trackingId'] as String,
      eventType: $enumDecode(_$SafetyEventTypeEnumMap, json['eventType']),
      severity: $enumDecode(_$SafetySeverityEnumMap, json['severity']),
      description: json['description'] as String,
      location:
          LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      eventData: json['eventData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SafetyEventToJson(SafetyEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'trackingId': instance.trackingId,
      'eventType': _$SafetyEventTypeEnumMap[instance.eventType]!,
      'severity': _$SafetySeverityEnumMap[instance.severity]!,
      'description': instance.description,
      'location': instance.location,
      'timestamp': instance.timestamp.toIso8601String(),
      'isResolved': instance.isResolved,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'eventData': instance.eventData,
    };

const _$SafetyEventTypeEnumMap = {
  SafetyEventType.hardBraking: 'hardBraking',
  SafetyEventType.rapidAcceleration: 'rapidAcceleration',
  SafetyEventType.sharpTurn: 'sharpTurn',
  SafetyEventType.phoneUsage: 'phoneUsage',
  SafetyEventType.fatigueDriving: 'fatigueDriving',
  SafetyEventType.emergencyStop: 'emergencyStop',
  SafetyEventType.accident: 'accident',
  SafetyEventType.other: 'other',
};

const _$SafetySeverityEnumMap = {
  SafetySeverity.low: 'low',
  SafetySeverity.medium: 'medium',
  SafetySeverity.high: 'high',
  SafetySeverity.critical: 'critical',
};

TripSummary _$TripSummaryFromJson(Map<String, dynamic> json) => TripSummary(
      id: (json['id'] as num?)?.toInt(),
      rideId: json['rideId'] as String,
      trackingId: json['trackingId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalDuration:
          Duration(microseconds: (json['totalDuration'] as num).toInt()),
      movingTime: Duration(microseconds: (json['movingTime'] as num).toInt()),
      stoppedTime: Duration(microseconds: (json['stoppedTime'] as num).toInt()),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      maxSpeed: (json['maxSpeed'] as num).toDouble(),
      averageMovingSpeed: (json['averageMovingSpeed'] as num).toDouble(),
      routeEfficiency: (json['routeEfficiency'] as num).toDouble(),
      totalStops: (json['totalStops'] as num).toInt(),
      longestStop: (json['longestStop'] as num).toDouble(),
      safetyScore: (json['safetyScore'] as num).toInt(),
      speedViolations: (json['speedViolations'] as num).toInt(),
      safetyEvents: (json['safetyEvents'] as num).toInt(),
      fuelConsumed: (json['fuelConsumed'] as num?)?.toDouble(),
      carbonEmission: (json['carbonEmission'] as num?)?.toDouble(),
      fuelEfficiency: (json['fuelEfficiency'] as num?)?.toDouble(),
      operatingCost: (json['operatingCost'] as num?)?.toDouble(),
      fuelCost: (json['fuelCost'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TripSummaryToJson(TripSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'trackingId': instance.trackingId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'totalDistance': instance.totalDistance,
      'totalDuration': instance.totalDuration.inMicroseconds,
      'movingTime': instance.movingTime.inMicroseconds,
      'stoppedTime': instance.stoppedTime.inMicroseconds,
      'averageSpeed': instance.averageSpeed,
      'maxSpeed': instance.maxSpeed,
      'averageMovingSpeed': instance.averageMovingSpeed,
      'routeEfficiency': instance.routeEfficiency,
      'totalStops': instance.totalStops,
      'longestStop': instance.longestStop,
      'safetyScore': instance.safetyScore,
      'speedViolations': instance.speedViolations,
      'safetyEvents': instance.safetyEvents,
      'fuelConsumed': instance.fuelConsumed,
      'carbonEmission': instance.carbonEmission,
      'fuelEfficiency': instance.fuelEfficiency,
      'operatingCost': instance.operatingCost,
      'fuelCost': instance.fuelCost,
    };
