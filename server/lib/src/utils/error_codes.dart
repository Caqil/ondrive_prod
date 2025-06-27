class ErrorCodes {
  // Authentication Errors (1000-1999)
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

  // User Management Errors (2000-2999)
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

  // Driver Management Errors (3000-3999)
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

  // Vehicle Management Errors (4000-4999)
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

  // Ride Management Errors (5000-5999)
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

  // Location Errors (6000-6999)
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

  // Payment Errors (7000-7999)
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
  static const String commissCalculationFailed = 'PAYMENT_7019';
  static const String fareCalculationFailed = 'PAYMENT_7020';

  // Fare and Negotiation Errors (8000-8999)
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

  // File Upload Errors (9000-9999)
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

  // Notification Errors (10000-10999)
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

  // System Errors (11000-11999)
  static const String systemError = 'SYSTEM_11001';
  static const String systemMaintenance = 'SYSTEM_11002';
  static const String systemOverloaded = 'SYSTEM_11003';
  static const String databaseError = 'SYSTEM_11004';
  static const String databaseConnectionFailed = 'SYSTEM_11005';
  static const String databaseQueryTimeout = 'SYSTEM_11006';
  static const String cacheError = 'SYSTEM_11007';
  static const String cacheConnectionFailed = 'SYSTEM_11008';
  static const String externalServiceError = 'SYSTEM_11009';
  static const String externalServiceTimeout = 'SYSTEM_11010';
  static const String configurationError = 'SYSTEM_11011';
  static const String featureNotAvailable = 'SYSTEM_11012';
  static const String serviceTemporarilyUnavailable = 'SYSTEM_11013';
  static const String rateLimitExceeded = 'SYSTEM_11014';
  static const String resourceNotFound = 'SYSTEM_11015';
  static const String resourceConflict = 'SYSTEM_11016';
  static const String concurrencyError = 'SYSTEM_11017';
  static const String lockAcquisitionFailed = 'SYSTEM_11018';
  static const String dataCorruption = 'SYSTEM_11019';
  static const String backupFailed = 'SYSTEM_11020';

  // Validation Errors (12000-12999)
  static const String validationFailed = 'VALIDATION_12001';
  static const String requiredFieldMissing = 'VALIDATION_12002';
  static const String fieldTooShort = 'VALIDATION_12003';
  static const String fieldTooLong = 'VALIDATION_12004';
  static const String fieldInvalidFormat = 'VALIDATION_12005';
  static const String fieldInvalidValue = 'VALIDATION_12006';
  static const String fieldOutOfRange = 'VALIDATION_12007';
  static const String emailInvalid = 'VALIDATION_12008';
  static const String phoneInvalid = 'VALIDATION_12009';
  static const String passwordInvalid = 'VALIDATION_12010';
  static const String nameInvalid = 'VALIDATION_12011';
  static const String dateInvalid = 'VALIDATION_12012';
  static const String timeInvalid = 'VALIDATION_12013';
  static const String urlInvalid = 'VALIDATION_12014';
  static const String uuidInvalid = 'VALIDATION_12015';
  static const String jsonInvalid = 'VALIDATION_12016';
  static const String arrayTooShort = 'VALIDATION_12017';
  static const String arrayTooLong = 'VALIDATION_12018';
  static const String duplicateValue = 'VALIDATION_12019';
  static const String businessRuleViolation = 'VALIDATION_12020';

  // Get error message for code
  static String getMessage(String code) {
    switch (code) {
      // Authentication messages
      case invalidCredentials:
        return 'Invalid email or password';
      case userNotFound:
        return 'User not found';
      case emailAlreadyExists:
        return 'An account with this email already exists';
      case tokenExpired:
        return 'Session has expired. Please log in again';
      case accountSuspended:
        return 'Your account has been suspended';

      // Ride messages
      case noDriversAvailable:
        return 'No drivers available in your area';
      case rideNotFound:
        return 'Ride not found';
      case rideOutsideServiceArea:
        return 'This location is outside our service area';

      // Payment messages
      case paymentFailed:
        return 'Payment processing failed';
      case insufficientFunds:
        return 'Insufficient funds';
      case cardDeclined:
        return 'Your card was declined';

      // System messages
      case systemError:
        return 'An unexpected error occurred';
      case systemMaintenance:
        return 'System is currently under maintenance';
      case rateLimitExceeded:
        return 'Too many requests. Please try again later';

      default:
        return 'An error occurred';
    }
  }

  // Get HTTP status code for error code
  static int getHttpStatusCode(String code) {
    if (code.startsWith('AUTH_')) return 401;
    if (code.startsWith('USER_') && code.contains('NOT_FOUND')) return 404;
    if (code.startsWith('DRIVER_') && code.contains('NOT_FOUND')) return 404;
    if (code.startsWith('RIDE_') && code.contains('NOT_FOUND')) return 404;
    if (code.startsWith('PAYMENT_')) return 402;
    if (code.startsWith('VALIDATION_')) return 400;
    if (code.startsWith('SYSTEM_') && code.contains('RATE_LIMIT')) return 429;
    if (code.startsWith('SYSTEM_')) return 500;
    if (code.contains('NOT_FOUND')) return 404;
    if (code.contains('ALREADY_EXISTS')) return 409;
    if (code.contains('INVALID')) return 400;
    return 400; // Default to bad request
  }
}
