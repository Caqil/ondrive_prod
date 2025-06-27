// shared/lib/src/protocol/protocol.dart
//
// Main protocol file that exports all shared models and types
//

// =============================================================================
// COMMON MODELS
// =============================================================================
export 'common/api_response.dart';
export 'common/error_response.dart';
export 'common/pagination.dart';
export 'common/file_upload.dart';
export 'common/websocket_message.dart';

// =============================================================================
// AUTHENTICATION MODELS
// =============================================================================
export 'auth/user.dart';
export 'auth/login_request.dart';
export 'auth/register_request.dart';
export 'auth/auth_response.dart';
export 'auth/jwt_token.dart';
export 'auth/verification_request.dart';

// =============================================================================
// DRIVER MODELS
// =============================================================================
export 'drivers/driver_profile.dart';
export 'drivers/vehicle.dart';
export 'drivers/driver_document.dart';
export 'drivers/earnings.dart';

// =============================================================================
// RIDE MODELS - IMPORTANT: Order matters for dependencies
// =============================================================================
export 'rides/ride_type.dart'; // Export first - contains enums
export 'rides/ride.dart'; // Uses RideType from above
export 'rides/ride_request.dart';
export 'rides/waypoint.dart';

// =============================================================================
// NEGOTIATION MODELS
// =============================================================================
export 'negotiations/fare_offer.dart';
export 'negotiations/counter_offer.dart';
export 'negotiations/negotiation_history.dart';
export 'negotiations/negotiation_status.dart';
export 'negotiations/fare_negotiation.dart';

// =============================================================================
// PAYMENT MODELS
// =============================================================================
export 'payments/payment.dart';
export 'payments/payment_method.dart';
export 'payments/payment_status.dart';
export 'payments/transaction.dart';
export 'payments/commission.dart';
export 'payments/fare_breakdown.dart';

// =============================================================================
// TRACKING MODELS
// =============================================================================
export 'tracking/location_update.dart';
export 'tracking/trip_tracking.dart';
export 'tracking/eta_update.dart';
export 'tracking/route_info.dart';

// =============================================================================
// NOTIFICATION MODELS
// =============================================================================
export 'notifications/notification.dart';
export 'notifications/push_notification.dart';
export 'notifications/email_template.dart';
export 'notifications/notification_preference.dart';

// =============================================================================
// ADMIN MODELS
// =============================================================================
export 'admin/admin_user.dart';
export 'admin/system_config.dart';
export 'admin/analytics_data.dart';
export 'admin/report.dart';

// =============================================================================
// PROTOCOL METADATA
// =============================================================================
const String protocolVersion = '1.0.0+1';
const Map<String, dynamic> protocolInfo = {
  'version': protocolVersion,
  'name': 'RideHailing Protocol',
  'description': 'Comprehensive shared models for ride-hailing platform',
  'buildDate': '2024-01-01',
  'apiVersion': 'v1',
  'serverpodVersion': '^2.1.0',
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
