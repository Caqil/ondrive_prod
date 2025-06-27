// server/lib/src/utils/error_codes.dart
//
// Comprehensive error code system for ride-hailing platform
// Organized by categories with consistent numbering scheme

class ErrorCodes {
  // =============================================================================
  // AUTHENTICATION ERRORS (1000-1999)
  // =============================================================================
  static const String invalidCredentials = 'AUTH_1001';
  static const String userNotFound = 'AUTH_1002';
  static const String emailAlreadyExists = 'AUTH_1003';
  static const String phoneAlreadyExists = 'AUTH_1004';
  static const String invalidToken = 'AUTH_1005';
  static const String tokenExpired = 'AUTH_1006';
  static const String accountDeactivated = 'AUTH_1007';
  static const String accountSuspended = 'AUTH_1008';
  static const String emailNotVerified = 'AUTH_1009';
  static const String phoneNotVerified = 'AUTH_1010';
  static const String tooManyLoginAttempts = 'AUTH_1011';
  static const String invalidVerificationCode = 'AUTH_1012';
  static const String verificationCodeExpired = 'AUTH_1013';
  static const String passwordTooWeak = 'AUTH_1014';
  static const String socialAuthFailed = 'AUTH_1015';
  static const String biometricAuthFailed = 'AUTH_1016';
  static const String sessionExpired = 'AUTH_1017';
  static const String insufficientPermissions = 'AUTH_1018';
  static const String deviceNotRecognized = 'AUTH_1019';
  static const String multipleActiveSession = 'AUTH_1020';
  static const String authenticationRequired = 'AUTH_1021';
  static const String accessDenied = 'AUTH_1022';

  // Password-specific errors
  static const String passwordTooShort = 'AUTH_1025';
  static const String passwordTooLong = 'AUTH_1026';
  static const String passwordMissingUppercase = 'AUTH_1027';
  static const String passwordMissingLowercase = 'AUTH_1028';
  static const String passwordMissingNumber = 'AUTH_1029';
  static const String passwordMissingSpecialChar = 'AUTH_1030';
  static const String passwordTooCommon = 'AUTH_1031';

  // =============================================================================
  // USER MANAGEMENT ERRORS (2000-2999)
  // =============================================================================
  static const String userValidationFailed = 'USER_2001';
  static const String profileIncomplete = 'USER_2002';
  static const String profileUpdateFailed = 'USER_2003';
  static const String invalidUserType = 'USER_2004';
  static const String userAlreadyExists = 'USER_2005';
  static const String userDeletionFailed = 'USER_2006';
  static const String profileImageUploadFailed = 'USER_2007';
  static const String invalidDateOfBirth = 'USER_2008';
  static const String minAgeRequirement = 'USER_2009';
  static const String maxAgeRequirement = 'USER_2010';
  static const String invalidEmergencyContact = 'USER_2011';
  static const String duplicateEmergencyContact = 'USER_2012';
  static const String settingsUpdateFailed = 'USER_2013';
  static const String preferencesUpdateFailed = 'USER_2014';
  static const String languageNotSupported = 'USER_2015';
  static const String currencyNotSupported = 'USER_2016';
  static const String timezoneNotSupported = 'USER_2017';
  static const String invalidAccessibilityNeed = 'USER_2018';
  static const String referralCodeInvalid = 'USER_2019';
  static const String referralCodeExpired = 'USER_2020';

  // Field-specific validation errors
  static const String invalidEmail = 'USER_2021';
  static const String invalidPhone = 'USER_2022';
  static const String invalidFirstName = 'USER_2023';
  static const String invalidLastName = 'USER_2024';

