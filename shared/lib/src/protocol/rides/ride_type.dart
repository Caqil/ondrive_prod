import 'package:ride_hailing_shared/src/protocol/drivers/vehicle.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ride_type.g.dart';

/// RideType enum - Master definition used throughout the app
enum RideType {
  @JsonValue('economy')
  economy,

  @JsonValue('standard')
  standard,

  @JsonValue('premium')
  premium,

  @JsonValue('luxury')
  luxury,

  @JsonValue('suv')
  suv,

  @JsonValue('van')
  van,

  @JsonValue('pool')
  pool,

  @JsonValue('intercity')
  intercity,

  @JsonValue('courier')
  courier,

  @JsonValue('wheelchair')
  wheelchair,

  @JsonValue('pet')
  pet,

  @JsonValue('eco')
  eco,

  @JsonValue('electric')
  electric,

  // Legacy support for existing data
  @JsonValue('city')
  city,
}

@JsonSerializable()
class RideTypeDefinition extends SerializableEntity {
  @override
  int? id;

  RideType rideType;
  String displayName;
  String description;
  String? iconName;
  bool isActive;
  int sortOrder;

  // Pricing configuration
  double baseFareMultiplier;
  double distanceMultiplier;
  double timeMultiplier;
  double minimumFare;
  double maximumFare;

  // Vehicle requirements
  int maxPassengers;
  int maxLuggage;
  bool allowsPets;
  bool allowsFood;
  bool requiresChildSeat;
  bool isAccessible;
  bool isShared;
  bool isLuxury;
  bool isEco;

  List<VehicleType> allowedVehicleTypes;
  int? minVehicleYear;
  List<String>? requiredFeatures;

  // Availability configuration
  List<String> availableRegions;
  Map<String, bool>? timeAvailability;
  bool isAlwaysAvailable;

  // Service constraints
  int maxDistance; // km
  int maxDuration; // minutes
  bool requiresPreBooking;
  int? advanceBookingHours;
  bool allowsCancellation;
  int cancellationGracePeriod; // minutes

  RideTypeDefinition({
    this.id,
    required this.rideType,
    required this.displayName,
    required this.description,
    this.iconName,
    this.isActive = true,
    this.sortOrder = 0,
    this.baseFareMultiplier = 1.0,
    this.distanceMultiplier = 1.0,
    this.timeMultiplier = 1.0,
    this.minimumFare = 500, // 5.00 in cents
    this.maximumFare = 50000, // 500.00 in cents
    this.maxPassengers = 4,
    this.maxLuggage = 2,
    this.allowsPets = false,
    this.allowsFood = false,
    this.requiresChildSeat = false,
    this.isAccessible = false,
    this.isShared = false,
    this.isLuxury = false,
    this.isEco = false,
    this.allowedVehicleTypes = const [],
    this.minVehicleYear,
    this.requiredFeatures,
    this.availableRegions = const [],
    this.timeAvailability,
    this.isAlwaysAvailable = true,
    this.maxDistance = 100,
    this.maxDuration = 300,
    this.requiresPreBooking = false,
    this.advanceBookingHours,
    this.allowsCancellation = true,
    this.cancellationGracePeriod = 5,
  });

  // Helper methods
  bool isAvailableAt(DateTime dateTime) {
    if (isAlwaysAvailable || timeAvailability == null) return true;

    final dayKey = _getDayKey(dateTime.weekday);
    final hourKey = 'hour_${dateTime.hour}';

    return timeAvailability![dayKey] == true &&
        timeAvailability![hourKey] == true;
  }

  bool isWithinLimits(double distanceKm, int durationMinutes) {
    return distanceKm <= maxDistance && durationMinutes <= maxDuration;
  }

  double getTotalMultiplier() {
    return baseFareMultiplier * distanceMultiplier * timeMultiplier;
  }

  String _getDayKey(int weekday) {
    const days = [
      '',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return days[weekday];
  }

  factory RideTypeDefinition.fromJson(Map<String, dynamic> json) =>
      _$RideTypeDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$RideTypeDefinitionToJson(this);
}
