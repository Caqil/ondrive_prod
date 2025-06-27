// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverLocation _$DriverLocationFromJson(Map<String, dynamic> json) =>
    DriverLocation(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      currentRideId: json['currentRideId'] as String?,
      source: $enumDecodeNullable(_$LocationSourceEnumMap, json['source']) ??
          LocationSource.gps,
      status: $enumDecodeNullable(_$LocationStatusEnumMap, json['status']) ??
          LocationStatus.active,
      metadata: json['metadata'] as Map<String, dynamic>?,
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      isCharging: json['isCharging'] as bool?,
      deviceId: json['deviceId'] as String?,
      appVersion: json['appVersion'] as String?,
      networkType: json['networkType'] as String?,
      signalStrength: (json['signalStrength'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DriverLocationToJson(DriverLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'heading': instance.heading,
      'speed': instance.speed,
      'accuracy': instance.accuracy,
      'isAvailable': instance.isAvailable,
      'isOnline': instance.isOnline,
      'timestamp': instance.timestamp.toIso8601String(),
      'currentRideId': instance.currentRideId,
      'source': _$LocationSourceEnumMap[instance.source]!,
      'status': _$LocationStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'batteryLevel': instance.batteryLevel,
      'isCharging': instance.isCharging,
      'deviceId': instance.deviceId,
      'appVersion': instance.appVersion,
      'networkType': instance.networkType,
      'signalStrength': instance.signalStrength,
    };

const _$LocationSourceEnumMap = {
  LocationSource.gps: 'gps',
  LocationSource.network: 'network',
  LocationSource.passive: 'passive',
  LocationSource.fused: 'fused',
  LocationSource.manual: 'manual',
};

const _$LocationStatusEnumMap = {
  LocationStatus.active: 'active',
  LocationStatus.inactive: 'inactive',
  LocationStatus.expired: 'expired',
  LocationStatus.invalid: 'invalid',
};

LocationHistory _$LocationHistoryFromJson(Map<String, dynamic> json) =>
    LocationHistory(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => DriverLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0.0,
      totalDuration:
          Duration(microseconds: (json['totalDuration'] as num).toInt()),
      locationCount: (json['locationCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LocationHistoryToJson(LocationHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'locations': instance.locations,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'totalDistance': instance.totalDistance,
      'averageSpeed': instance.averageSpeed,
      'totalDuration': instance.totalDuration.inMicroseconds,
      'locationCount': instance.locationCount,
    };

GeofenceArea _$GeofenceAreaFromJson(Map<String, dynamic> json) => GeofenceArea(
      id: (json['id'] as num?)?.toInt(),
      areaId: json['areaId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$GeofenceTypeEnumMap, json['type']),
      boundary: (json['boundary'] as List<dynamic>?)
              ?.map((e) => LocationPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      radius: (json['radius'] as num?)?.toDouble(),
      center: json['center'] == null
          ? null
          : LocationPoint.fromJson(json['center'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? true,
      rules: json['rules'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$GeofenceAreaToJson(GeofenceArea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'areaId': instance.areaId,
      'name': instance.name,
      'description': instance.description,
      'type': _$GeofenceTypeEnumMap[instance.type]!,
      'boundary': instance.boundary,
      'radius': instance.radius,
      'center': instance.center,
      'isActive': instance.isActive,
      'rules': instance.rules,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GeofenceTypeEnumMap = {
  GeofenceType.polygon: 'polygon',
  GeofenceType.circle: 'circle',
};
