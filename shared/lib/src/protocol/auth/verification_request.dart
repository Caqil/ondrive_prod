import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification_request.g.dart';

@JsonSerializable()
class VerificationRequest extends SerializableEntity {
  @override
  int? id;

  String token;
  VerificationType type;
  String? email; // For resend verification

  VerificationRequest({
    this.id,
    required this.token,
    required this.type,
    this.email,
  });

  factory VerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationRequestToJson(this);
}

@JsonSerializable()
class PasswordResetRequest extends SerializableEntity {
  @override
  int? id;

  String email;

  PasswordResetRequest({
    this.id,
    required this.email,
  });

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}

@JsonSerializable()
class PasswordResetConfirmRequest extends SerializableEntity {
  @override
  int? id;

  String token;
  String newPassword;
  String confirmPassword;

  PasswordResetConfirmRequest({
    this.id,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  bool get isValid =>
      newPassword.isNotEmpty &&
      newPassword == confirmPassword &&
      newPassword.length >= 8;

  factory PasswordResetConfirmRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetConfirmRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordResetConfirmRequestToJson(this);
}

@JsonSerializable()
class ChangePasswordRequest extends SerializableEntity {
  @override
  int? id;

  String currentPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswordRequest({
    this.id,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  bool get isValid =>
      currentPassword.isNotEmpty &&
      newPassword.isNotEmpty &&
      newPassword == confirmPassword &&
      newPassword.length >= 8 &&
      currentPassword != newPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}

enum VerificationType {
  emailVerification,
  phoneVerification,
  passwordReset,
  twoFactorAuth,
}
