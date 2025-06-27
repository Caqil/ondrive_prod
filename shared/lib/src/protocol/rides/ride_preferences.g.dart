// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RidePreferences _$RidePreferencesFromJson(Map<String, dynamic> json) =>
    RidePreferences(
      id: (json['id'] as num?)?.toInt(),
      allowPets: json['allowPets'] as bool? ?? false,
      requireChildSeat: json['requireChildSeat'] as bool? ?? false,
      allowLuggage: json['allowLuggage'] as bool? ?? true,
      wheelchairAccessible: json['wheelchairAccessible'] as bool? ?? false,
      quietRide: json['quietRide'] as bool? ?? false,
      allowSmoking: json['allowSmoking'] as bool? ?? false,
      allowFood: json['allowFood'] as bool? ?? false,
      allowDrinks: json['allowDrinks'] as bool? ?? true,
      temperaturePreference: json['temperaturePreference'] as String?,
      airConditioningRequired:
          json['airConditioningRequired'] as bool? ?? false,
      musicPreference: json['musicPreference'] as String?,
      allowConversation: json['allowConversation'] as bool? ?? true,
      allowPhoneCalls: json['allowPhoneCalls'] as bool? ?? false,
      preferredVehicleTypes: (json['preferredVehicleTypes'] as List<dynamic>?)
              ?.map((e) =>
                  VehicleTypePreference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      colorPreference: json['colorPreference'] as String?,
      minVehicleYear: (json['minVehicleYear'] as num?)?.toInt(),
      preferElectricVehicle: json['preferElectricVehicle'] as bool? ?? false,
      preferHybridVehicle: json['preferHybridVehicle'] as bool? ?? false,
      routePreference: $enumDecodeNullable(
              _$RoutePreferenceEnumMap, json['routePreference']) ??
          RoutePreference.fastest,
      avoidTolls: json['avoidTolls'] as bool? ?? false,
      avoidHighways: json['avoidHighways'] as bool? ?? false,
      preferScenicRoute: json['preferScenicRoute'] as bool? ?? false,
      autoTip: json['autoTip'] as bool? ?? false,
      defaultTipPercentage: (json['defaultTipPercentage'] as num?)?.toDouble(),
      allowSharedRide: json['allowSharedRide'] as bool? ?? true,
      allowPooling: json['allowPooling'] as bool? ?? true,
      shareLocationWithEmergencyContact:
          json['shareLocationWithEmergencyContact'] as bool? ?? false,
      requireDriverPhoto: json['requireDriverPhoto'] as bool? ?? true,
      requireVehiclePhoto: json['requireVehiclePhoto'] as bool? ?? false,
      minimumDriverRating: (json['minimumDriverRating'] as num?)?.toDouble(),
      accessibilityNeeds: (json['accessibilityNeeds'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AccessibilityNeedEnumMap, e))
              .toList() ??
          const [],
      specialRequests: (json['specialRequests'] as List<dynamic>?)
              ?.map((e) => SpecialRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      medicalConditions: json['medicalConditions'] as String?,
      dietaryRestrictions: json['dietaryRestrictions'] as String?,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      communicationStyle: $enumDecodeNullable(
              _$CommunicationStyleEnumMap, json['communicationStyle']) ??
          CommunicationStyle.normal,
      allowDriverContact: json['allowDriverContact'] as bool? ?? true,
    );

Map<String, dynamic> _$RidePreferencesToJson(RidePreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allowPets': instance.allowPets,
      'requireChildSeat': instance.requireChildSeat,
      'allowLuggage': instance.allowLuggage,
      'wheelchairAccessible': instance.wheelchairAccessible,
      'quietRide': instance.quietRide,
      'allowSmoking': instance.allowSmoking,
      'allowFood': instance.allowFood,
      'allowDrinks': instance.allowDrinks,
      'temperaturePreference': instance.temperaturePreference,
      'airConditioningRequired': instance.airConditioningRequired,
      'musicPreference': instance.musicPreference,
      'allowConversation': instance.allowConversation,
      'allowPhoneCalls': instance.allowPhoneCalls,
      'preferredVehicleTypes': instance.preferredVehicleTypes,
      'colorPreference': instance.colorPreference,
      'minVehicleYear': instance.minVehicleYear,
      'preferElectricVehicle': instance.preferElectricVehicle,
      'preferHybridVehicle': instance.preferHybridVehicle,
      'routePreference': _$RoutePreferenceEnumMap[instance.routePreference]!,
      'avoidTolls': instance.avoidTolls,
      'avoidHighways': instance.avoidHighways,
      'preferScenicRoute': instance.preferScenicRoute,
      'autoTip': instance.autoTip,
      'defaultTipPercentage': instance.defaultTipPercentage,
      'allowSharedRide': instance.allowSharedRide,
      'allowPooling': instance.allowPooling,
      'shareLocationWithEmergencyContact':
          instance.shareLocationWithEmergencyContact,
      'requireDriverPhoto': instance.requireDriverPhoto,
      'requireVehiclePhoto': instance.requireVehiclePhoto,
      'minimumDriverRating': instance.minimumDriverRating,
      'accessibilityNeeds': instance.accessibilityNeeds
          .map((e) => _$AccessibilityNeedEnumMap[e]!)
          .toList(),
      'specialRequests': instance.specialRequests,
      'medicalConditions': instance.medicalConditions,
      'dietaryRestrictions': instance.dietaryRestrictions,
      'preferredLanguage': instance.preferredLanguage,
      'communicationStyle':
          _$CommunicationStyleEnumMap[instance.communicationStyle]!,
      'allowDriverContact': instance.allowDriverContact,
    };

const _$RoutePreferenceEnumMap = {
  RoutePreference.fastest: 'fastest',
  RoutePreference.shortest: 'shortest',
  RoutePreference.safest: 'safest',
  RoutePreference.scenic: 'scenic',
  RoutePreference.ecoFriendly: 'ecoFriendly',
  RoutePreference.avoidTraffic: 'avoidTraffic',
};

const _$AccessibilityNeedEnumMap = {
  AccessibilityNeed.wheelchairAccessible: 'wheelchairAccessible',
  AccessibilityNeed.hearingImpaired: 'hearingImpaired',
  AccessibilityNeed.visuallyImpaired: 'visuallyImpaired',
  AccessibilityNeed.mobilityAssistance: 'mobilityAssistance',
  AccessibilityNeed.serviceAnimal: 'serviceAnimal',
  AccessibilityNeed.other: 'other',
};

const _$CommunicationStyleEnumMap = {
  CommunicationStyle.minimal: 'minimal',
  CommunicationStyle.normal: 'normal',
  CommunicationStyle.chatty: 'chatty',
  CommunicationStyle.professional: 'professional',
};

VehicleTypePreference _$VehicleTypePreferenceFromJson(
        Map<String, dynamic> json) =>
    VehicleTypePreference(
      id: (json['id'] as num?)?.toInt(),
      vehicleType: $enumDecode(_$VehicleTypeEnumMap, json['vehicleType']),
      priority: (json['priority'] as num).toInt(),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$VehicleTypePreferenceToJson(
        VehicleTypePreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
      'priority': instance.priority,
      'reason': instance.reason,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.economy: 'economy',
  VehicleType.standard: 'standard',
  VehicleType.premium: 'premium',
  VehicleType.luxury: 'luxury',
  VehicleType.suv: 'suv',
  VehicleType.van: 'van',
  VehicleType.motorcycle: 'motorcycle',
  VehicleType.bicycle: 'bicycle',
};

SpecialRequest _$SpecialRequestFromJson(Map<String, dynamic> json) =>
    SpecialRequest(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecode(_$SpecialRequestTypeEnumMap, json['type']),
      description: json['description'] as String,
      isRequired: json['isRequired'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SpecialRequestToJson(SpecialRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SpecialRequestTypeEnumMap[instance.type]!,
      'description': instance.description,
      'isRequired': instance.isRequired,
      'notes': instance.notes,
    };

const _$SpecialRequestTypeEnumMap = {
  SpecialRequestType.extraLuggage: 'extraLuggage',
  SpecialRequestType.petCarrier: 'petCarrier',
  SpecialRequestType.musicRequest: 'musicRequest',
  SpecialRequestType.temperatureControl: 'temperatureControl',
  SpecialRequestType.routeModification: 'routeModification',
  SpecialRequestType.waitingTime: 'waitingTime',
  SpecialRequestType.pickupInstructions: 'pickupInstructions',
  SpecialRequestType.dropoffInstructions: 'dropoffInstructions',
  SpecialRequestType.other: 'other',
};
