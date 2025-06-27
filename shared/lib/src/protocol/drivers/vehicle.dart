import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'driver_document.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle extends SerializableEntity {
  @override
  int? id;

  int driverId;
  String make;
  String model;
  int year;
  String color;
  String licensePlate;
  String vin;
  VehicleType vehicleType;
  int seatingCapacity;
  bool isActive;
  bool isVerified;
  DateTime registrationDate;
  DateTime? verificationDate;
  List<String> features; // ['AC', 'WiFi', 'USB', 'Pet-friendly']
  List<VehicleDocument> documents;
  List<String> photos;
  VehicleInsurance? insurance;
  VehicleInspection? lastInspection;
  FuelType fuelType;
  bool isElectric;
  bool isAccessible; // wheelchair accessible

  Vehicle({
    this.id,
    required this.driverId,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.vin,
    required this.vehicleType,
    required this.seatingCapacity,
    this.isActive = true,
    this.isVerified = false,
    required this.registrationDate,
    this.verificationDate,
    this.features = const [],
    this.documents = const [],
    this.photos = const [],
    this.insurance,
    this.lastInspection,
    this.fuelType = FuelType.gasoline,
    this.isElectric = false,
    this.isAccessible = false,
  });

  String get displayName => '$year $make $model';
  String get plateDisplay => licensePlate.toUpperCase();

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

@JsonSerializable()
class VehicleInsurance extends SerializableEntity {
  @override
  int? id;

  int vehicleId;
  String provider;
  String policyNumber;
  DateTime startDate;
  DateTime endDate;
  double coverageAmount;
  InsuranceType insuranceType;
  bool isActive;
  List<String> documents;

  VehicleInsurance({
    this.id,
    required this.vehicleId,
    required this.provider,
    required this.policyNumber,
    required this.startDate,
    required this.endDate,
    required this.coverageAmount,
    required this.insuranceType,
    this.isActive = true,
    this.documents = const [],
  });

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isExpiringSoon =>
      DateTime.now().isAfter(endDate.subtract(Duration(days: 30)));

  factory VehicleInsurance.fromJson(Map<String, dynamic> json) =>
      _$VehicleInsuranceFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleInsuranceToJson(this);
}

@JsonSerializable()
class VehicleInspection extends SerializableEntity {
  @override
  int? id;

  int vehicleId;
  DateTime inspectionDate;
  DateTime expiryDate;
  String inspectorName;
  String certificateNumber;
  InspectionStatus status;
  List<String> defects;
  List<String> recommendations;
  String? notes;
  List<String> documents;

  VehicleInspection({
    this.id,
    required this.vehicleId,
    required this.inspectionDate,
    required this.expiryDate,
    required this.inspectorName,
    required this.certificateNumber,
    required this.status,
    this.defects = const [],
    this.recommendations = const [],
    this.notes,
    this.documents = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExpiringSoon =>
      DateTime.now().isAfter(expiryDate.subtract(Duration(days: 30)));

  factory VehicleInspection.fromJson(Map<String, dynamic> json) =>
      _$VehicleInspectionFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleInspectionToJson(this);
}

enum VehicleType {
  economy,
  standard,
  premium,
  luxury,
  suv,
  van,
  motorcycle,
  bicycle,
}

enum FuelType {
  gasoline,
  diesel,
  hybrid,
  electric,
  cng,
  lpg,
}

enum InsuranceType {
  comprehensive,
  thirdParty,
  collision,
  liability,
}

enum InspectionStatus {
  passed,
  failed,
  conditional,
  pending,
}
