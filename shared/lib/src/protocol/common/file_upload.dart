import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_upload.g.dart';

@JsonSerializable()
class FileUpload extends SerializableEntity {
  @override
  int? id;

  String fileName;
  String originalName;
  String mimeType;
  int fileSize;
  String s3Key;
  String s3Bucket;
  String? s3Region;
  String url;
  FileCategory category;
  DateTime uploadedAt;
  int uploadedBy;
  bool isPublic;
  Map<String, dynamic>? metadata;
  String? description;
  List<String>? tags;
  FileStatus status;
  String? checksum;

  FileUpload({
    this.id,
    required this.fileName,
    required this.originalName,
    required this.mimeType,
    required this.fileSize,
    required this.s3Key,
    required this.s3Bucket,
    this.s3Region,
    required this.url,
    required this.category,
    required this.uploadedAt,
    required this.uploadedBy,
    this.isPublic = false,
    this.metadata,
    this.description,
    this.tags,
    this.status = FileStatus.active,
    this.checksum,
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) =>
      _$FileUploadFromJson(json);
  Map<String, dynamic> toJson() => _$FileUploadToJson(this);
}

@JsonSerializable()
class FileUploadRequest extends SerializableEntity {
  @override
  int? id;

  String fileName;
  String mimeType;
  int fileSize;
  FileCategory category;
  bool isPublic;
  Map<String, dynamic>? metadata;
  String? description;
  List<String>? tags;

  FileUploadRequest({
    this.id,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
    required this.category,
    this.isPublic = false,
    this.metadata,
    this.description,
    this.tags,
  });

  factory FileUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$FileUploadRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FileUploadRequestToJson(this);
}

@JsonSerializable()
class FileUploadResponse extends SerializableEntity {
  @override
  int? id;

  String uploadId;
  String uploadUrl;
  String? downloadUrl;
  Map<String, String>? uploadHeaders;
  int maxFileSize;
  List<String> allowedMimeTypes;
  DateTime expiresAt;

  FileUploadResponse({
    this.id,
    required this.uploadId,
    required this.uploadUrl,
    this.downloadUrl,
    this.uploadHeaders,
    required this.maxFileSize,
    required this.allowedMimeTypes,
    required this.expiresAt,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}

@JsonSerializable()
class FileProcessingResult extends SerializableEntity {
  @override
  int? id;

  String fileId;
  ProcessingStatus status;
  String? processedUrl;
  List<FileVariant>? variants;
  Map<String, dynamic>? extractedMetadata;
  String? errorMessage;
  DateTime processedAt;

  FileProcessingResult({
    this.id,
    required this.fileId,
    required this.status,
    this.processedUrl,
    this.variants,
    this.extractedMetadata,
    this.errorMessage,
    required this.processedAt,
  });

  factory FileProcessingResult.fromJson(Map<String, dynamic> json) =>
      _$FileProcessingResultFromJson(json);
  Map<String, dynamic> toJson() => _$FileProcessingResultToJson(this);
}

@JsonSerializable()
class FileVariant extends SerializableEntity {
  @override
  int? id;

  String variantName;
  String url;
  String s3Key;
  int fileSize;
  Map<String, dynamic>? properties;

  FileVariant({
    this.id,
    required this.variantName,
    required this.url,
    required this.s3Key,
    required this.fileSize,
    this.properties,
  });

  factory FileVariant.fromJson(Map<String, dynamic> json) =>
      _$FileVariantFromJson(json);
  Map<String, dynamic> toJson() => _$FileVariantToJson(this);
}

enum FileCategory {
  profileImage,
  driverDocument,
  vehicleDocument,
  idDocument,
  proofOfAddress,
  vehiclePhoto,
  receiptAttachment,
  supportAttachment,
  other,
}

enum FileStatus {
  active,
  deleted,
  archived,
  processing,
  failed,
}

enum ProcessingStatus {
  pending,
  processing,
  completed,
  failed,
}
