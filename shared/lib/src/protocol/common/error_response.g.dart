// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      id: (json['id'] as num?)?.toInt(),
      error: json['error'] as String,
      message: json['message'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      requestId: json['requestId'] as String?,
      path: json['path'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      traceId: json['traceId'] as String?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'error': instance.error,
      'message': instance.message,
      'statusCode': instance.statusCode,
      'timestamp': instance.timestamp.toIso8601String(),
      'requestId': instance.requestId,
      'path': instance.path,
      'details': instance.details,
      'errors': instance.errors,
      'traceId': instance.traceId,
    };

ErrorDetail _$ErrorDetailFromJson(Map<String, dynamic> json) => ErrorDetail(
      id: (json['id'] as num?)?.toInt(),
      field: json['field'] as String,
      message: json['message'] as String,
      code: json['code'] as String?,
      rejectedValue: json['rejectedValue'],
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ErrorDetailToJson(ErrorDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'field': instance.field,
      'message': instance.message,
      'code': instance.code,
      'rejectedValue': instance.rejectedValue,
      'context': instance.context,
    };
