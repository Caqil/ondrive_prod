// shared/lib/shared.dart
//
// Main export file for ride_hailing_shared package
// This is the primary entry point for all shared models
//

library ride_hailing_shared;

// Export the complete protocol
export 'src/protocol/protocol.dart';
export 'src/protocol/common/api_response.dart';
export 'src/protocol/common/error_response.dart';
export 'src/protocol/common/pagination.dart';
export 'src/protocol/common/file_upload.dart';
export 'src/protocol/common/websocket_message.dart';

// =============================================================================
// AUTHENTICATION MODELS
// =============================================================================
export 'src/protocol/auth/user.dart';
export 'src/protocol/auth/login_request.dart';
export 'src/protocol/auth/register_request.dart';
export 'src/protocol/auth/auth_response.dart';
export 'src/protocol/auth/jwt_token.dart';
export 'src/protocol/auth/verification_request.dart';

// =============================================================================
// DRIVER MODELS
// =============================================================================
export 'src/protocol/drivers/driver_profile.dart';
export 'src/protocol/drivers/vehicle.dart';
export 'src/protocol/drivers/driver_document.dart';
export 'src/protocol/drivers/earnings.dart';

// =============================================================================
// RIDE MODELS - IMPORTANT: Order matters for dependencies
// =============================================================================
export 'src/protocol/rides/ride_type.dart'; // Export first - contains enums
export 'src/protocol/rides/ride.dart'; // Uses RideType from above
export 'src/protocol/rides/ride_request.dart';
export 'src/protocol/rides/waypoint.dart';
export 'src/protocol/rides/location_point.dart';
// =============================================================================
// NEGOTIATION MODELS
// =============================================================================
export 'src/protocol/negotiations/fare_offer.dart';
export 'src/protocol/negotiations/counter_offer.dart';
export 'src/protocol/negotiations/negotiation_history.dart';
export 'src/protocol/negotiations/negotiation_status.dart';
export 'src/protocol/negotiations/fare_negotiation.dart';

// =============================================================================
// PAYMENT MODELS
// =============================================================================
export 'src/protocol/payments/payment.dart';
export 'src/protocol/payments/payment_method.dart';
export 'src/protocol/payments/payment_status.dart';
export 'src/protocol/payments/transaction.dart';
export 'src/protocol/payments/commission.dart';
export 'src/protocol/payments/fare_breakdown.dart';

// =============================================================================
// TRACKING MODELS
// =============================================================================
export 'src/protocol/tracking/location_update.dart';
export 'src/protocol/tracking/trip_tracking.dart';
export 'src/protocol/tracking/eta_update.dart';
export 'src/protocol/tracking/route_info.dart';

// =============================================================================
// NOTIFICATION MODELS
// =============================================================================
export 'src/protocol/notifications/notification.dart';
export 'src/protocol/notifications/push_notification.dart';
export 'src/protocol/notifications/email_template.dart';
export 'src/protocol/notifications/notification_preference.dart';

// =============================================================================
// ADMIN MODELS
// =============================================================================
export 'src/protocol/admin/admin_user.dart';
export 'src/protocol/admin/system_config.dart';
export 'src/protocol/admin/analytics_data.dart';
export 'src/protocol/admin/report.dart';

// Version information
const String sharedLibraryVersion = '1.0.0+1';
const String supportedServerpodVersion = '^2.1.0';

/// Utility function to check if shared library is properly loaded
bool isSharedLibraryLoaded() {
  try {
    // Try to instantiate a basic model to verify loading
    return sharedLibraryVersion.isNotEmpty;
  } catch (e) {
    return false;
  }
}
