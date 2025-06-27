import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';
import 'jwt_token.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse extends SerializableEntity {
  @override
  int? id;

  bool success;
  String message;
  User? user;
  JwtToken? token;
  Map<String, dynamic>? metadata;
  List<String>? errors;

  AuthResponse({
    this.id,
    required this.success,
    required this.message,
    this.user,
    this.token,
    this.metadata,
    this.errors,
  });

  factory AuthResponse.success({
    required String message,
    User? user,
    JwtToken? token,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResponse(
      success: true,
      message: message,
      user: user,
      token: token,
      metadata: metadata,
    );
  }

  factory AuthResponse.error({
    required String message,
    List<String>? errors,
    Map<String, dynamic>? metadata,
  }) {
    return AuthResponse(
      success: false,
      message: message,
      errors: errors,
      metadata: metadata,
    );
  }

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
