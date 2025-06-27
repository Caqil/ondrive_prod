// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RideResponse _$RideResponseFromJson(Map<String, dynamic> json) => RideResponse(
      id: (json['id'] as num?)?.toInt(),
      success: json['success'] as bool,
      message: json['message'] as String,
      ride: json['ride'] == null
          ? null
          : Ride.fromJson(json['ride'] as Map<String, dynamic>),
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      estimatedDistance: (json['estimatedDistance'] as num?)?.toDouble(),
      estimatedPickupTime: json['estimatedPickupTime'] == null
          ? null
          : DateTime.parse(json['estimatedPickupTime'] as String),
      estimatedArrivalTime: json['estimatedArrivalTime'] == null
          ? null
          : DateTime.parse(json['estimatedArrivalTime'] as String),
      availableDrivers: (json['availableDrivers'] as List<dynamic>?)
          ?.map((e) => DriverOffer.fromJson(e as Map<String, dynamic>))
          .toList(),
      fareOptions: (json['fareOptions'] as List<dynamic>?)
          ?.map((e) => FareOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyDriverCount: (json['nearbyDriverCount'] as num?)?.toInt(),
      routePreview: json['routePreview'] == null
          ? null
          : RoutePreview.fromJson(json['routePreview'] as Map<String, dynamic>),
      errorCode: json['errorCode'] as String?,
      errorType: $enumDecodeNullable(_$RideErrorTypeEnumMap, json['errorType']),
      errorDetails: (json['errorDetails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      errorMetadata: json['errorMetadata'] as Map<String, dynamic>?,
      alternatives: (json['alternatives'] as List<dynamic>?)
          ?.map((e) => AlternativeOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      surgeInfo: json['surgeInfo'] == null
          ? null
          : SurgeInfo.fromJson(json['surgeInfo'] as Map<String, dynamic>),
      requestId: json['requestId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RideResponseToJson(RideResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'success': instance.success,
      'message': instance.message,
      'ride': instance.ride,
      'estimatedFare': instance.estimatedFare,
      'estimatedDuration': instance.estimatedDuration,
      'estimatedDistance': instance.estimatedDistance,
      'estimatedPickupTime': instance.estimatedPickupTime?.toIso8601String(),
      'estimatedArrivalTime': instance.estimatedArrivalTime?.toIso8601String(),
      'availableDrivers': instance.availableDrivers,
      'fareOptions': instance.fareOptions,
      'nearbyDriverCount': instance.nearbyDriverCount,
      'routePreview': instance.routePreview,
      'errorCode': instance.errorCode,
      'errorType': _$RideErrorTypeEnumMap[instance.errorType],
      'errorDetails': instance.errorDetails,
      'errorMetadata': instance.errorMetadata,
      'alternatives': instance.alternatives,
      'surgeInfo': instance.surgeInfo,
      'requestId': instance.requestId,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$RideErrorTypeEnumMap = {
  RideErrorType.noDriversAvailable: 'noDriversAvailable',
  RideErrorType.invalidLocation: 'invalidLocation',
  RideErrorType.serviceUnavailable: 'serviceUnavailable',
  RideErrorType.paymentRequired: 'paymentRequired',
  RideErrorType.accountIssue: 'accountIssue',
  RideErrorType.distanceTooLong: 'distanceTooLong',
  RideErrorType.distanceTooShort: 'distanceTooShort',
  RideErrorType.outsideServiceArea: 'outsideServiceArea',
  RideErrorType.surgeActive: 'surgeActive',
  RideErrorType.other: 'other',
};

DriverOffer _$DriverOfferFromJson(Map<String, dynamic> json) => DriverOffer(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      driverName: json['driverName'] as String,
      driverPhoto: json['driverPhoto'] as String?,
      driverRating: (json['driverRating'] as num).toDouble(),
      totalRides: (json['totalRides'] as num).toInt(),
      vehicle: VehicleInfo.fromJson(json['vehicle'] as Map<String, dynamic>),
      proposedFare: (json['proposedFare'] as num).toDouble(),
      estimatedArrivalTime: (json['estimatedArrivalTime'] as num).toInt(),
      distanceFromPickup: (json['distanceFromPickup'] as num).toDouble(),
      isOnline: json['isOnline'] as bool,
      isAvailable: json['isAvailable'] as bool,
      lastLocationUpdate: json['lastLocationUpdate'] == null
          ? null
          : DateTime.parse(json['lastLocationUpdate'] as String),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialties: (json['specialties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      driverMessage: json['driverMessage'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DriverOfferToJson(DriverOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'driverName': instance.driverName,
      'driverPhoto': instance.driverPhoto,
      'driverRating': instance.driverRating,
      'totalRides': instance.totalRides,
      'vehicle': instance.vehicle,
      'proposedFare': instance.proposedFare,
      'estimatedArrivalTime': instance.estimatedArrivalTime,
      'distanceFromPickup': instance.distanceFromPickup,
      'isOnline': instance.isOnline,
      'isAvailable': instance.isAvailable,
      'lastLocationUpdate': instance.lastLocationUpdate?.toIso8601String(),
      'languages': instance.languages,
      'specialties': instance.specialties,
      'driverMessage': instance.driverMessage,
      'metadata': instance.metadata,
    };

FareOption _$FareOptionFromJson(Map<String, dynamic> json) => FareOption(
      id: (json['id'] as num?)?.toInt(),
      rideType: $enumDecode(_$RideTypeEnumMap, json['rideType']),
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      baseFare: (json['baseFare'] as num).toDouble(),
      estimatedFare: (json['estimatedFare'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableVehicles: (json['availableVehicles'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FareOptionToJson(FareOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideType': _$RideTypeEnumMap[instance.rideType]!,
      'displayName': instance.displayName,
      'description': instance.description,
      'baseFare': instance.baseFare,
      'estimatedFare': instance.estimatedFare,
      'estimatedDuration': instance.estimatedDuration,
      'isAvailable': instance.isAvailable,
      'availableVehicles': instance.availableVehicles,
    };

const _$RideTypeEnumMap = {
  RideType.economy: 'economy',
  RideType.standard: 'standard',
  RideType.premium: 'premium',
  RideType.luxury: 'luxury',
  RideType.suv: 'suv',
  RideType.van: 'van',
  RideType.pool: 'pool',
  RideType.intercity: 'intercity',
  RideType.courier: 'courier',
  RideType.wheelchair: 'wheelchair',
  RideType.pet: 'pet',
  RideType.eco: 'eco',
  RideType.electric: 'electric',
  RideType.city: 'city',
};

RoutePreview _$RoutePreviewFromJson(Map<String, dynamic> json) => RoutePreview(
      id: (json['id'] as num?)?.toInt(),
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => LocationPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalDistance: (json['totalDistance'] as num).toDouble(),
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      encodedPolyline: json['encodedPolyline'] as String?,
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoutePreviewToJson(RoutePreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'waypoints': instance.waypoints,
      'totalDistance': instance.totalDistance,
      'estimatedDuration': instance.estimatedDuration,
      'encodedPolyline': instance.encodedPolyline,
      'instructions': instance.instructions,
    };

AlternativeOption _$AlternativeOptionFromJson(Map<String, dynamic> json) =>
    AlternativeOption(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecode(_$AlternativeTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      actionData: json['actionData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AlternativeOptionToJson(AlternativeOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AlternativeTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'actionData': instance.actionData,
    };

const _$AlternativeTypeEnumMap = {
  AlternativeType.scheduleRide: 'scheduleRide',
  AlternativeType.increaseRadius: 'increaseRadius',
  AlternativeType.changeRideType: 'changeRideType',
  AlternativeType.waitForDrivers: 'waitForDrivers',
  AlternativeType.addFare: 'addFare',
  AlternativeType.publicTransport: 'publicTransport',
  AlternativeType.walking: 'walking',
  AlternativeType.other: 'other',
};

SurgeInfo _$SurgeInfoFromJson(Map<String, dynamic> json) => SurgeInfo(
      id: (json['id'] as num?)?.toInt(),
      isActive: json['isActive'] as bool,
      multiplier: (json['multiplier'] as num).toDouble(),
      reason: json['reason'] as String,
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.parse(json['endsAt'] as String),
      affectedAreas: (json['affectedAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SurgeInfoToJson(SurgeInfo instance) => <String, dynamic>{
      'id': instance.id,
      'isActive': instance.isActive,
      'multiplier': instance.multiplier,
      'reason': instance.reason,
      'endsAt': instance.endsAt?.toIso8601String(),
      'affectedAreas': instance.affectedAreas,
    };