  // =============================================================================
  // DRIVER MANAGEMENT ERRORS (3000-3999)
  // =============================================================================
  static const String driverNotFound = 'DRIVER_3001';
  static const String driverNotAvailable = 'DRIVER_3002';
  static const String driverNotVerified = 'DRIVER_3003';
  static const String driverDocumentRequired = 'DRIVER_3004';
  static const String driverDocumentExpired = 'DRIVER_3005';
  static const String driverDocumentRejected = 'DRIVER_3006';
  static const String driverLicenseInvalid = 'DRIVER_3007';
  static const String driverLicenseExpired = 'DRIVER_3008';
  static const String driverInsuranceRequired = 'DRIVER_3009';
  static const String driverInsuranceExpired = 'DRIVER_3010';
  static const String driverVehicleRequired = 'DRIVER_3011';
  static const String driverVehicleNotApproved = 'DRIVER_3012';
  static const String driverRatingTooLow = 'DRIVER_3013';
  static const String driverOnline = 'DRIVER_3014';
  static const String driverOffline = 'DRIVER_3015';
  static const String driverBusy = 'DRIVER_3016';
  static const String driverOnTrip = 'DRIVER_3017';
  static const String driverLocationRequired = 'DRIVER_3018';
  static const String driverLocationStale = 'DRIVER_3019';
  static const String driverOutsideServiceArea = 'DRIVER_3020';

  // =============================================================================
  // VEHICLE MANAGEMENT ERRORS (4000-4999)
  // =============================================================================
  static const String vehicleNotFound = 'VEHICLE_4001';
  static const String vehicleNotApproved = 'VEHICLE_4002';
  static const String vehicleRegistrationRequired = 'VEHICLE_4003';
  static const String vehicleRegistrationExpired = 'VEHICLE_4004';
  static const String vehicleInsuranceRequired = 'VEHICLE_4005';
  static const String vehicleInsuranceExpired = 'VEHICLE_4006';
  static const String vehicleInspectionRequired = 'VEHICLE_4007';
  static const String vehicleInspectionExpired = 'VEHICLE_4008';
  static const String vehicleTooOld = 'VEHICLE_4009';
  static const String vehicleMileageTooHigh = 'VEHICLE_4010';
  static const String vehicleTypeNotAllowed = 'VEHICLE_4011';
  static const String vehicleCapacityExceeded = 'VEHICLE_4012';
  static const String vehicleNotAccessible = 'VEHICLE_4013';
  static const String vehicleMaintenanceRequired = 'VEHICLE_4014';
  static const String vehiclePhotoRequired = 'VEHICLE_4015';
  static const String licensePlateInvalid = 'VEHICLE_4016';
  static const String licensePlateDuplicate = 'VEHICLE_4017';
  static const String vinInvalid = 'VEHICLE_4018';
  static const String vinDuplicate = 'VEHICLE_4019';
  static const String vehicleColorRequired = 'VEHICLE_4020';

  // =============================================================================
  // RIDE MANAGEMENT ERRORS (5000-5999)
  // =============================================================================
  static const String rideNotFound = 'RIDE_5001';
  static const String rideAlreadyAssigned = 'RIDE_5002';
  static const String rideInvalidStatus = 'RIDE_5003';
  static const String rideCannotCancel = 'RIDE_5004';
  static const String rideAlreadyStarted = 'RIDE_5005';
  static const String rideAlreadyCompleted = 'RIDE_5006';
  static const String rideDistanceTooLong = 'RIDE_5007';
  static const String rideDistanceTooShort = 'RIDE_5008';
  static const String rideDurationTooLong = 'RIDE_5009';
  static const String rideOutsideServiceArea = 'RIDE_5010';
  static const String rideSchedulingFailed = 'RIDE_5011';
  static const String rideScheduleTooSoon = 'RIDE_5012';
  static const String rideScheduleTooFar = 'RIDE_5013';
  static const String ridePassengerLimit = 'RIDE_5014';
  static const String rideWaypointLimit = 'RIDE_5015';
  static const String ridePreferencesIncompatible = 'RIDE_5016';
  static const String ridePoolingNotAvailable = 'RIDE_5017';
  static const String rideTypeNotAvailable = 'RIDE_5018';
  static const String noDriversAvailable = 'RIDE_5019';
  static const String rideRequestTimeout = 'RIDE_5020';

  // Pickup and verification errors
  static const String invalidPickupCode = 'RIDE_5021';
  static const String pickupCodeExpired = 'RIDE_5022';
  static const String pickupTimeoutExceeded = 'RIDE_5023';

