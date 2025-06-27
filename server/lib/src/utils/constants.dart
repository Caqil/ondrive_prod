class AppConstants {
  // App Information
  static const String appName = 'RideHailing';
  static const String appVersion = '1.0.0';
  static const String apiVersion = 'v1';

  // Default Values
  static const String defaultCurrency = 'USD';
  static const String defaultLanguage = 'en';
  static const String defaultTimezone = 'UTC';
  static const String defaultCountry = 'US';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 1;

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxLoginAttemptsPerHour = 5;
  static const int maxPasswordResetAttemptsPerDay = 3;

  // File Upload Limits
  static const int maxProfileImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxDocumentSize = 10 * 1024 * 1024; // 10MB
  static const int maxVehiclePhotoSize = 8 * 1024 * 1024; // 8MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp'
  ];
  static const List<String> allowedDocumentTypes = [
    'application/pdf',
    'image/jpeg',
    'image/png'
  ];

  // Session and Token
  static const Duration accessTokenExpiry = Duration(hours: 24);
  static const Duration refreshTokenExpiry = Duration(days: 7);
  static const Duration verificationTokenExpiry = Duration(hours: 24);
  static const Duration passwordResetTokenExpiry = Duration(hours: 1);
  static const Duration sessionTimeout = Duration(hours: 2);

  // Location and Distance
  static const double defaultSearchRadius = 10.0; // km
  static const double maxSearchRadius = 50.0; // km
  static const double minSearchRadius = 1.0; // km
  static const double maxRideDistance = 100.0; // km
  static const double locationAccuracyThreshold = 50.0; // meters
  static const int locationUpdateInterval = 30; // seconds
  static const int maxLocationAge = 300; // seconds (5 minutes)

  // Ride Configuration
  static const int maxPassengersPerRide = 8;
  static const int maxWaypointsPerRide = 10;
  static const Duration maxRideDuration = Duration(hours: 8);
  static const Duration rideRequestTimeout = Duration(minutes: 10);
  static const Duration driverResponseTimeout = Duration(minutes: 2);
  static const Duration pickupWaitTime = Duration(minutes: 5);
  static const Duration maxWaitTimeAtPickup = Duration(minutes: 15);

  // Fare and Pricing
  static const double minimumFare = 5.00; // USD
  static const double maximumFare = 500.00; // USD
  static const double defaultCommissionRate = 12.5; // percentage
  static const double minimumCommissionRate = 5.0; // percentage
  static const double maximumCommissionRate = 25.0; // percentage
  static const double maxSurgeMultiplier = 5.0;
  static const double defaultTipPercentage = 15.0;
  static const double maximumTipPercentage = 30.0;

  // Negotiation
  static const int maxNegotiationRounds = 3;
  static const Duration negotiationTimeout = Duration(minutes: 15);
  static const Duration offerTimeout = Duration(minutes: 5);
  static const double maxFareVariation = 50.0; // percentage
  static const double minFareVariation = -20.0; // percentage

  // Driver Requirements
  static const int minDriverAge = 21;
  static const int maxDriverAge = 70;
  static const int minDrivingExperience = 2; // years
  static const double minDriverRating = 3.0;
  static const int minVehicleYear = 2010;
  static const int maxVehicleAge = 15; // years
  static const double maxVehicleMileage = 200000.0; // km

  // Safety and Security
  static const int maxLoginAttempts = 5;
  static const Duration accountLockoutDuration = Duration(hours: 1);
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const double maxSpeedLimit = 120.0; // km/h
  static const int emergencyResponseTimeout = 30; // seconds
  static const Duration driverInactivityTimeout = Duration(minutes: 15);

  // Payment Processing
  static const Duration paymentTimeout = Duration(minutes: 5);
  static const int maxPaymentRetries = 3;
  static const Duration paymentRetryDelay = Duration(minutes: 1);
  static const double maxRefundAmount = 1000.0; // USD
  static const Duration refundProcessingTime = Duration(days: 5);

  // Notification Settings
  static const int maxNotificationBatchSize = 1000;
  static const Duration notificationRetryDelay = Duration(minutes: 5);
  static const int maxNotificationRetries = 3;
  static const Duration pushNotificationTTL = Duration(hours: 24);

  // Database Configuration
  static const int dbConnectionPoolSize = 20;
  static const Duration dbConnectionTimeout = Duration(seconds: 30);
  static const Duration dbQueryTimeout = Duration(seconds: 60);
  static const int maxDbRetries = 3;

  // Cache Configuration
  static const Duration cacheDefaultTTL = Duration(hours: 1);
  static const Duration userCacheTTL = Duration(minutes: 30);
  static const Duration locationCacheTTL = Duration(minutes: 5);
  static const Duration routeCacheTTL = Duration(minutes: 15);
  static const Duration fareCacheTTL = Duration(minutes: 10);

  // External API Configuration
  static const Duration httpTimeout = Duration(seconds: 30);
  static const int maxHttpRetries = 3;
  static const Duration httpRetryDelay = Duration(seconds: 5);

  // Batch Processing
  static const int batchProcessingSize = 100;
  static const Duration batchProcessingInterval = Duration(minutes: 5);
  static const int maxBatchRetries = 3;

  // Audit and Logging
  static const Duration auditLogRetention = Duration(days: 365);
  static const Duration errorLogRetention = Duration(days: 90);
  static const Duration accessLogRetention = Duration(days: 30);
  static const int maxLogFileSize = 100 * 1024 * 1024; // 100MB

  // Business Rules
  static const int minRidesForDriverRating = 5;
  static const int minRidesForPassengerRating = 3;
  static const Duration rideHistoryRetention = Duration(days: 2555); // 7 years
  static const Duration inactiveUserRetention = Duration(days: 1095); // 3 years

  // Performance Thresholds
  static const Duration maxResponseTime = Duration(milliseconds: 2000);
  static const double maxCpuUsage = 80.0; // percentage
  static const double maxMemoryUsage = 85.0; // percentage
  static const double maxDiskUsage = 90.0; // percentage

  // Feature Flags
  static const bool enableFareNegotiation = true;
  static const bool enableRidePooling = true;
  static const bool enableScheduledRides = true;
  static const bool enableMultiStopRides = true;
  static const bool enableRealTimeTracking = true;
  static const bool enablePushNotifications = true;
  static const bool enableEmailNotifications = true;
  static const bool enableSmsNotifications = false;
  static const bool enableSocialLogin = true;
  static const bool enableBiometricAuth = true;
  static const bool enableOfflineMode = true;
}

