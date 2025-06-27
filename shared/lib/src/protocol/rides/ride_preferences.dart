import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../auth/user.dart';
import '../drivers/vehicle.dart';

part 'ride_preferences.g.dart';

@JsonSerializable()
class RidePreferences extends SerializableEntity {
  @override
  int? id;

  // Passenger preferences
  bool allowPets;
  bool requireChildSeat;
  bool allowLuggage;
  bool wheelchairAccessible;
  bool quietRide;
  bool allowSmoking;
  bool allowFood;
  bool allowDrinks;

  // Climate preferences
  String? temperaturePreference; // 'cool', 'warm', 'no_preference'
  bool airConditioningRequired;

  // Music and entertainment
  String? musicPreference; // 'no_music', 'soft', 'upbeat', 'driver_choice'
  bool allowConversation;
  bool allowPhoneCalls;

  // Vehicle preferences
  List<VehicleTypePreference> preferredVehicleTypes;
  String? colorPreference;
  int? minVehicleYear;
  bool preferElectricVehicle;
  bool preferHybridVehicle;

  // Route preferences
  RoutePreference routePreference;
  bool avoidTolls;
  bool avoidHighways;
  bool preferScenicRoute;

  // Payment and service preferences
  bool autoTip;
  double? defaultTipPercentage;
  bool allowSharedRide;
  bool allowPooling;

  // Safety and security preferences
  bool shareLocationWithEmergencyContact;
  bool requireDriverPhoto;
  bool requireVehiclePhoto;
  double? minimumDriverRating;

  // Accessibility and special needs
  List<AccessibilityNeed> accessibilityNeeds;
  List<SpecialRequest> specialRequests;
  String? medicalConditions;
  String? dietaryRestrictions;

  // Communication preferences
  String? preferredLanguage;
  CommunicationStyle communicationStyle;
  bool allowDriverContact;

  RidePreferences({
    this.id,
    this.allowPets = false,
    this.requireChildSeat = false,
    this.allowLuggage = true,
    this.wheelchairAccessible = false,
    this.quietRide = false,
    this.allowSmoking = false,
    this.allowFood = false,
    this.allowDrinks = true,
    this.temperaturePreference,
    this.airConditioningRequired = false,
    this.musicPreference,
    this.allowConversation = true,
    this.allowPhoneCalls = false,
    this.preferredVehicleTypes = const [],
    this.colorPreference,
    this.minVehicleYear,
    this.preferElectricVehicle = false,
    this.preferHybridVehicle = false,
    this.routePreference = RoutePreference.fastest,
    this.avoidTolls = false,
    this.avoidHighways = false,
    this.preferScenicRoute = false,
    this.autoTip = false,
    this.defaultTipPercentage,
    this.allowSharedRide = true,
    this.allowPooling = true,
    this.shareLocationWithEmergencyContact = false,
    this.requireDriverPhoto = true,
    this.requireVehiclePhoto = false,
    this.minimumDriverRating,
    this.accessibilityNeeds = const [],
    this.specialRequests = const [],
    this.medicalConditions,
    this.dietaryRestrictions,
    this.preferredLanguage = 'en',
    this.communicationStyle = CommunicationStyle.normal,
    this.allowDriverContact = true,
  });

  // Check if preferences are compatible with driver/vehicle
  bool isCompatibleWith(Map<String, dynamic> driverCapabilities) {
    // Check pet policy
    if (allowPets && driverCapabilities['allowsPets'] == false) return false;

    // Check smoking policy
    if (allowSmoking && driverCapabilities['allowsSmoking'] == false)
      return false;

    // Check wheelchair accessibility
    if (wheelchairAccessible &&
        driverCapabilities['wheelchairAccessible'] == false) return false;

    // Check child seat requirement
    if (requireChildSeat && driverCapabilities['hasChildSeat'] == false)
      return false;

    // Check vehicle year requirement
    if (minVehicleYear != null &&
        driverCapabilities['vehicleYear'] != null &&
        driverCapabilities['vehicleYear'] < minVehicleYear!) return false;

    // Check minimum driver rating
    if (minimumDriverRating != null &&
        driverCapabilities['driverRating'] != null &&
        driverCapabilities['driverRating'] < minimumDriverRating!) return false;

    return true;
  }

  // Get preference score for driver matching
  double getCompatibilityScore(Map<String, dynamic> driverCapabilities) {
    double score = 100.0; // Start with perfect score

    // Deduct points for incompatibilities
    if (allowPets && driverCapabilities['allowsPets'] == false) score -= 20;
    if (requireChildSeat && driverCapabilities['hasChildSeat'] == false)
      score -= 30;
    if (wheelchairAccessible &&
        driverCapabilities['wheelchairAccessible'] == false) score -= 50;

    // Add points for preferences
    if (preferElectricVehicle && driverCapabilities['isElectric'] == true)
      score += 10;
    if (preferHybridVehicle && driverCapabilities['isHybrid'] == true)
      score += 5;
    if (quietRide && driverCapabilities['quietDriver'] == true) score += 5;

    return math.max(0, math.min(100, score));
  }

  // Create default preferences for user type
  static RidePreferences createDefault(UserType userType) {
    switch (userType) {
      case UserType.passenger:
        return RidePreferences();
      case UserType.driver:
        return RidePreferences(
          allowDriverContact: true,
          allowConversation: true,
          requireDriverPhoto: false,
        );
      default:
        return RidePreferences();
    }
  }

  factory RidePreferences.fromJson(Map<String, dynamic> json) =>
      _$RidePreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$RidePreferencesToJson(this);
}

@JsonSerializable()
class VehicleTypePreference extends SerializableEntity {
  @override
  int? id;

  VehicleType vehicleType;
  int priority; // 1 = highest priority
  String? reason;

  VehicleTypePreference({
    this.id,
    required this.vehicleType,
    required this.priority,
    this.reason,
  });

  factory VehicleTypePreference.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypePreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleTypePreferenceToJson(this);
}

@JsonSerializable()
class SpecialRequest extends SerializableEntity {
  @override
  int? id;

  SpecialRequestType type;
  String description;
  bool isRequired;
  String? notes;

  SpecialRequest({
    this.id,
    required this.type,
    required this.description,
    this.isRequired = false,
    this.notes,
  });

  factory SpecialRequest.fromJson(Map<String, dynamic> json) =>
      _$SpecialRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialRequestToJson(this);
}

enum RoutePreference {
  fastest,
  shortest,
  safest,
  scenic,
  ecoFriendly,
  avoidTraffic,
}

enum CommunicationStyle {
  minimal,
  normal,
  chatty,
  professional,
}

enum SpecialRequestType {
  extraLuggage,
  petCarrier,
  musicRequest,
  temperatureControl,
  routeModification,
  waitingTime,
  pickupInstructions,
  dropoffInstructions,
  other,
}