  // =============================================================================
  // LOCATION ERRORS (6000-6999)
  // =============================================================================
  static const String invalidLocation = 'LOCATION_6001';
  static const String locationRequired = 'LOCATION_6002';
  static const String pickupLocationInvalid = 'LOCATION_6003';
  static const String dropoffLocationInvalid = 'LOCATION_6004';
  static const String locationTooClose = 'LOCATION_6005';
  static const String locationTooFar = 'LOCATION_6006';
  static const String locationNotAccessible = 'LOCATION_6007';
  static const String locationOutsideServiceArea = 'LOCATION_6008';
  static const String locationGeocodingFailed = 'LOCATION_6009';
  static const String locationReverseGeocodingFailed = 'LOCATION_6010';
  static const String routeCalculationFailed = 'LOCATION_6011';
  static const String routeNotFound = 'LOCATION_6012';
  static const String routeTooLong = 'LOCATION_6013';
  static const String routeOptimizationFailed = 'LOCATION_6014';
  static const String waypointInvalid = 'LOCATION_6015';
  static const String waypointTooMany = 'LOCATION_6016';
  static const String locationAccuracyTooLow = 'LOCATION_6017';
  static const String locationUpdateTooOld = 'LOCATION_6018';
  static const String geofenceViolation = 'LOCATION_6019';
  static const String locationTrackingDisabled = 'LOCATION_6020';

  // ETA and tracking errors
  static const String etaNotAvailable = 'LOCATION_6021';
  static const String etaCalculationFailed = 'LOCATION_6022';
  static const String trackingNotStarted = 'LOCATION_6023';
  static const String trackingAlreadyActive = 'LOCATION_6024';

  // =============================================================================
  // PAYMENT ERRORS (7000-7999)
  // =============================================================================
  static const String paymentFailed = 'PAYMENT_7001';
  static const String paymentMethodInvalid = 'PAYMENT_7002';
  static const String paymentMethodExpired = 'PAYMENT_7003';
  static const String paymentMethodNotAllowed = 'PAYMENT_7004';
  static const String insufficientFunds = 'PAYMENT_7005';
  static const String paymentAmountInvalid = 'PAYMENT_7006';
  static const String paymentAmountTooLow = 'PAYMENT_7007';
  static const String paymentAmountTooHigh = 'PAYMENT_7008';
  static const String paymentProcessingError = 'PAYMENT_7009';
  static const String paymentTimeout = 'PAYMENT_7010';
  static const String paymentDuplicate = 'PAYMENT_7011';
  static const String paymentRefundFailed = 'PAYMENT_7012';
  static const String paymentRefundNotAllowed = 'PAYMENT_7013';
  static const String cardDeclined = 'PAYMENT_7014';
  static const String cardExpired = 'PAYMENT_7015';
  static const String cardInvalid = 'PAYMENT_7016';
  static const String cardNotSupported = 'PAYMENT_7017';
  static const String paymentCurrencyNotSupported = 'PAYMENT_7018';
  static const String commissionCalculationFailed = 'PAYMENT_7019';
  static const String fareCalculationFailed = 'PAYMENT_7020';

  // Card-specific validation errors
  static const String invalidCardNumber = 'PAYMENT_7021';
  static const String invalidCardExpiry = 'PAYMENT_7022';
  static const String invalidCvv = 'PAYMENT_7023';
  static const String invalidCurrency = 'PAYMENT_7024';
  static const String invalidPaymentAmount = 'PAYMENT_7025';

  // =============================================================================
  // FARE AND NEGOTIATION ERRORS (8000-8999)
  // =============================================================================
  static const String fareInvalid = 'FARE_8001';
  static const String fareTooLow = 'FARE_8002';
  static const String fareTooHigh = 'FARE_8003';
  static const String fareNegotiationFailed = 'FARE_8004';
  static const String fareNegotiationExpired = 'FARE_8005';
  static const String fareNegotiationMaxRounds = 'FARE_8006';
  static const String fareOfferInvalid = 'FARE_8007';
  static const String fareOfferExpired = 'FARE_8008';
  static const String fareOfferRejected = 'FARE_8009';
  static const String fareOfferAccepted = 'FARE_8010';
  static const String surgeActive = 'FARE_8011';
  static const String surgeNotApplicable = 'FARE_8012';
  static const String discountInvalid = 'FARE_8013';
  static const String discountExpired = 'FARE_8014';
  static const String discountNotApplicable = 'FARE_8015';
  static const String promoCodeInvalid = 'FARE_8016';
  static const String promoCodeExpired = 'FARE_8017';
  static const String promoCodeUsageLimitReached = 'FARE_8018';
  static const String couponInvalid = 'FARE_8019';
  static const String couponExpired = 'FARE_8020';

