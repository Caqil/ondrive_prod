import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends SerializableEntity {
  @override
  int? id;

  String error;
  String message;
  int statusCode;
  DateTime timestamp;
  String? requestId;
  String? path;
  Map<String, dynamic>? details;
  List<ErrorDetail>? errors;
  String? traceId;

  ErrorResponse({
    this.id,
    required this.error,
    required this.message,
    required this.statusCode,
    required this.timestamp,
    this.requestId,
    this.path,
    this.details,
    this.errors,
    this.traceId,
  });

  factory ErrorResponse.badRequest({
    String? message,
    String? requestId,
    String? path,
    Map<String, dynamic>? details,
    List<ErrorDetail>? errors,
  }) {
    return ErrorResponse(
      error: 'Bad Request',
      message: message ?? 'Invalid request',
      statusCode: 400,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
      details: details,
      errors: errors,
    );
  }

  factory ErrorResponse.unauthorized({
    String? message,
    String? requestId,
    String? path,
  }) {
    return ErrorResponse(
      error: 'Unauthorized',
      message: message ?? 'Authentication required',
      statusCode: 401,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
    );
  }

  factory ErrorResponse.forbidden({
    String? message,
    String? requestId,
    String? path,
  }) {
    return ErrorResponse(
      error: 'Forbidden',
      message: message ?? 'Access denied',
      statusCode: 403,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
    );
  }

  factory ErrorResponse.notFound({
    String? message,
    String? requestId,
    String? path,
  }) {
    return ErrorResponse(
      error: 'Not Found',
      message: message ?? 'Resource not found',
      statusCode: 404,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
    );
  }

  factory ErrorResponse.conflict({
    String? message,
    String? requestId,
    String? path,
    Map<String, dynamic>? details,
  }) {
    return ErrorResponse(
      error: 'Conflict',
      message: message ?? 'Resource conflict',
      statusCode: 409,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
      details: details,
    );
  }

  factory ErrorResponse.tooManyRequests({
    String? message,
    String? requestId,
    String? path,
    int? retryAfter,
  }) {
    final details = retryAfter != null ? {'retryAfter': retryAfter} : null;
    return ErrorResponse(
      error: 'Too Many Requests',
      message: message ?? 'Rate limit exceeded',
      statusCode: 429,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
      details: details,
    );
  }

  factory ErrorResponse.internalServerError({
    String? message,
    String? requestId,
    String? path,
    String? traceId,
  }) {
    return ErrorResponse(
      error: 'Internal Server Error',
      message: message ?? 'Something went wrong',
      statusCode: 500,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
      traceId: traceId,
    );
  }

  factory ErrorResponse.serviceUnavailable({
    String? message,
    String? requestId,
    String? path,
    int? retryAfter,
  }) {
    final details = retryAfter != null ? {'retryAfter': retryAfter} : null;
    return ErrorResponse(
      error: 'Service Unavailable',
      message: message ?? 'Service temporarily unavailable',
      statusCode: 503,
      timestamp: DateTime.now(),
      requestId: requestId,
      path: path,
      details: details,
    );
  }

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}

@JsonSerializable()
class ErrorDetail extends SerializableEntity {
  @override
  int? id;

  String field;
  String message;
  String? code;
  dynamic rejectedValue;
  Map<String, dynamic>? context;

  ErrorDetail({
    this.id,
    required this.field,
    required this.message,
    this.code,
    this.rejectedValue,
    this.context,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorDetailToJson(this);
}
