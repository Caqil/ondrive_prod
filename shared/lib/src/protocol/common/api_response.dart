import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import 'pagination.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends SerializableEntity {
  @override
  int? id;

  bool success;
  String message;
  T? data;
  Map<String, dynamic>? metadata;
  DateTime timestamp;
  String? requestId;
  int? statusCode;
  Pagination? pagination;
  List<ValidationError>? validationErrors;

  ApiResponse({
    this.id,
    required this.success,
    required this.message,
    this.data,
    this.metadata,
    required this.timestamp,
    this.requestId,
    this.statusCode,
    this.pagination,
    this.validationErrors,
  });

  @override
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this, (value) => value);

  factory ApiResponse.success({
    T? data,
    String? message,
    Map<String, dynamic>? metadata,
    Pagination? pagination,
    String? requestId,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message ?? 'Success',
      data: data,
      metadata: metadata,
      timestamp: DateTime.now(),
      requestId: requestId,
      statusCode: 200,
      pagination: pagination,
    );
  }

  factory ApiResponse.error({
    String? message,
    int? statusCode,
    Map<String, dynamic>? metadata,
    List<ValidationError>? validationErrors,
    String? requestId,
    required errorCode,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message ?? 'An error occurred',
      metadata: metadata,
      timestamp: DateTime.now(),
      requestId: requestId,
      statusCode: statusCode ?? 400,
      validationErrors: validationErrors,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJsonWithGeneric(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class ValidationError extends SerializableEntity {
  @override
  int? id;

  String field;
  String message;
  dynamic value;
  String? code;

  ValidationError({
    this.id,
    required this.field,
    required this.message,
    this.value,
    this.code,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      _$ValidationErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ValidationErrorToJson(this);
}