  // InDrive-specific negotiation errors
  static const String negotiationNotFound = 'NEGOTIATION_8021';
  static const String negotiationClosed = 'NEGOTIATION_8022';
  static const String negotiationExpired = 'NEGOTIATION_8023';
  static const String offerNotFound = 'NEGOTIATION_8024';
  static const String offerExpired = 'NEGOTIATION_8025';
  static const String offerAlreadyExists = 'NEGOTIATION_8026';
  static const String invalidFareAmount = 'NEGOTIATION_8027';
  static const String negotiationLimitExceeded = 'NEGOTIATION_8028';

  // =============================================================================
  // FILE UPLOAD ERRORS (9000-9999)
  // =============================================================================
  static const String fileUploadFailed = 'FILE_9001';
  static const String fileTooLarge = 'FILE_9002';
  static const String fileTypeNotAllowed = 'FILE_9003';
  static const String fileCorrupted = 'FILE_9004';
  static const String fileVirusDetected = 'FILE_9005';
  static const String fileStorageFull = 'FILE_9006';
  static const String fileNotFound = 'FILE_9007';
  static const String fileAccessDenied = 'FILE_9008';
  static const String fileProcessingFailed = 'FILE_9009';
  static const String imageProcessingFailed = 'FILE_9010';
  static const String imageResolutionTooLow = 'FILE_9011';
  static const String imageResolutionTooHigh = 'FILE_9012';
  static const String documentValidationFailed = 'FILE_9013';
  static const String documentExpired = 'FILE_9014';
  static const String documentNotReadable = 'FILE_9015';
  static const String documentMissingInfo = 'FILE_9016';
  static const String profilePhotoRequired = 'FILE_9017';
  static const String licensePhotoRequired = 'FILE_9019';
  static const String insuranceDocumentRequired = 'FILE_9020';

  // =============================================================================
  // NOTIFICATION ERRORS (10000-10999)
  // =============================================================================
  static const String notificationSendFailed = 'NOTIFICATION_10001';
  static const String notificationInvalidRecipient = 'NOTIFICATION_10002';
  static const String notificationTemplateNotFound = 'NOTIFICATION_10003';
  static const String notificationPreferencesRequired = 'NOTIFICATION_10004';
  static const String pushNotificationFailed = 'NOTIFICATION_10005';
  static const String emailNotificationFailed = 'NOTIFICATION_10006';
  static const String smsNotificationFailed = 'NOTIFICATION_10007';
  static const String notificationQuotaExceeded = 'NOTIFICATION_10008';
  static const String notificationServiceUnavailable = 'NOTIFICATION_10009';
  static const String fcmTokenInvalid = 'NOTIFICATION_10010';
  static const String fcmTokenExpired = 'NOTIFICATION_10011';
  static const String emailTemplateInvalid = 'NOTIFICATION_10012';
  static const String emailDeliveryFailed = 'NOTIFICATION_10013';
  static const String smsProviderError = 'NOTIFICATION_10014';
  static const String notificationBatchTooLarge = 'NOTIFICATION_10015';
  static const String notificationRateLimitExceeded = 'NOTIFICATION_10016';
  static const String notificationContentInvalid = 'NOTIFICATION_10017';
  static const String inAppNotificationFailed = 'NOTIFICATION_10018';
  static const String notificationSchedulingFailed = 'NOTIFICATION_10019';
  static const String notificationChannelBlocked = 'NOTIFICATION_10020';

  // =============================================================================
  // WEBSOCKET ERRORS (11000-11499)
  // =============================================================================
  static const String websocketConnectionFailed = 'WEBSOCKET_11001';
  static const String websocketConnectionClosed = 'WEBSOCKET_11002';
  static const String websocketMessageInvalid = 'WEBSOCKET_11003';
  static const String websocketMessageTooLarge = 'WEBSOCKET_11004';
  static const String websocketRoomFull = 'WEBSOCKET_11005';
  static const String websocketRoomNotFound = 'WEBSOCKET_11006';
  static const String websocketUserNotInRoom = 'WEBSOCKET_11007';
  static const String websocketBroadcastFailed = 'WEBSOCKET_11008';
  static const String websocketHandlerNotFound = 'WEBSOCKET_11009';
  static const String websocketTimeout = 'WEBSOCKET_11010';

