import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends SerializableEntity {
  @override
  int? id;

  String email;
  String password;
  bool rememberMe;
  String? deviceId;
  String? deviceType; // 'ios', 'android', 'web'
  String? fcmToken; // For push notifications

  LoginRequest({
    this.id,
    required this.email,
    required this.password,
    this.rememberMe = false,
    this.deviceId,
    this.deviceType,
    this.fcmToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class SocialLoginRequest extends SerializableEntity {
  @override
  int? id;

  String provider; // 'google', 'facebook', 'apple'
  String accessToken;
  String? idToken;
  String? deviceId;
  String? deviceType;
  String? fcmToken;

  SocialLoginRequest({
    this.id,
    required this.provider,
    required this.accessToken,
    this.idToken,
    this.deviceId,
    this.deviceType,
    this.fcmToken,
  });

  factory SocialLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
