// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: (json['id'] as num?)?.toInt(),
      driverId: (json['driverId'] as num).toInt(),
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String,
      licensePlate: json['licensePlate'] as String,
      vin: json['vin'] as String,
      vehicleType: $enumDecode(_$VehicleTypeEnumMap, json['vehicleType']),
      seatingCapacity: (json['seatingCapacity'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      verificationDate: json['verificationDate'] == null
          ? null
          : DateTime.parse(json['verificationDate'] as String),
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => VehicleDocument.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      insurance: json['insurance'] == null
          ? null
          : VehicleInsurance.fromJson(
              json['insurance'] as Map<String, dynamic>),
      lastInspection: json['lastInspection'] == null
          ? null
          : VehicleInspection.fromJson(
              json['lastInspection'] as Map<String, dynamic>),
      fuelType: $enumDecodeNullable(_$FuelTypeEnumMap, json['fuelType']) ??
          FuelType.gasoline,
      isElectric: json['isElectric'] as bool? ?? false,
      isAccessible: json['isAccessible'] as bool? ?? false,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'driverId': instance.driverId,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'color': instance.color,
      'licensePlate': instance.licensePlate,
      'vin': instance.vin,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
      'seatingCapacity': instance.seatingCapacity,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'verificationDate': instance.verificationDate?.toIso8601String(),
      'features': instance.features,
      'documents': instance.documents,
      'photos': instance.photos,
      'insurance': instance.insurance,
      'lastInspection': instance.lastInspection,
      'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
      'isElectric': instance.isElectric,
      'isAccessible': instance.isAccessible,
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

const _$FuelTypeEnumMap = {
  FuelType.gasoline: 'gasoline',
  FuelType.diesel: 'diesel',
  FuelType.hybrid: 'hybrid',
  FuelType.electric: 'electric',
  FuelType.cng: 'cng',
  FuelType.lpg: 'lpg',
};

VehicleInsurance _$VehicleInsuranceFromJson(Map<String, dynamic> json) =>
    VehicleInsurance(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num).toInt(),
      provider: json['provider'] as String,
      policyNumber: json['policyNumber'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      coverageAmount: (json['coverageAmount'] as num).toDouble(),
      insuranceType: $enumDecode(_$InsuranceTypeEnumMap, json['insuranceType']),
      isActive: json['isActive'] as bool? ?? true,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VehicleInsuranceToJson(VehicleInsurance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'provider': instance.provider,
      'policyNumber': instance.policyNumber,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'coverageAmount': instance.coverageAmount,
      'insuranceType': _$InsuranceTypeEnumMap[instance.insuranceType]!,
      'isActive': instance.isActive,
      'documents': instance.documents,
    };

const _$InsuranceTypeEnumMap = {
  InsuranceType.comprehensive: 'comprehensive',
  InsuranceType.thirdParty: 'thirdParty',
  InsuranceType.collision: 'collision',
  InsuranceType.liability: 'liability',
};

VehicleInspection _$VehicleInspectionFromJson(Map<String, dynamic> json) =>
    VehicleInspection(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num).toInt(),
      inspectionDate: DateTime.parse(json['inspectionDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      inspectorName: json['inspectorName'] as String,
      certificateNumber: json['certificateNumber'] as String,
      status: $enumDecode(_$InspectionStatusEnumMap, json['status']),
      defects: (json['defects'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      documents: (json['documents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VehicleInspectionToJson(VehicleInspection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'inspectionDate': instance.inspectionDate.toIso8601String(),
      'expiryDate': instance.expiryDate.toIso8601String(),
      'inspectorName': instance.inspectorName,
      'certificateNumber': instance.certificateNumber,
      'status': _$InspectionStatusEnumMap[instance.status]!,
      'defects': instance.defects,
      'recommendations': instance.recommendations,
      'notes': instance.notes,
      'documents': instance.documents,
    };

const _$InspectionStatusEnumMap = {
  InspectionStatus.passed: 'passed',
  InspectionStatus.failed: 'failed',
  InspectionStatus.conditional: 'conditional',
  InspectionStatus.pending: 'pending',
};