class RegexPatterns {
  // Email validation
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Phone validation (international format)
  static const String phone = r'^\+?[1-9]\d{1,14}$';

  // Password validation (at least 8 chars, 1 upper, 1 lower, 1 number)
  static const String strongPassword =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // Name validation (letters, spaces, hyphens, apostrophes)
  static const String name = r"^[a-zA-Z\s\-'\.]{2,50}$";

  // License plate validation (alphanumeric with optional spaces/hyphens)
  static const String licensePlate = r'^[A-Z0-9\s\-]{3,10}$';

  // Vehicle VIN validation
  static const String vin = r'^[A-HJ-NPR-Z0-9]{17}$';

  // Latitude validation
  static const String latitude = r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?)$';

  // Longitude validation
  static const String longitude =
      r'^[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$';

  // Currency amount validation (up to 2 decimal places)
  static const String currency = r'^\d+(\.\d{1,2})?$';

  // Hex color validation
  static const String hexColor = r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$';

  // URL validation
  static const String url = r'^https?:\/\/[^\s/$.?#].[^\s]*$';

  // UUID validation
  static const String uuid =
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$';

  // Credit card validation (basic format)
  static const String creditCard = r'^\d{13,19}$';

  // Postal code validation (various formats)
  static const String postalCode = r'^[A-Za-z0-9\s\-]{3,10}$';

  // Date validation (YYYY-MM-DD)
  static const String date = r'^\d{4}-\d{2}-\d{2}$';

  // Time validation (HH:MM)
  static const String time = r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$';
}

class StatusCodes {
  // Success codes
  static const int success = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int noContent = 204;

  // Client error codes
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;

  // Server error codes
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}
