// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationRequest _$VerificationRequestFromJson(Map<String, dynamic> json) =>
    VerificationRequest(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String,
      type: $enumDecode(_$VerificationTypeEnumMap, json['type']),
      email: json['email'] as String?,
    );

Map<String, dynamic> _$VerificationRequestToJson(
        VerificationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'type': _$VerificationTypeEnumMap[instance.type]!,
      'email': instance.email,
    };

const _$VerificationTypeEnumMap = {
  VerificationType.emailVerification: 'emailVerification',
  VerificationType.phoneVerification: 'phoneVerification',
  VerificationType.passwordReset: 'passwordReset',
  VerificationType.twoFactorAuth: 'twoFactorAuth',
};

PasswordResetRequest _$PasswordResetRequestFromJson(
        Map<String, dynamic> json) =>
    PasswordResetRequest(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String,
    );

Map<String, dynamic> _$PasswordResetRequestToJson(
        PasswordResetRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
    };

PasswordResetConfirmRequest _$PasswordResetConfirmRequestFromJson(
        Map<String, dynamic> json) =>
    PasswordResetConfirmRequest(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$PasswordResetConfirmRequestToJson(
        PasswordResetConfirmRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };

ChangePasswordRequest _$ChangePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequest(
      id: (json['id'] as num?)?.toInt(),
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestToJson(
        ChangePasswordRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };
