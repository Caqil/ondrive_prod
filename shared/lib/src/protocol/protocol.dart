// shared/lib/src/protocol/protocol.dart
//
// Main protocol file that exports all shared models and types
// This is the single entry point for all protocol definitions
//

// =============================================================================
// COMMON MODELS
// =============================================================================

// Core common types
import 'dart:math' as math;

export 'common/api_response.dart';
export 'common/error_response.dart';
export 'common/pagination.dart';
export 'common/file_upload.dart';
export 'common/websocket_message.dart';

// =============================================================================
// AUTHENTICATION MODELS
// =============================================================================

// User authentication and management
export 'auth/user.dart';
export 'auth/login_request.dart';
export 'auth/register_request.dart';
export 'auth/auth_response.dart';
export 'auth/jwt_token.dart';
export 'auth/verification_request.dart';

// =============================================================================
// DRIVER MODELS
// =============================================================================

// Driver profiles and management
export 'drivers/driver_profile.dart';
export 'drivers/vehicle.dart';
export 'drivers/driver_document.dart';
export 'drivers/earnings.dart';

// =============================================================================
// RIDE MODELS
// =============================================================================

// Core ride functionality
export 'rides/ride.dart';
export 'rides/ride_request.dart';
export 'rides/waypoint.dart';

// =============================================================================
// NEGOTIATION MODELS
// =============================================================================

// Fare negotiation system - Clean exports with no conflicts
export 'negotiations/fare_offer.dart'; // Complete FareOffer class
export 'negotiations/counter_offer.dart';
export 'negotiations/negotiation_history.dart'; // Complete NegotiationHistory class
export 'negotiations/negotiation_status.dart'; // Complete NegotiationStatus class
export 'negotiations/fare_negotiation.dart'; // FareNegotiation (no conflicts)

// =============================================================================
// PAYMENT MODELS
// =============================================================================

// Payment processing and management
export 'payments/payment.dart';
export 'payments/payment_method.dart';
export 'payments/payment_status.dart';
export 'payments/transaction.dart';
export 'payments/commission.dart';
export 'payments/fare_breakdown.dart';

// =============================================================================
// TRACKING MODELS
// =============================================================================

// Real-time tracking and location
export 'tracking/location_update.dart';
export 'tracking/trip_tracking.dart';
export 'tracking/eta_update.dart';
export 'tracking/route_info.dart';

// =============================================================================
// NOTIFICATION MODELS
// =============================================================================

// Notification and communication
export 'notifications/notification.dart';
export 'notifications/push_notification.dart';
export 'notifications/email_template.dart';
export 'notifications/notification_preference.dart';

// =============================================================================
// ADMIN MODELS
// =============================================================================

// Administrative and system management
export 'admin/admin_user.dart';
export 'admin/system_config.dart';
export 'admin/analytics_data.dart';
export 'admin/report.dart';

// =============================================================================
// EXCEPTION MODELS
// =============================================================================

// =============================================================================
// PROTOCOL VERSION AND METADATA
// =============================================================================

/// Current protocol version
const String protocolVersion = '1.0.0';

/// Protocol build information
const Map<String, dynamic> protocolInfo = {
  'version': protocolVersion,
  'name': 'RideHailing Protocol',
  'description': 'Comprehensive shared models for ride-hailing platform',
  'buildDate': '2024-01-01',
  'apiVersion': 'v1',
  'compatibility': {
    'serverpod': '^2.1.0',
    'flutter': '^3.0.0',
    'dart': '^3.0.0',
  },
  'features': [
    'Real-time ride tracking',
    'Fare negotiation system',
    'Multi-payment support',
    'Driver management',
    'Admin analytics',
    'Push notifications',
    'Email templates',
    'Audit logging',
    'Route optimization',
    'Safety monitoring',
  ],
};

// =============================================================================
// ENUMS CONSOLIDATED (for easy reference)
// =============================================================================

/// User types in the system
enum UserType {
  passenger,
  driver,
  admin,
}

/// Gender options
enum Gender {
  male,
  female,
  other,
  preferNotToSay,
}

/// Accessibility needs
enum AccessibilityNeed {
  wheelchairAccessible,
  hearingImpaired,
  visuallyImpaired,
  mobilityAssistance,
  serviceAnimal,
  other,
}

/// Vehicle types
enum VehicleType {
  economy,
  standard,
  premium,
  luxury,
  suv,
  van,
  motorcycle,
  bicycle,
  wheelchair,
  electric,
}

/// Ride types
enum RideType {
  economy,
  standard,
  premium,
  luxury,
  suv,
  van,
  pool,
  intercity,
  courier,
  wheelchair,
  pet,
  eco,
  electric,
}

/// Ride states
enum RideState {
  requested,
  negotiating,
  driverAssigned,
  driverEnRoute,
  arrived,
  inProgress,
  completed,
  cancelled,
  noDriversAvailable,
}

/// Payment method types
enum PaymentMethodType {
  card,
  bankAccount,
  digitalWallet,
  cash,
  corporate,
}

/// Payment states
enum PaymentState {
  pending,
  processing,
  authorizing,
  authorized,
  capturing,
  completed,
  failed,
  cancelled,
  refunded,
  partiallyRefunded,
  disputed,
}

/// Transaction types
enum TransactionType {
  ridePayment,
  refund,
  tip,
  bonus,
  commission,
  withdrawal,
  topUp,
  cancellationFee,
  toll,
  tax,
  fee,
  adjustment,
  chargeback,
  other,
}

/// Notification types
enum NotificationType {
  rideRequested,
  rideAccepted,
  rideStarted,
  rideCompleted,
  rideCancelled,
  driverArrived,
  fareNegotiation,
  paymentProcessed,
  paymentFailed,
  refundProcessed,
  documentExpiring,
  documentRejected,
  promoCode,
  systemMaintenance,
  securityAlert,
  accountUpdate,
  other,
}

/// Driver availability status
enum DriverAvailabilityStatus {
  available,
  unavailable,
  busy,
  onTrip,
  breakTime,
  maintenance,
}

/// Location sources
enum LocationSource {
  gps,
  network,
  passive,
  fused,
  manual,
}

/// Traffic conditions
enum TrafficCondition {
  light,
  moderate,
  heavy,
  severe,
  unknown,
}

// =============================================================================
// NEGOTIATION ENUMS (Re-exported for convenience)
// =============================================================================

/// Offer status
enum OfferStatus {
  active,
  countered,
  accepted,
  rejected,
  expired,
}

/// Negotiation action
enum NegotiationAction {
  accept,
  counter,
  reject,
  withdraw,
}

// =============================================================================
// UTILITY CLASSES AND HELPERS
// =============================================================================

/// Protocol utilities for common operations
class ProtocolUtils {
  /// Convert cents to dollars
  static double centsToDollars(double cents) => cents / 100;

  /// Convert dollars to cents
  static double dollarsToCents(double dollars) => dollars * 100;

  /// Format currency amount
  static String formatCurrency(double cents, {String currency = 'USD'}) {
    final dollars = centsToDollars(cents);
    return '\$${dollars.toStringAsFixed(2)} $currency';
  }

  /// Format duration in human readable format
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Format distance in human readable format
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      final km = meters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Format speed in km/h
  static String formatSpeed(double metersPerSecond) {
    final kmh = metersPerSecond * 3.6;
    return '${kmh.round()} km/h';
  }

  /// Generate unique ID
  static String generateId(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return '${prefix}_${timestamp}_$random';
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validate phone format (international)
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  /// Calculate distance between two points (Haversine formula)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) => degrees * (math.pi / 180);

  /// Get user-friendly enum name
  static String getEnumName(dynamic enumValue) {
    return enumValue.toString().split('.').last;
  }

  /// Parse enum from string
  static T? parseEnum<T>(List<T> values, String name) {
    try {
      return values.firstWhere(
          (value) => getEnumName(value).toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null;
    }
  }
}

/// Protocol constants used throughout the system
class ProtocolConstants {
  // API Configuration
  static const String apiVersion = 'v1';
  static const String baseApiPath = '/api/$apiVersion';

  // Pagination defaults
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Distance and time limits
  static const double maxRideDistanceKm = 500.0;
  static const int maxRideDurationHours = 12;
  static const double minRideDistanceKm = 0.1;

  // Fare limits
  static const double minFareCents = 100.0; // $1.00
  static const double maxFareCents = 100000.0; // $1000.00

  // Driver limits
  static const double maxDriverSearchRadiusKm = 25.0;
  static const int maxDriverResponseTimeSeconds = 300; // 5 minutes

  // Negotiation limits
  static const int maxNegotiationRounds = 5;
  static const int negotiationTimeoutMinutes = 15;

  // Location accuracy
  static const double minimumLocationAccuracyMeters = 100.0;
  static const double preferredLocationAccuracyMeters = 10.0;

  // File upload limits
  static const int maxFileUploadSizeMB = 10;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // WebSocket configuration
  static const int websocketHeartbeatIntervalSeconds = 30;
  static const int websocketTimeoutSeconds = 60;

  // Notification configuration
  static const int maxNotificationRetries = 3;
  static const int notificationRetryDelaySeconds = 5;

  // Cache configuration
  static const int defaultCacheTimeoutSeconds = 300; // 5 minutes
  static const int locationCacheTimeoutSeconds = 30;
  static const int driverStatusCacheTimeoutSeconds = 60;

  // Rate limiting
  static const int apiRateLimitPerMinute = 60;
  static const int authRateLimitPerMinute = 10;

  // Security
  static const int passwordMinLength = 8;
  static const int jwtExpirationHours = 24;
  static const int refreshTokenExpirationDays = 30;

  // Business rules
  static const double defaultCommissionPercentage = 12.5;
  static const int cancellationGracePeriodMinutes = 5;
  static const double surgePricingMaxMultiplier = 5.0;
}

/// Protocol validation helpers
class ProtocolValidation {
  /// Validate ride request
  static List<String> validateRideRequest(Map<String, dynamic> request) {
    final errors = <String>[];

    // Check required fields
    if (request['pickupLocation'] == null) {
      errors.add('Pickup location is required');
    }
    if (request['dropoffLocation'] == null) {
      errors.add('Dropoff location is required');
    }
    if (request['rideType'] == null) {
      errors.add('Ride type is required');
    }

    // Validate coordinates
    final pickup = request['pickupLocation'] as Map<String, dynamic>?;
    if (pickup != null) {
      if (!_isValidLatitude(pickup['latitude'])) {
        errors.add('Invalid pickup latitude');
      }
      if (!_isValidLongitude(pickup['longitude'])) {
        errors.add('Invalid pickup longitude');
      }
    }

    return errors;
  }

  /// Validate payment data
  static List<String> validatePayment(Map<String, dynamic> payment) {
    final errors = <String>[];

    final amount = payment['amount'] as double?;
    if (amount == null || amount < ProtocolConstants.minFareCents) {
      errors.add('Invalid payment amount');
    }

    if (payment['paymentMethodId'] == null) {
      errors.add('Payment method is required');
    }

    return errors;
  }

  /// Validate driver registration
  static List<String> validateDriverRegistration(Map<String, dynamic> driver) {
    final errors = <String>[];

    if (driver['licenseNumber'] == null ||
        (driver['licenseNumber'] as String).isEmpty) {
      errors.add('License number is required');
    }

    if (driver['licenseExpiryDate'] == null) {
      errors.add('License expiry date is required');
    }

    return errors;
  }

  static bool _isValidLatitude(dynamic lat) {
    if (lat is! double) return false;
    return lat >= -90.0 && lat <= 90.0;
  }

  static bool _isValidLongitude(dynamic lng) {
    if (lng is! double) return false;
    return lng >= -180.0 && lng <= 180.0;
  }
}