  // Chat-specific WebSocket errors
  static const String chatMessageTooLong = 'CHAT_11011';
  static const String chatMessageEmpty = 'CHAT_11012';
  static const String chatHistoryNotAvailable = 'CHAT_11013';
  static const String chatPermissionDenied = 'CHAT_11014';

  // =============================================================================
  // VALIDATION ERRORS (11500-11999)
  // =============================================================================
  static const String validationFailed = 'VALIDATION_11501';
  static const String invalidRequestFormat = 'VALIDATION_11502';
  static const String requiredFieldMissing = 'VALIDATION_11503';
  static const String invalidFieldFormat = 'VALIDATION_11504';
  static const String fieldTooLong = 'VALIDATION_11505';
  static const String fieldTooShort = 'VALIDATION_11506';
  static const String invalidEnumValue = 'VALIDATION_11507';
  static const String invalidDateFormat = 'VALIDATION_11508';
  static const String invalidTimeFormat = 'VALIDATION_11509';
  static const String invalidUuidFormat = 'VALIDATION_11510';
  static const String invalidJsonFormat = 'VALIDATION_11511';
  static const String duplicateValue = 'VALIDATION_11512';
  static const String valueOutOfRange = 'VALIDATION_11513';
  static const String invalidRegexPattern = 'VALIDATION_11514';
  static const String conflictingValues = 'VALIDATION_11515';

  // =============================================================================
  // SYSTEM ERRORS (12000-12999)
  // =============================================================================
  static const String systemError = 'SYSTEM_12001';
  static const String systemMaintenance = 'SYSTEM_12002';
  static const String systemOverloaded = 'SYSTEM_12003';
  static const String databaseError = 'SYSTEM_12004';
  static const String databaseConnectionFailed = 'SYSTEM_12005';
  static const String databaseQueryTimeout = 'SYSTEM_12006';
  static const String cacheError = 'SYSTEM_12007';
  static const String cacheConnectionFailed = 'SYSTEM_12008';
  static const String externalServiceError = 'SYSTEM_12009';
  static const String externalServiceTimeout = 'SYSTEM_12010';
  static const String configurationError = 'SYSTEM_12011';
  static const String internalServerError = 'SYSTEM_12012';
  static const String serviceUnavailable = 'SYSTEM_12013';
  static const String rateLimitExceeded = 'SYSTEM_12014';
  static const String resourceLimitExceeded = 'SYSTEM_12015';
  static const String memoryLimitExceeded = 'SYSTEM_12016';
  static const String diskSpaceFull = 'SYSTEM_12017';
  static const String networkError = 'SYSTEM_12018';
  static const String apiVersionNotSupported = 'SYSTEM_12019';
  static const String featureNotAvailable = 'SYSTEM_12020';

  // =============================================================================
  // TRACKING ERRORS (13000-13999)
  // =============================================================================
  static const String trackingServiceError = 'TRACKING_13001';
  static const String trackingDataCorrupted = 'TRACKING_13002';
  static const String trackingSessionNotFound = 'TRACKING_13003';
  static const String trackingSessionExpired = 'TRACKING_13004';
  static const String trackingPermissionDenied = 'TRACKING_13005';
  static const String trackingLocationStale = 'TRACKING_13006';
  static const String trackingAccuracyTooLow = 'TRACKING_13007';
  static const String trackingDeviceOffline = 'TRACKING_13008';
  static const String trackingBatteryLow = 'TRACKING_13009';
  static const String trackingSignalLost = 'TRACKING_13010';

  // =============================================================================
  // UTILITY METHODS
  // =============================================================================

