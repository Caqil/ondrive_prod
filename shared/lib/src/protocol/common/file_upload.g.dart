// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUpload _$FileUploadFromJson(Map<String, dynamic> json) => FileUpload(
      id: (json['id'] as num?)?.toInt(),
      fileName: json['fileName'] as String,
      originalName: json['originalName'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      s3Key: json['s3Key'] as String,
      s3Bucket: json['s3Bucket'] as String,
      s3Region: json['s3Region'] as String?,
      url: json['url'] as String,
      category: $enumDecode(_$FileCategoryEnumMap, json['category']),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      uploadedBy: (json['uploadedBy'] as num).toInt(),
      isPublic: json['isPublic'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: $enumDecodeNullable(_$FileStatusEnumMap, json['status']) ??
          FileStatus.active,
      checksum: json['checksum'] as String?,
    );

Map<String, dynamic> _$FileUploadToJson(FileUpload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'originalName': instance.originalName,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      's3Key': instance.s3Key,
      's3Bucket': instance.s3Bucket,
      's3Region': instance.s3Region,
      'url': instance.url,
      'category': _$FileCategoryEnumMap[instance.category]!,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'uploadedBy': instance.uploadedBy,
      'isPublic': instance.isPublic,
      'metadata': instance.metadata,
      'description': instance.description,
      'tags': instance.tags,
      'status': _$FileStatusEnumMap[instance.status]!,
      'checksum': instance.checksum,
    };

const _$FileCategoryEnumMap = {
  FileCategory.profileImage: 'profileImage',
  FileCategory.driverDocument: 'driverDocument',
  FileCategory.vehicleDocument: 'vehicleDocument',
  FileCategory.idDocument: 'idDocument',
  FileCategory.proofOfAddress: 'proofOfAddress',
  FileCategory.vehiclePhoto: 'vehiclePhoto',
  FileCategory.receiptAttachment: 'receiptAttachment',
  FileCategory.supportAttachment: 'supportAttachment',
  FileCategory.other: 'other',
};

const _$FileStatusEnumMap = {
  FileStatus.active: 'active',
  FileStatus.deleted: 'deleted',
  FileStatus.archived: 'archived',
  FileStatus.processing: 'processing',
  FileStatus.failed: 'failed',
};

FileUploadRequest _$FileUploadRequestFromJson(Map<String, dynamic> json) =>
    FileUploadRequest(
      id: (json['id'] as num?)?.toInt(),
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      category: $enumDecode(_$FileCategoryEnumMap, json['category']),
      isPublic: json['isPublic'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FileUploadRequestToJson(FileUploadRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'category': _$FileCategoryEnumMap[instance.category]!,
      'isPublic': instance.isPublic,
      'metadata': instance.metadata,
      'description': instance.description,
      'tags': instance.tags,
    };

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      id: (json['id'] as num?)?.toInt(),
      uploadId: json['uploadId'] as String,
      uploadUrl: json['uploadUrl'] as String,
      downloadUrl: json['downloadUrl'] as String?,
      uploadHeaders: (json['uploadHeaders'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      maxFileSize: (json['maxFileSize'] as num).toInt(),
      allowedMimeTypes: (json['allowedMimeTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadId': instance.uploadId,
      'uploadUrl': instance.uploadUrl,
      'downloadUrl': instance.downloadUrl,
      'uploadHeaders': instance.uploadHeaders,
      'maxFileSize': instance.maxFileSize,
      'allowedMimeTypes': instance.allowedMimeTypes,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

FileProcessingResult _$FileProcessingResultFromJson(
        Map<String, dynamic> json) =>
    FileProcessingResult(
      id: (json['id'] as num?)?.toInt(),
      fileId: json['fileId'] as String,
      status: $enumDecode(_$ProcessingStatusEnumMap, json['status']),
      processedUrl: json['processedUrl'] as String?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => FileVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      extractedMetadata: json['extractedMetadata'] as Map<String, dynamic>?,
      errorMessage: json['errorMessage'] as String?,
      processedAt: DateTime.parse(json['processedAt'] as String),
    );

Map<String, dynamic> _$FileProcessingResultToJson(
        FileProcessingResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileId': instance.fileId,
      'status': _$ProcessingStatusEnumMap[instance.status]!,
      'processedUrl': instance.processedUrl,
      'variants': instance.variants,
      'extractedMetadata': instance.extractedMetadata,
      'errorMessage': instance.errorMessage,
      'processedAt': instance.processedAt.toIso8601String(),
    };

const _$ProcessingStatusEnumMap = {
  ProcessingStatus.pending: 'pending',
  ProcessingStatus.processing: 'processing',
  ProcessingStatus.completed: 'completed',
  ProcessingStatus.failed: 'failed',
};

FileVariant _$FileVariantFromJson(Map<String, dynamic> json) => FileVariant(
      id: (json['id'] as num?)?.toInt(),
      variantName: json['variantName'] as String,
      url: json['url'] as String,
      s3Key: json['s3Key'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FileVariantToJson(FileVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variantName': instance.variantName,
      'url': instance.url,
      's3Key': instance.s3Key,
      'fileSize': instance.fileSize,
      'properties': instance.properties,
    };
