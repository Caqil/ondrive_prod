// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eta_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtaUpdate _$EtaUpdateFromJson(Map<String, dynamic> json) => EtaUpdate(
      id: (json['id'] as num?)?.toInt(),
      updateId: json['updateId'] as String,
      rideId: json['rideId'] as String,
      driverId: (json['driverId'] as num?)?.toInt(),
      etaType: $enumDecode(_$EtaTypeEnumMap, json['etaType']),
      etaSeconds: (json['etaSeconds'] as num).toInt(),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      currentLocation: json['currentLocation'] == null
          ? null
          : LocationPoint.fromJson(
              json['currentLocation'] as Map<String, dynamic>),
      targetLocation: json['targetLocation'] == null
          ? null
          : LocationPoint.fromJson(
              json['targetLocation'] as Map<String, dynamic>),
      trafficCondition: $enumDecodeNullable(
              _$TrafficConditionEnumMap, json['trafficCondition']) ??
          TrafficCondition.unknown,
      routeInfo: json['routeInfo'] as String?,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble(),
      incidents: (json['incidents'] as List<dynamic>?)
          ?.map((e) => TrafficIncident.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidenceLevel: (json['confidenceLevel'] as num?)?.toDouble() ?? 1.0,
      dataSource: json['dataSource'] as String? ?? 'gps',
      lastLocationUpdate: json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate'] as String),
      previousEtaSeconds: (json['previousEtaSeconds'] as num?)?.toInt(),
      changeReason:
          $enumDecodeNullable(_$EtaChangeReasonEnumMap, json['changeReason']),
      originalEtaSeconds: (json['originalEtaSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EtaUpdateToJson(EtaUpdate instance) => <String, dynamic>{
      'id': instance.id,
      'updateId': instance.updateId,
      'rideId': instance.rideId,
      'driverId': instance.driverId,
      'etaType': _$EtaTypeEnumMap[instance.etaType]!,
      'etaSeconds': instance.etaSeconds,
      'distanceMeters': instance.distanceMeters,
      'timestamp': instance.timestamp.toIso8601String(),
      'currentLocation': instance.currentLocation,
      'targetLocation': instance.targetLocation,
      'trafficCondition': _$TrafficConditionEnumMap[instance.trafficCondition]!,
      'routeInfo': instance.routeInfo,
      'averageSpeed': instance.averageSpeed,
      'incidents': instance.incidents,
      'confidenceLevel': instance.confidenceLevel,
      'dataSource': instance.dataSource,
      'lastLocationUpdate': instance.lastLocationUpdate?.toIso8601String(),
      'previousEtaSeconds': instance.previousEtaSeconds,
      'changeReason': _$EtaChangeReasonEnumMap[instance.changeReason],
      'originalEtaSeconds': instance.originalEtaSeconds,
    };

const _$EtaTypeEnumMap = {
  EtaType.pickup: 'pickup',
  EtaType.dropoff: 'dropoff',
  EtaType.waypoint: 'waypoint',
};

const _$TrafficConditionEnumMap = {
  TrafficCondition.light: 'light',
  TrafficCondition.moderate: 'moderate',
  TrafficCondition.heavy: 'heavy',
  TrafficCondition.severe: 'severe',
  TrafficCondition.unknown: 'unknown',
};

const _$EtaChangeReasonEnumMap = {
  EtaChangeReason.trafficImproved: 'trafficImproved',
  EtaChangeReason.trafficWorsened: 'trafficWorsened',
  EtaChangeReason.routeChanged: 'routeChanged',
  EtaChangeReason.speedChanged: 'speedChanged',
  EtaChangeReason.incidentCleared: 'incidentCleared',
  EtaChangeReason.newIncident: 'newIncident',
  EtaChangeReason.gpsUpdate: 'gpsUpdate',
  EtaChangeReason.recalculation: 'recalculation',
};

TrafficIncident _$TrafficIncidentFromJson(Map<String, dynamic> json) =>
    TrafficIncident(
      id: (json['id'] as num?)?.toInt(),
      incidentId: json['incidentId'] as String,
      type: $enumDecode(_$IncidentTypeEnumMap, json['type']),
      description: json['description'] as String,
      location:
          LocationPoint.fromJson(json['location'] as Map<String, dynamic>),
      severity: $enumDecode(_$IncidentSeverityEnumMap, json['severity']),
      estimatedDelaySeconds: (json['estimatedDelaySeconds'] as num?)?.toInt(),
      estimatedClearanceTime: json['estimatedClearanceTime'] == null
          ? null
          : DateTime.parse(json['estimatedClearanceTime'] as String),
      isActive: json['isActive'] as bool? ?? true,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      source: json['source'] as String?,
    );

Map<String, dynamic> _$TrafficIncidentToJson(TrafficIncident instance) =>
    <String, dynamic>{
      'id': instance.id,
      'incidentId': instance.incidentId,
      'type': _$IncidentTypeEnumMap[instance.type]!,
      'description': instance.description,
      'location': instance.location,
      'severity': _$IncidentSeverityEnumMap[instance.severity]!,
      'estimatedDelaySeconds': instance.estimatedDelaySeconds,
      'estimatedClearanceTime':
          instance.estimatedClearanceTime?.toIso8601String(),
      'isActive': instance.isActive,
      'reportedAt': instance.reportedAt.toIso8601String(),
      'source': instance.source,
    };

const _$IncidentTypeEnumMap = {
  IncidentType.accident: 'accident',
  IncidentType.construction: 'construction',
  IncidentType.roadClosure: 'roadClosure',
  IncidentType.weatherCondition: 'weatherCondition',
  IncidentType.vehicleBreakdown: 'vehicleBreakdown',
  IncidentType.specialEvent: 'specialEvent',
  IncidentType.other: 'other',
};

const _$IncidentSeverityEnumMap = {
  IncidentSeverity.low: 'low',
  IncidentSeverity.medium: 'medium',
  IncidentSeverity.high: 'high',
  IncidentSeverity.critical: 'critical',
};

EtaHistory _$EtaHistoryFromJson(Map<String, dynamic> json) => EtaHistory(
      id: (json['id'] as num?)?.toInt(),
      rideId: json['rideId'] as String,
      updates: (json['updates'] as List<dynamic>?)
              ?.map((e) => EtaUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      initialEtaSeconds: (json['initialEtaSeconds'] as num?)?.toInt(),
      finalEtaSeconds: (json['finalEtaSeconds'] as num?)?.toInt(),
      actualDurationSeconds: (json['actualDurationSeconds'] as num?)?.toInt(),
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0.0,
      totalUpdates: (json['totalUpdates'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EtaHistoryToJson(EtaHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'updates': instance.updates,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'initialEtaSeconds': instance.initialEtaSeconds,
      'finalEtaSeconds': instance.finalEtaSeconds,
      'actualDurationSeconds': instance.actualDurationSeconds,
      'averageAccuracy': instance.averageAccuracy,
      'totalUpdates': instance.totalUpdates,
    };