  /// Get user-friendly error message for error code
  static String getMessage(String code) {
    switch (code) {
      // Authentication errors
      case invalidCredentials:
        return 'Invalid email/phone or password';
      case userNotFound:
        return 'User account not found';
      case emailAlreadyExists:
        return 'Email address is already registered';
      case phoneAlreadyExists:
        return 'Phone number is already registered';
      case authenticationRequired:
        return 'Authentication is required';
      case accessDenied:
        return 'Access denied';
      case tokenExpired:
        return 'Session has expired. Please log in again';

      // Password errors
      case passwordTooShort:
        return 'Password must be at least 8 characters long';
      case passwordTooLong:
        return 'Password must be no more than 128 characters long';
      case passwordMissingUppercase:
        return 'Password must contain at least one uppercase letter';
      case passwordMissingLowercase:
        return 'Password must contain at least one lowercase letter';
      case passwordMissingNumber:
        return 'Password must contain at least one number';
      case passwordMissingSpecialChar:
        return 'Password must contain at least one special character';
      case passwordTooCommon:
        return 'Password is too common. Please choose a more secure password';

      // User validation errors
      case invalidEmail:
        return 'Please enter a valid email address';
      case invalidPhone:
        return 'Please enter a valid phone number';
      case invalidFirstName:
        return 'Please enter a valid first name';
      case invalidLastName:
        return 'Please enter a valid last name';

      // Ride errors
      case rideNotFound:
        return 'Ride not found';
      case rideCannotCancel:
        return 'Ride cannot be cancelled at this time';
      case noDriversAvailable:
        return 'No drivers available in your area';
      case rideScheduleTooSoon:
        return 'Ride cannot be scheduled less than 15 minutes in advance';
      case rideScheduleTooFar:
        return 'Ride cannot be scheduled more than 30 days in advance';
      case invalidPickupCode:
        return 'Invalid pickup verification code';

      // Location errors
      case invalidLocation:
        return 'Invalid location coordinates';
      case locationTooClose:
        return 'Pickup and dropoff locations are too close';
      case locationOutsideServiceArea:
        return 'Location is outside our service area';
      case etaNotAvailable:
        return 'ETA calculation is not available';

      // Payment errors
      case paymentFailed:
        return 'Payment processing failed';
      case insufficientFunds:
        return 'Insufficient funds';
      case cardExpired:
        return 'Credit card has expired';
      case invalidCardNumber:
        return 'Invalid credit card number';
      case invalidCurrency:
        return 'Currency not supported';

      // Negotiation errors
      case negotiationNotFound:
        return 'Negotiation not found';
      case negotiationClosed:
        return 'Negotiation has been closed';
      case offerExpired:
        return 'Offer has expired';
      case invalidFareAmount:
        return 'Invalid fare amount';

      // WebSocket errors
      case websocketConnectionFailed:
        return 'Failed to establish real-time connection';
      case chatMessageTooLong:
        return 'Message is too long';
      case chatMessageEmpty:
        return 'Message cannot be empty';

      // Validation errors
      case validationFailed:
        return 'Validation failed';
      case invalidRequestFormat:
        return 'Invalid request format';
      case requiredFieldMissing:
        return 'Required field is missing';

      // System errors
      case internalServerError:
        return 'Internal server error. Please try again later';
      case systemMaintenance:
        return 'System is under maintenance. Please try again later';
      case rateLimitExceeded:
        return 'Too many requests. Please try again later';

      // Driver errors
      case driverNotFound:
        return 'Driver not found';
      case driverNotAvailable:
        return 'Driver is not available';

      // Vehicle errors
      case vehicleNotFound:
        return 'Vehicle not found';
      case licensePlateInvalid:
        return 'Invalid license plate format';

      // Tracking errors
      case trackingSessionNotFound:
        return 'Tracking session not found';
      case trackingPermissionDenied:
        return 'Location tracking permission denied';

      default:
        return 'An error occurred. Please try again';
    }
  }

