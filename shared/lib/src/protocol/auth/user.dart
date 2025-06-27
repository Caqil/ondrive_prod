import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../drivers/driver_profile.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends SerializableEntity {
  @override
  int? id;

  String email;
  String phone;
  String firstName;
  String lastName;
  UserType userType;
  String? profileImageUrl;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? lastLoginAt;
  bool isVerified;
  bool isActive;
  bool isOnline;
  UserProfile? profile;
  UserSettings? settings;

  // Driver-specific fields (null for passengers)
  DriverProfile? driverProfile;

  // Security fields (not exposed to client)
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? passwordHash;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? verificationToken;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? verificationTokenExpiry;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? passwordResetToken;
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? passwordResetExpiry;

  User({
    this.id,
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.isVerified = false,
    this.isActive = true,
    this.isOnline = false,
    this.profile,
    this.settings,
    this.driverProfile,
  });

  String get fullName => '$firstName $lastName';
  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
          .toUpperCase();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserProfile extends SerializableEntity {
  @override
  int? id;

  int userId;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  String? emergencyContactName;
  String? emergencyContactPhone;
  List<String> languages;
  Map<String, dynamic> preferences;
  double? rating;
  int totalRides;
  DateTime? dateOfBirth;
  Gender? gender;
  String? occupation;
  bool isAccessibilityEnabled;
  List<AccessibilityNeed> accessibilityNeeds;

  UserProfile({
    this.id,
    required this.userId,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.languages = const ['en'],
    this.preferences = const {},
    this.rating,
    this.totalRides = 0,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.isAccessibilityEnabled = false,
    this.accessibilityNeeds = const [],
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}

@JsonSerializable()
class UserSettings extends SerializableEntity {
  @override
  int? id;

  int userId;
  bool pushNotificationsEnabled;
  bool emailNotificationsEnabled;
  bool smsNotificationsEnabled;
  bool locationSharingEnabled;
  bool autoAcceptRides;
  String preferredLanguage;
  String preferredCurrency;
  String theme; // 'light', 'dark', 'auto'
  Map<String, bool> notificationPreferences;
  Map<String, dynamic> appPreferences;

  UserSettings({
    this.id,
    required this.userId,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.smsNotificationsEnabled = false,
    this.locationSharingEnabled = true,
    this.autoAcceptRides = false,
    this.preferredLanguage = 'en',
    this.preferredCurrency = 'USD',
    this.theme = 'auto',
    this.notificationPreferences = const {},
    this.appPreferences = const {},
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}

enum UserType {
  passenger,
  driver,
  admin,
}

enum Gender {
  male,
  female,
  other,
  preferNotToSay,
}

enum AccessibilityNeed {
  wheelchairAccessible,
  hearingImpaired,
  visuallyImpaired,
  mobilityAssistance,
  serviceAnimal,
  other,
}
