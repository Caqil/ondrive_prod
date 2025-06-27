import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest extends SerializableEntity {
  @override
  int? id;

  String email;
  String phone;
  String firstName;
  String lastName;
  String password;
  String confirmPassword;
  UserType userType;
  bool agreeToTerms;
  bool agreeToPrivacyPolicy;
  String? referralCode;
  String? deviceId;
  String? deviceType;
  String? fcmToken;

  RegisterRequest({
    this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.userType,
    this.agreeToTerms = false,
    this.agreeToPrivacyPolicy = false,
    this.referralCode,
    this.deviceId,
    this.deviceType,
    this.fcmToken,
  });

  bool get isValid {
    return email.isNotEmpty &&
        phone.isNotEmpty &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        password.isNotEmpty &&
        password == confirmPassword &&
        password.length >= 8 &&
        agreeToTerms &&
        agreeToPrivacyPolicy;
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
