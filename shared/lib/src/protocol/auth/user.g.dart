// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String,
      phone: json['phone'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isOnline: json['isOnline'] as bool? ?? false,
      profile: json['profile'] == null
          ? null
          : UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
      driverProfile: json['driverProfile'] == null
          ? null
          : DriverProfile.fromJson(
              json['driverProfile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'isOnline': instance.isOnline,
      'profile': instance.profile,
      'settings': instance.settings,
      'driverProfile': instance.driverProfile,
    };

const _$UserTypeEnumMap = {
  UserType.passenger: 'passenger',
  UserType.driver: 'driver',
  UserType.admin: 'admin',
};

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['en'],
      preferences: json['preferences'] as Map<String, dynamic>? ?? const {},
      rating: (json['rating'] as num?)?.toDouble(),
      totalRides: (json['totalRides'] as num?)?.toInt() ?? 0,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      occupation: json['occupation'] as String?,
      isAccessibilityEnabled: json['isAccessibilityEnabled'] as bool? ?? false,
      accessibilityNeeds: (json['accessibilityNeeds'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AccessibilityNeedEnumMap, e))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'emergencyContactName': instance.emergencyContactName,
      'emergencyContactPhone': instance.emergencyContactPhone,
      'languages': instance.languages,
      'preferences': instance.preferences,
      'rating': instance.rating,
      'totalRides': instance.totalRides,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'occupation': instance.occupation,
      'isAccessibilityEnabled': instance.isAccessibilityEnabled,
      'accessibilityNeeds': instance.accessibilityNeeds
          .map((e) => _$AccessibilityNeedEnumMap[e]!)
          .toList(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
  Gender.preferNotToSay: 'preferNotToSay',
};

const _$AccessibilityNeedEnumMap = {
  AccessibilityNeed.wheelchairAccessible: 'wheelchairAccessible',
  AccessibilityNeed.hearingImpaired: 'hearingImpaired',
  AccessibilityNeed.visuallyImpaired: 'visuallyImpaired',
  AccessibilityNeed.mobilityAssistance: 'mobilityAssistance',
  AccessibilityNeed.serviceAnimal: 'serviceAnimal',
  AccessibilityNeed.other: 'other',
};

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled:
          json['smsNotificationsEnabled'] as bool? ?? false,
      locationSharingEnabled: json['locationSharingEnabled'] as bool? ?? true,
      autoAcceptRides: json['autoAcceptRides'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      preferredCurrency: json['preferredCurrency'] as String? ?? 'USD',
      theme: json['theme'] as String? ?? 'auto',
      notificationPreferences:
          (json['notificationPreferences'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              const {},
      appPreferences:
          json['appPreferences'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'smsNotificationsEnabled': instance.smsNotificationsEnabled,
      'locationSharingEnabled': instance.locationSharingEnabled,
      'autoAcceptRides': instance.autoAcceptRides,
      'preferredLanguage': instance.preferredLanguage,
      'preferredCurrency': instance.preferredCurrency,
      'theme': instance.theme,
      'notificationPreferences': instance.notificationPreferences,
      'appPreferences': instance.appPreferences,
    };
