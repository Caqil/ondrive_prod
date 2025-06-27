import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_document.g.dart';

@JsonSerializable()
class DriverDocument extends SerializableEntity {
  @override
  int? id;

  int driverId;
  DocumentType documentType;
  String documentNumber;
  DateTime? expiryDate;
  String? issuingAuthority;
  DocumentStatus status;
  String? fileUrl;
  String? fileName;
  DateTime uploadedAt;
  DateTime? verifiedAt;
  int? verifiedBy;
  String? rejectionReason;
  List<String>? notes;

  DriverDocument({
    this.id,
    required this.driverId,
    required this.documentType,
    required this.documentNumber,
    this.expiryDate,
    this.issuingAuthority,
    this.status = DocumentStatus.pending,
    this.fileUrl,
    this.fileName,
    required this.uploadedAt,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionReason,
    this.notes,
  });

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);
  bool get isExpiringSoon =>
      expiryDate != null &&
      DateTime.now().isAfter(expiryDate!.subtract(Duration(days: 30)));

  factory DriverDocument.fromJson(Map<String, dynamic> json) =>
      _$DriverDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$DriverDocumentToJson(this);
}

@JsonSerializable()
class VehicleDocument extends SerializableEntity {
  @override
  int? id;

  int vehicleId;
  VehicleDocumentType documentType;
  String documentNumber;
  DateTime? expiryDate;
  String? issuingAuthority;
  DocumentStatus status;
  String? fileUrl;
  String? fileName;
  DateTime uploadedAt;
  DateTime? verifiedAt;
  int? verifiedBy;
  String? rejectionReason;
  List<String>? notes;

  VehicleDocument({
    this.id,
    required this.vehicleId,
    required this.documentType,
    required this.documentNumber,
    this.expiryDate,
    this.issuingAuthority,
    this.status = DocumentStatus.pending,
    this.fileUrl,
    this.fileName,
    required this.uploadedAt,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionReason,
    this.notes,
  });

  bool get isExpired =>
      expiryDate != null && DateTime.now().isAfter(expiryDate!);
  bool get isExpiringSoon =>
      expiryDate != null &&
      DateTime.now().isAfter(expiryDate!.subtract(Duration(days: 30)));

  factory VehicleDocument.fromJson(Map<String, dynamic> json) =>
      _$VehicleDocumentFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleDocumentToJson(this);
}

enum DocumentType {
  drivingLicense,
  nationalId,
  passport,
  proofOfAddress,
  backgroundCheck,
  medicalCertificate,
  photo,
}

enum VehicleDocumentType {
  registration,
  insurance,
  inspection,
  permit,
  photo,
}

enum DocumentStatus {
  pending,
  submitted,
  underReview,
  approved,
  rejected,
  expired,
  requiresUpdate,
}
