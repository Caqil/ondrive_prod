// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdate _$LocationUpdateFromJson(Map<String, dynamic> json) =>
    LocationUpdate(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      rideId: json['rideId'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: $enumDecodeNullable(_$LocationSourceEnumMap, json['source']) ??
          LocationSource.gps,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LocationUpdateToJson(LocationUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'rideId': instance.rideId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'accuracy': instance.accuracy,
      'heading': instance.heading,
      'speed': instance.speed,
      'timestamp': instance.timestamp.toIso8601String(),
      'source': _$LocationSourceEnumMap[instance.source]!,
      'metadata': instance.metadata,
    };

const _$LocationSourceEnumMap = {
  LocationSource.gps: 'gps',
  LocationSource.network: 'network',
  LocationSource.passive: 'passive',
  LocationSource.manual: 'manual',
};
