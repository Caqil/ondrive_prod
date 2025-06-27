// server/lib/src/utils/validators.dart
//
// Comprehensive validation utilities for ride-hailing platform
// Provides extensive validation for all data types with proper error handling

import 'dart:math' as math;
import 'package:ride_hailing_shared/shared.dart';
import 'package:serverpod/serverpod.dart' hide WebSocketMessage, Transaction;
import 'error_codes.dart';

/// Main validation class providing comprehensive data validation
class Validators {
  // =============================================================================
  // AUTHENTICATION VALIDATION
  // =============================================================================

  /// Validates user registration data
  static ValidationResult validateUserRegistration(RegisterRequest request) {
    final errors = <String>[];

    // Email validation
    if (!isValidEmail(request.email)) {
      errors.add(ErrorCodes.invalidEmail);
    }

    // Phone validation
    if (!isValidPhoneNumber(request.phone)) {
      errors.add(ErrorCodes.invalidPhone);
    }

    // Password validation
    final passwordResult = validatePassword(request.password);
    if (!passwordResult.isValid) {
      errors.addAll(passwordResult.errors);
    }

    // Password confirmation validation
    if (request.password != request.confirmPassword) {
      errors.add('Passwords do not match');
    }

    // Name validation
    if (!isValidName(request.firstName)) {
      errors.add(ErrorCodes.invalidFirstName);
    }
    if (!isValidName(request.lastName)) {
      errors.add(ErrorCodes.invalidLastName);
    }

    // Terms and privacy policy validation
    if (!request.agreeToTerms) {
      errors.add('Must agree to terms and conditions');
    }
    if (!request.agreeToPrivacyPolicy) {
      errors.add('Must agree to privacy policy');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates user profile data
  static ValidationResult validateUserProfile(UserProfile profile) {
    final errors = <String>[];

    // Emergency contact validation
    if (profile.emergencyContactPhone != null && 
        !isValidPhoneNumber(profile.emergencyContactPhone!)) {
      errors.add('Invalid emergency contact phone number');
    }

    // Date of birth validation
    if (profile.dateOfBirth != null && !isValidDateOfBirth(profile.dateOfBirth!)) {
      errors.add(ErrorCodes.invalidDateOfBirth);
    }

    // Postal code validation (basic)
    if (profile.postalCode != null && profile.postalCode!.trim().isEmpty) {
      errors.add('Invalid postal code');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates user login credentials
  static ValidationResult validateLoginRequest(LoginRequest request) {
    final errors = <String>[];

    // Identifier validation (email or phone)
    if (!isValidEmail(request.email) && !isValidPhoneNumber(request.email)) {
      errors.add(ErrorCodes.invalidCredentials);
    }

    // Password validation
    if (request.password.isEmpty || request.password.length < 6) {
      errors.add(ErrorCodes.invalidCredentials);
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates password strength
  static ValidationResult validatePassword(String password) {
    final errors = <String>[];

    if (password.length < 8) {
      errors.add(ErrorCodes.passwordTooShort);
    }
    if (password.length > 128) {
      errors.add(ErrorCodes.passwordTooLong);
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add(ErrorCodes.passwordMissingUppercase);
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add(ErrorCodes.passwordMissingLowercase);
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add(ErrorCodes.passwordMissingNumber);
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add(ErrorCodes.passwordMissingSpecialChar);
    }
    if (isCommonPassword(password)) {
      errors.add(ErrorCodes.passwordTooCommon);
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // RIDE VALIDATION
  // =============================================================================

  /// Validates ride request data
  static ValidationResult validateRideRequest(RideRequest request) {
    final errors = <String>[];

    // Location validation
    final pickupResult = validateLocation(request.pickupLocation);
    if (!pickupResult.isValid) {
      errors.addAll(pickupResult.errors);
    }

    final dropoffResult = validateLocation(request.dropoffLocation);
    if (!dropoffResult.isValid) {
      errors.addAll(dropoffResult.errors);
    }

    // Distance validation
    final distance = calculateDistance(
      request.pickupLocation.latitude,
      request.pickupLocation.longitude,
      request.dropoffLocation.latitude,
      request.dropoffLocation.longitude,
    );

    if (distance < 0.1) { // 100 meters minimum
      errors.add(ErrorCodes.locationTooClose);
    }
    if (distance > 500) { // 500 km maximum
      errors.add(ErrorCodes.rideDistanceTooLong);
    }

    // Waypoints validation
    if (request.waypoints != null && request.waypoints!.length > 5) {
      errors.add(ErrorCodes.rideWaypointLimit);
    }

    // Scheduled ride validation
    if (request.scheduledAt != null) {
      final now = DateTime.now();
      final scheduled = request.scheduledAt!;
      
      if (scheduled.isBefore(now.add(Duration(minutes: 15)))) {
        errors.add(ErrorCodes.rideScheduleTooSoon);
      }
      if (scheduled.isAfter(now.add(Duration(days: 30)))) {
        errors.add(ErrorCodes.rideScheduleTooFar);
      }
    }

    // Proposed fare validation (using correct property name)
    if (request.proposedFare != null && request.proposedFare! <= 0) {
      errors.add(ErrorCodes.invalidFareAmount);
    }

    // Special requests validation
    if (request.specialRequests != null && request.specialRequests!.length > 500) {
      errors.add('Special requests too long');
    }

    // Passengers count validation
    if (request.passengersCount != null && 
        (request.passengersCount! < 1 || request.passengersCount! > 8)) {
      errors.add('Invalid passengers count');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates location data
  static ValidationResult validateLocation(LocationPoint location) {
    final errors = <String>[];

    if (!isValidLatitude(location.latitude)) {
      errors.add(ErrorCodes.invalidLocation);
    }
    if (!isValidLongitude(location.longitude)) {
      errors.add(ErrorCodes.invalidLocation);
    }

    // Address validation (optional but recommended)
    if (location.address != null && location.address!.trim().isEmpty) {
      errors.add('Invalid address');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // DRIVER VALIDATION
  // =============================================================================

  /// Validates driver profile data
  static ValidationResult validateDriverProfile(DriverProfile profile) {
    final errors = <String>[];

    // License validation
    if (!isValidLicenseNumber(profile.licenseNumber)) {
      errors.add(ErrorCodes.driverLicenseInvalid);
    }

    if (profile.licenseExpiryDate.isBefore(DateTime.now().add(Duration(days: 30)))) {
      errors.add(ErrorCodes.driverLicenseExpired);
    }

    // Operating cities validation
    if (profile.operatingCities.isEmpty) {
      errors.add('At least one operating city required');
    }

    // Service types validation
    if (profile.serviceTypes.isEmpty) {
      errors.add('At least one service type required');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates vehicle data
  static ValidationResult validateVehicle(Vehicle vehicle) {
    final errors = <String>[];

    // License plate validation
    if (!isValidLicensePlate(vehicle.licensePlate)) {
      errors.add(ErrorCodes.licensePlateInvalid);
    }

    // VIN validation
    if (!isValidVIN(vehicle.vin)) {
      errors.add(ErrorCodes.vinInvalid);
    }

    // Year validation
    final currentYear = DateTime.now().year;
    if (vehicle.year < 2010 || vehicle.year > currentYear + 1) {
      errors.add(ErrorCodes.vehicleTooOld);
    }

    // Capacity validation (using correct property name)
    if (vehicle.seatingCapacity < 1 || vehicle.seatingCapacity > 8) {
      errors.add(ErrorCodes.vehicleCapacityExceeded);
    }

    // Color validation
    if (vehicle.color.trim().isEmpty) {
      errors.add(ErrorCodes.vehicleColorRequired);
    }

    // Make and model validation
    if (vehicle.make.trim().isEmpty || vehicle.model.trim().isEmpty) {
      errors.add('Vehicle make and model are required');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // PAYMENT VALIDATION
  // =============================================================================

  /// Validates transaction data (payment-related)
  static ValidationResult validateTransaction(Transaction transaction) {
    final errors = <String>[];

    // Amount validation
    if (transaction.amount <= 0) {
      errors.add(ErrorCodes.invalidPaymentAmount);
    }
    if (transaction.amount > 100000) { // $1000 maximum
      errors.add('Transaction amount too large');
    }

    // Currency validation
    if (!isValidCurrency(transaction.currency)) {
      errors.add(ErrorCodes.invalidCurrency);
    }

    // Transaction type validation
    if (transaction.type == null) {
      errors.add('Transaction type is required');
    }

    // Direction validation
    if (transaction.direction == null) {
      errors.add('Transaction direction is required');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates payment status
  static ValidationResult validatePaymentStatus(PaymentStatus paymentStatus) {
    final errors = <String>[];

    // Amount validation
    if (paymentStatus.amount <= 0) {
      errors.add(ErrorCodes.invalidPaymentAmount);
    }

    // Currency validation
    if (!isValidCurrency(paymentStatus.currency)) {
      errors.add(ErrorCodes.invalidCurrency);
    }

    // Payment method type validation
    if (paymentStatus.paymentMethodType == null) {
      errors.add('Payment method type is required');
    }

    // Retry count validation
    if (paymentStatus.currentRetries < 0 || paymentStatus.currentRetries > paymentStatus.maxRetries) {
      errors.add('Invalid retry count');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  /// Validates payment method
  static ValidationResult validatePaymentMethod(PaymentMethod method) {
    final errors = <String>[];

    switch (method.type) {
      case PaymentMethodType.card:
        // For card payments, we validate the last4 and expiration if available
        if (method.last4 != null && method.last4!.length != 4) {
          errors.add('Invalid card last 4 digits');
        }
        if (method.expMonth != null && method.expYear != null &&
            !isValidCardExpiry(method.expMonth!, method.expYear!)) {
          errors.add(ErrorCodes.invalidCardExpiry);
        }
        break;
      case PaymentMethodType.bankAccount:
        if (method.accountLast4 != null && method.accountLast4!.length < 4) {
          errors.add('Invalid account number');
        }
        if (method.routingNumber != null && method.routingNumber!.length < 9) {
          errors.add('Invalid routing number');
        }
        break;
      case PaymentMethodType.digitalWallet:
        if (method.walletEmail != null && !isValidEmail(method.walletEmail!)) {
          errors.add('Invalid wallet email');
        }
        break;
      default:
        break;
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // TRACKING VALIDATION
  // =============================================================================

  /// Validates location update data
  static ValidationResult validateLocationUpdate(LocationUpdate update) {
    final errors = <String>[];

    if (!isValidLatitude(update.latitude)) {
      errors.add(ErrorCodes.invalidLocation);
    }
    if (!isValidLongitude(update.longitude)) {
      errors.add(ErrorCodes.invalidLocation);
    }

    // Timestamp validation
    final now = DateTime.now();
    if (update.timestamp.isAfter(now.add(Duration(minutes: 5)))) {
      errors.add('Future timestamp not allowed');
    }
    if (update.timestamp.isBefore(now.subtract(Duration(hours: 24)))) {
      errors.add('Timestamp too old');
    }

    // Speed validation (optional)
    if (update.speed != null && (update.speed! < 0 || update.speed! > 200)) {
      errors.add('Invalid speed value');
    }

    // Accuracy validation (optional)
    if (update.accuracy != null && (update.accuracy! < 0 || update.accuracy! > 10000)) {
      errors.add('Invalid accuracy value');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // NEGOTIATION VALIDATION
  // =============================================================================

  /// Validates fare offer
  static ValidationResult validateFareOffer(FareOffer offer) {
    final errors = <String>[];

    // Amount validation
    if (offer.amount <= 0) {
      errors.add(ErrorCodes.invalidFareAmount);
    }
    if (offer.amount > 100000) { // $1000 maximum
      errors.add('Fare amount too large');
    }

    // Message validation (optional)
    if (offer.message != null && offer.message!.length > 200) {
      errors.add('Offer message too long');
    }

    // Expiry validation
    if (offer.expiresAt != null && offer.expiresAt!.isBefore(DateTime.now())) {
      errors.add('Offer already expired');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // NOTIFICATION VALIDATION
  // =============================================================================

  /// Validates notification data
  static ValidationResult validateNotification(Notification notification) {
    final errors = <String>[];

    if (notification.title.trim().isEmpty) {
      errors.add('Notification title required');
    }
    if (notification.title.length > 100) {
      errors.add('Notification title too long');
    }
    if (notification.body.trim().isEmpty) {
      errors.add('Notification body required');
    }
    if (notification.body.length > 500) {
      errors.add('Notification body too long');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }

  // =============================================================================
  // HELPER VALIDATION METHODS
  // =============================================================================

  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  /// Validates phone number format
  static bool isValidPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(cleaned);
  }

  /// Validates name format
  static bool isValidName(String name) {
    return name.trim().length >= 2 && 
           name.trim().length <= 50 && 
           RegExp(r"^[a-zA-Z\s\-'\.]+$").hasMatch(name.trim());
  }

  /// Validates date of birth
  static bool isValidDateOfBirth(DateTime dob) {
    final now = DateTime.now();
    final age = now.difference(dob).inDays / 365.25;
    return age >= 18 && age <= 120;
  }

  /// Validates latitude
  static bool isValidLatitude(double lat) {
    return lat >= -90.0 && lat <= 90.0;
  }

  /// Validates longitude
  static bool isValidLongitude(double lng) {
    return lng >= -180.0 && lng <= 180.0;
  }

  /// Validates license number
  static bool isValidLicenseNumber(String license) {
    return license.trim().length >= 5 && 
           license.trim().length <= 20 && 
           RegExp(r'^[a-zA-Z0-9\-]+$').hasMatch(license.trim());
  }

  /// Validates license plate
  static bool isValidLicensePlate(String plate) {
    return plate.trim().length >= 3 && 
           plate.trim().length <= 10 && 
           RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(plate.trim());
  }

  /// Validates VIN (Vehicle Identification Number)
  static bool isValidVIN(String vin) {
    return vin.length == 17 && RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(vin);
  }

  /// Validates currency code
  static bool isValidCurrency(String currency) {
    final validCurrencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY', 'NGN', 'KES', 'ZAR'];
    return validCurrencies.contains(currency.toUpperCase());
  }

  /// Validates credit card number using Luhn algorithm
  static bool isValidCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 13 || cleaned.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  /// Validates card expiry date
  static bool isValidCardExpiry(int month, int year) {
    if (month < 1 || month > 12) return false;
    
    final now = DateTime.now();
    final currentYear = now.year % 100; // Convert to 2-digit year
    final currentMonth = now.month;
    
    // Handle both 2-digit and 4-digit years
    final normalizedYear = year < 100 ? year : year % 100;
    
    if (normalizedYear < currentYear) return false;
    if (normalizedYear == currentYear && month < currentMonth) return false;
    
    return true;
  }

  /// Checks if password is commonly used
  static bool isCommonPassword(String password) {
    final commonPasswords = [
      'password', '123456', '123456789', 'qwerty', 'abc123',
      'password123', 'admin', 'letmein', 'welcome', 'monkey'
    ];
    return commonPasswords.contains(password.toLowerCase());
  }

  /// Calculates distance between two points using Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) * math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  /// Converts degrees to radians
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // =============================================================================
  // WEBSOCKET MESSAGE VALIDATION
  // =============================================================================

  /// Validates WebSocket message
  static ValidationResult validateWebSocketMessage(WebSocketMessage message) {
    final errors = <String>[];

    if (message.type.trim().isEmpty) {
      errors.add('Message type required');
    }

    if (message.userId != null && message.userId! <= 0) {
      errors.add('Invalid user ID');
    }

    // Validate message-specific data
    switch (message.type) {
      case 'location_update':
        final data = message.data as Map<String, dynamic>?;
        if (data != null) {
          final lat = data['latitude'] as double?;
          final lng = data['longitude'] as double?;
          if (lat == null || !isValidLatitude(lat)) {
            errors.add('Invalid latitude in location update');
          }
          if (lng == null || !isValidLongitude(lng)) {
            errors.add('Invalid longitude in location update');
          }
        }
        break;
      case 'fare_offer':
        final data = message.data as Map<String, dynamic>?;
        if (data != null) {
          final amount = data['amount'] as double?;
          if (amount == null || amount <= 0) {
            errors.add('Invalid fare amount');
          }
        }
        break;
      case 'chat_message':
        final data = message.data as Map<String, dynamic>?;
        if (data != null) {
          final msg = data['message'] as String?;
          if (msg == null || msg.trim().isEmpty) {
            errors.add('Chat message cannot be empty');
          }
          if (msg != null && msg.length > 1000) {
            errors.add('Chat message too long');
          }
        }
        break;
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

/// Validation result container
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  const ValidationResult({
    required this.isValid,
    this.errors = const [],
  });
  
  String get firstError => errors.isNotEmpty ? errors.first : '';
  
  @override
  String toString() {
    if (isValid) return 'Validation passed';
    return 'Validation failed: ${errors.join(', ')}';
  }
}