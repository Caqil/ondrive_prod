// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
      id: (json['id'] as num?)?.toInt(),
      rideId: json['rideId'] as String,
      passengerId: (json['passengerId'] as num).toInt(),
      driverId: (json['driverId'] as num?)?.toInt(),
      rideType: $enumDecode(_$RideTypeEnumMap, json['rideType']),
      status: $enumDecode(_$RideStatusEnumMap, json['status']),
      pickupLocation: LocationPoint.fromJson(
          json['pickupLocation'] as Map<String, dynamic>),
      dropoffLocation: LocationPoint.fromJson(
          json['dropoffLocation'] as Map<String, dynamic>),
      waypoints: (json['waypoints'] as List<dynamic>?)
          ?.map((e) => LocationPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      distance: (json['distance'] as num?)?.toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      finalFare: (json['finalFare'] as num?)?.toDouble(),
      suggestedFare: (json['suggestedFare'] as num?)?.toDouble(),
      preferences: json['preferences'] == null
          ? null
          : RidePreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
      specialRequests: json['specialRequests'] as String?,
      notes: json['notes'] as String?,
      isEmergency: json['isEmergency'] as bool? ?? false,
      poolingGroupId: (json['poolingGroupId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'passengerId': instance.passengerId,
      'driverId': instance.driverId,
      'rideType': _$RideTypeEnumMap[instance.rideType]!,
      'status': _$RideStatusEnumMap[instance.status]!,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'waypoints': instance.waypoints,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'distance': instance.distance,
      'estimatedDuration': instance.estimatedDuration,
      'estimatedFare': instance.estimatedFare,
      'finalFare': instance.finalFare,
      'suggestedFare': instance.suggestedFare,
      'preferences': instance.preferences,
      'specialRequests': instance.specialRequests,
      'notes': instance.notes,
      'isEmergency': instance.isEmergency,
      'poolingGroupId': instance.poolingGroupId,
    };

const _$RideTypeEnumMap = {
  RideType.city: 'city',
  RideType.intercity: 'intercity',
  RideType.courier: 'courier',
  RideType.pool: 'pool',
  RideType.luxury: 'luxury',
  RideType.eco: 'eco',
};

const _$RideStatusEnumMap = {
  RideStatus.requested: 'requested',
  RideStatus.negotiating: 'negotiating',
  RideStatus.driverAssigned: 'driverAssigned',
  RideStatus.driverEnRoute: 'driverEnRoute',
  RideStatus.arrived: 'arrived',
  RideStatus.inProgress: 'inProgress',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
  RideStatus.noDriversAvailable: 'noDriversAvailable',
};

RidePreferences _$RidePreferencesFromJson(Map<String, dynamic> json) =>
    RidePreferences(
      id: (json['id'] as num?)?.toInt(),
      allowPets: json['allowPets'] as bool? ?? false,
      requireChildSeat: json['requireChildSeat'] as bool? ?? false,
      allowLuggage: json['allowLuggage'] as bool? ?? true,
      wheelchairAccessible: json['wheelchairAccessible'] as bool? ?? false,
      musicPreference: json['musicPreference'] as String?,
      temperaturePreference: json['temperaturePreference'] as String?,
      quietRide: json['quietRide'] as bool? ?? false,
    );

Map<String, dynamic> _$RidePreferencesToJson(RidePreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allowPets': instance.allowPets,
      'requireChildSeat': instance.requireChildSeat,
      'allowLuggage': instance.allowLuggage,
      'wheelchairAccessible': instance.wheelchairAccessible,
      'musicPreference': instance.musicPreference,
      'temperaturePreference': instance.temperaturePreference,
      'quietRide': instance.quietRide,
    };