  /// Get HTTP status code for error code
  static int getHttpStatusCode(String code) {
    // Authentication errors
    if (code.startsWith('AUTH_')) {
      if (code == authenticationRequired || code == tokenExpired) return 401;
      if (code == accessDenied) return 403;
      return 401;
    }

    // User errors
    if (code.startsWith('USER_')) {
      if (code == userNotFound) return 404;
      if (code == emailAlreadyExists || code == phoneAlreadyExists) return 409;
      return 400;
    }

    // Driver errors
    if (code.startsWith('DRIVER_')) {
      if (code == driverNotFound) return 404;
      return 400;
    }

    // Vehicle errors
    if (code.startsWith('VEHICLE_')) {
      if (code == vehicleNotFound) return 404;
      return 400;
    }

    // Ride errors
    if (code.startsWith('RIDE_')) {
      if (code == rideNotFound) return 404;
      return 400;
    }

    // Location errors
    if (code.startsWith('LOCATION_')) return 400;

    // Payment errors
    if (code.startsWith('PAYMENT_')) return 402;

    // Fare/negotiation errors
    if (code.startsWith('FARE_') || code.startsWith('NEGOTIATION_')) {
      if (code == negotiationNotFound || code == offerNotFound) return 404;
      return 400;
    }

    // File errors
    if (code.startsWith('FILE_')) {
      if (code == fileNotFound) return 404;
      if (code == fileAccessDenied) return 403;
      return 400;
    }

    // Notification errors
    if (code.startsWith('NOTIFICATION_')) return 500;

    // WebSocket errors
    if (code.startsWith('WEBSOCKET_') || code.startsWith('CHAT_')) return 400;

    // Validation errors
    if (code.startsWith('VALIDATION_')) return 400;

    // System errors
    if (code.startsWith('SYSTEM_')) {
      if (code == rateLimitExceeded) return 429;
      if (code == systemMaintenance || code == serviceUnavailable) return 503;
      return 500;
    }

    // Tracking errors
    if (code.startsWith('TRACKING_')) {
      if (code == trackingSessionNotFound) return 404;
      if (code == trackingPermissionDenied) return 403;
      return 400;
    }

    // Default
    return 400;
  }

  /// Get error category from error code
  static String getCategory(String code) {
    if (code.startsWith('AUTH_')) return 'Authentication';
    if (code.startsWith('USER_')) return 'User Management';
    if (code.startsWith('DRIVER_')) return 'Driver Management';
    if (code.startsWith('VEHICLE_')) return 'Vehicle Management';
    if (code.startsWith('RIDE_')) return 'Ride Management';
    if (code.startsWith('LOCATION_')) return 'Location Services';
    if (code.startsWith('PAYMENT_')) return 'Payment Processing';
    if (code.startsWith('FARE_') || code.startsWith('NEGOTIATION_'))
      return 'Fare Negotiation';
    if (code.startsWith('FILE_')) return 'File Management';
    if (code.startsWith('NOTIFICATION_')) return 'Notifications';
    if (code.startsWith('WEBSOCKET_') || code.startsWith('CHAT_'))
      return 'Real-time Communication';
    if (code.startsWith('VALIDATION_')) return 'Data Validation';
    if (code.startsWith('SYSTEM_')) return 'System';
    if (code.startsWith('TRACKING_')) return 'Location Tracking';
    return 'General';
  }

  /// Check if error code indicates a retryable error
  static bool isRetryable(String code) {
    const retryableCodes = [
      systemError,
      databaseConnectionFailed,
      databaseQueryTimeout,
      externalServiceTimeout,
      networkError,
      paymentTimeout,
      notificationSendFailed,
      websocketConnectionFailed,
      trackingServiceError,
    ];
    return retryableCodes.contains(code);
  }

  /// Check if error code indicates a client error (4xx)
  static bool isClientError(String code) {
    final statusCode = getHttpStatusCode(code);
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if error code indicates a server error (5xx)
  static bool isServerError(String code) {
    final statusCode = getHttpStatusCode(code);
    return statusCode >= 500;
  }

  /// Get all error codes in a category
  static List<String> getErrorCodesInCategory(String category) {
    // This would return all error codes that belong to a specific category
    // Implementation depends on your specific needs
    final allCodes = <String>[];

    switch (category.toLowerCase()) {
      case 'authentication':
        allCodes.addAll([
          invalidCredentials,
          userNotFound,
          emailAlreadyExists,
          phoneAlreadyExists,
          invalidToken,
          tokenExpired,
          accountDeactivated,
          accountSuspended,
          emailNotVerified,
          phoneNotVerified,
          authenticationRequired,
          accessDenied,
        ]);
        break;
      case 'payment':
        allCodes.addAll([
          paymentFailed,
          paymentMethodInvalid,
          insufficientFunds,
          cardExpired,
          invalidCardNumber,
          invalidCurrency,
          paymentTimeout,
        ]);
        break;
      // Add other categories as needed
    }

    return allCodes;
  }
}
