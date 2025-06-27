// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) => RouteInfo(
      id: (json['id'] as num?)?.toInt(),
      routeId: json['routeId'] as String,
      rideId: json['rideId'] as String,
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => LocationPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalDistance: (json['totalDistance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      encodedPolyline: json['encodedPolyline'] as String?,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => RouteStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      trafficInfo: json['trafficInfo'] == null
          ? null
          : TrafficInfo.fromJson(json['trafficInfo'] as Map<String, dynamic>),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      lastUpdatedAt: json['lastUpdatedAt'] == null
          ? null
          : DateTime.parse(json['lastUpdatedAt'] as String),
      routeType: $enumDecodeNullable(_$RouteTypeEnumMap, json['routeType']) ??
          RouteType.fastest,
      avoidTolls: json['avoidTolls'] as bool? ?? false,
      avoidHighways: json['avoidHighways'] as bool? ?? false,
      avoidFerries: json['avoidFerries'] as bool? ?? false,
      alternatives: (json['alternatives'] as List<dynamic>?)
          ?.map((e) => AlternativeRoute.fromJson(e as Map<String, dynamic>))
          .toList(),
      updates: (json['updates'] as List<dynamic>?)
          ?.map((e) => RouteUpdate.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecodeNullable(_$RouteStatusEnumMap, json['status']) ??
          RouteStatus.active,
    );

Map<String, dynamic> _$RouteInfoToJson(RouteInfo instance) => <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'rideId': instance.rideId,
      'waypoints': instance.waypoints,
      'totalDistance': instance.totalDistance,
      'estimatedDuration': instance.estimatedDuration,
      'encodedPolyline': instance.encodedPolyline,
      'steps': instance.steps,
      'trafficInfo': instance.trafficInfo,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'lastUpdatedAt': instance.lastUpdatedAt?.toIso8601String(),
      'routeType': _$RouteTypeEnumMap[instance.routeType]!,
      'avoidTolls': instance.avoidTolls,
      'avoidHighways': instance.avoidHighways,
      'avoidFerries': instance.avoidFerries,
      'alternatives': instance.alternatives,
      'updates': instance.updates,
      'status': _$RouteStatusEnumMap[instance.status]!,
    };

const _$RouteTypeEnumMap = {
  RouteType.fastest: 'fastest',
  RouteType.shortest: 'shortest',
  RouteType.balanced: 'balanced',
  RouteType.scenic: 'scenic',
  RouteType.ecoFriendly: 'ecoFriendly',
};

const _$RouteStatusEnumMap = {
  RouteStatus.active: 'active',
  RouteStatus.completed: 'completed',
  RouteStatus.cancelled: 'cancelled',
  RouteStatus.rerouted: 'rerouted',
};

RouteStep _$RouteStepFromJson(Map<String, dynamic> json) => RouteStep(
      id: (json['id'] as num?)?.toInt(),
      stepNumber: (json['stepNumber'] as num).toInt(),
      instruction: json['instruction'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      startLocation:
          LocationPoint.fromJson(json['startLocation'] as Map<String, dynamic>),
      endLocation:
          LocationPoint.fromJson(json['endLocation'] as Map<String, dynamic>),
      maneuver: json['maneuver'] as String?,
      roadName: json['roadName'] as String?,
      heading: (json['heading'] as num?)?.toDouble(),
      exitNumber: json['exitNumber'] as String?,
      signpostText: json['signpostText'] as String?,
    );

Map<String, dynamic> _$RouteStepToJson(RouteStep instance) => <String, dynamic>{
      'id': instance.id,
      'stepNumber': instance.stepNumber,
      'instruction': instance.instruction,
      'distance': instance.distance,
      'duration': instance.duration,
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'maneuver': instance.maneuver,
      'roadName': instance.roadName,
      'heading': instance.heading,
      'exitNumber': instance.exitNumber,
      'signpostText': instance.signpostText,
    };

TrafficInfo _$TrafficInfoFromJson(Map<String, dynamic> json) => TrafficInfo(
      id: (json['id'] as num?)?.toInt(),
      overallCondition:
          $enumDecode(_$TrafficConditionEnumMap, json['overallCondition']),
      totalDelaySeconds: (json['totalDelaySeconds'] as num?)?.toInt() ?? 0,
      description: json['description'] as String,
      segments: (json['segments'] as List<dynamic>?)
          ?.map((e) => TrafficSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      incidents: (json['incidents'] as List<dynamic>?)
          ?.map((e) => TrafficIncident.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );

Map<String, dynamic> _$TrafficInfoToJson(TrafficInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'overallCondition': _$TrafficConditionEnumMap[instance.overallCondition]!,
      'totalDelaySeconds': instance.totalDelaySeconds,
      'description': instance.description,
      'segments': instance.segments,
      'incidents': instance.incidents,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };

const _$TrafficConditionEnumMap = {
  TrafficCondition.light: 'light',
  TrafficCondition.moderate: 'moderate',
  TrafficCondition.heavy: 'heavy',
  TrafficCondition.severe: 'severe',
  TrafficCondition.unknown: 'unknown',
};

TrafficSegment _$TrafficSegmentFromJson(Map<String, dynamic> json) =>
    TrafficSegment(
      id: (json['id'] as num?)?.toInt(),
      startLocation:
          LocationPoint.fromJson(json['startLocation'] as Map<String, dynamic>),
      endLocation:
          LocationPoint.fromJson(json['endLocation'] as Map<String, dynamic>),
      segmentDistance: (json['segmentDistance'] as num).toDouble(),
      condition: $enumDecode(_$TrafficConditionEnumMap, json['condition']),
      averageSpeed: (json['averageSpeed'] as num).toDouble(),
      freeFlowSpeed: (json['freeFlowSpeed'] as num).toDouble(),
      delaySeconds: (json['delaySeconds'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TrafficSegmentToJson(TrafficSegment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'segmentDistance': instance.segmentDistance,
      'condition': _$TrafficConditionEnumMap[instance.condition]!,
      'averageSpeed': instance.averageSpeed,
      'freeFlowSpeed': instance.freeFlowSpeed,
      'delaySeconds': instance.delaySeconds,
    };

AlternativeRoute _$AlternativeRouteFromJson(Map<String, dynamic> json) =>
    AlternativeRoute(
      id: (json['id'] as num?)?.toInt(),
      alternativeId: json['alternativeId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      totalDistance: (json['totalDistance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      encodedPolyline: json['encodedPolyline'] as String?,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => RouteStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      trafficInfo: json['trafficInfo'] == null
          ? null
          : TrafficInfo.fromJson(json['trafficInfo'] as Map<String, dynamic>),
      distanceDifference: (json['distanceDifference'] as num).toDouble(),
      timeDifference: (json['timeDifference'] as num).toInt(),
      isRecommended: json['isRecommended'] as bool? ?? false,
      recommendationReason: json['recommendationReason'] as String?,
    );

Map<String, dynamic> _$AlternativeRouteToJson(AlternativeRoute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alternativeId': instance.alternativeId,
      'name': instance.name,
      'description': instance.description,
      'totalDistance': instance.totalDistance,
      'estimatedDuration': instance.estimatedDuration,
      'encodedPolyline': instance.encodedPolyline,
      'steps': instance.steps,
      'trafficInfo': instance.trafficInfo,
      'distanceDifference': instance.distanceDifference,
      'timeDifference': instance.timeDifference,
      'isRecommended': instance.isRecommended,
      'recommendationReason': instance.recommendationReason,
    };

RouteUpdate _$RouteUpdateFromJson(Map<String, dynamic> json) => RouteUpdate(
      id: (json['id'] as num?)?.toInt(),
      updateId: json['updateId'] as String,
      routeId: json['routeId'] as String,
      updateType: $enumDecode(_$RouteUpdateTypeEnumMap, json['updateType']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      reason: json['reason'] as String?,
      previousDistance: (json['previousDistance'] as num?)?.toDouble(),
      newDistance: (json['newDistance'] as num?)?.toDouble(),
      previousDuration: (json['previousDuration'] as num?)?.toInt(),
      newDuration: (json['newDuration'] as num?)?.toInt(),
      updateData: json['updateData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RouteUpdateToJson(RouteUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateId': instance.updateId,
      'routeId': instance.routeId,
      'updateType': _$RouteUpdateTypeEnumMap[instance.updateType]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'reason': instance.reason,
      'previousDistance': instance.previousDistance,
      'newDistance': instance.newDistance,
      'previousDuration': instance.previousDuration,
      'newDuration': instance.newDuration,
      'updateData': instance.updateData,
    };

const _$RouteUpdateTypeEnumMap = {
  RouteUpdateType.trafficUpdate: 'trafficUpdate',
  RouteUpdateType.recalculation: 'recalculation',
  RouteUpdateType.incidentDetected: 'incidentDetected',
  RouteUpdateType.incidentCleared: 'incidentCleared',
  RouteUpdateType.wayPointAdded: 'wayPointAdded',
  RouteUpdateType.wayPointRemoved: 'wayPointRemoved',
  RouteUpdateType.reroute: 'reroute',
};
