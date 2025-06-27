import 'dart:math' as math;
import 'package:serverpod/serverpod.dart';
import 'package:ride_hailing_shared/shared.dart';

class LocationHelper {
  // Calculate distance between two points using Haversine formula
  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Calculate bearing between two points
  static double calculateBearing(
      double lat1, double lon1, double lat2, double lon2) {
    double dLon = _toRadians(lon2 - lon1);
    double lat1Rad = _toRadians(lat1);
    double lat2Rad = _toRadians(lat2);

    double y = math.sin(dLon) * math.cos(lat2Rad);
    double x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(dLon);

    double bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  // Check if point is within radius
  static bool isWithinRadius(double centerLat, double centerLon,
      double pointLat, double pointLon, double radiusKm) {
    double distance =
        calculateDistance(centerLat, centerLon, pointLat, pointLon);
    return distance <= radiusKm;
  }

  // Check if point is within polygon
  static bool isPointInPolygon(
      double lat, double lon, List<LocationPoint> polygon) {
    if (polygon.length < 3) return false;

    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      if (((polygon[i].latitude > lat) != (polygon[j].latitude > lat)) &&
          (lon <
              (polygon[j].longitude - polygon[i].longitude) *
                      (lat - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
      j = i;
    }

    return inside;
  }

  // Generate bounding box for location search
  static Map<String, double> getBoundingBox(
      double centerLat, double centerLon, double radiusKm) {
    const double earthRadius = 6371; // km
    double latRange = radiusKm / earthRadius * (180 / math.pi);
    double lonRange = radiusKm /
        earthRadius *
        (180 / math.pi) /
        math.cos(centerLat * math.pi / 180);

    return {
      'minLat': centerLat - latRange,
      'maxLat': centerLat + latRange,
      'minLon': centerLon - lonRange,
      'maxLon': centerLon + lonRange,
    };
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180);
  static double _toDegrees(double radians) => radians * (180 / math.pi);
}

class TimeHelper {
  // Format duration in human readable format
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // Format duration in short format
  static String formatDurationShort(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  // Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Check if time is within business hours
  static bool isWithinBusinessHours(
    DateTime dateTime,
    int startHour,
    int endHour, {
    List<int>? workDays, // 1=Monday, 7=Sunday
  }) {
    workDays ??= [1, 2, 3, 4, 5]; // Default to weekdays

    if (!workDays.contains(dateTime.weekday)) {
      return false;
    }

    final hour = dateTime.hour;
    if (startHour <= endHour) {
      return hour >= startHour && hour < endHour;
    } else {
      // Overnight hours (e.g., 22:00 to 06:00)
      return hour >= startHour || hour < endHour;
    }
  }

  // Get next business day
  static DateTime getNextBusinessDay(DateTime date, [List<int>? workDays]) {
    workDays ??= [1, 2, 3, 4, 5]; // Default to weekdays

    DateTime nextDay = date.add(Duration(days: 1));
    while (!workDays.contains(nextDay.weekday)) {
      nextDay = nextDay.add(Duration(days: 1));
    }
    return nextDay;
  }

  // Round time to nearest interval
  static DateTime roundToNearestInterval(DateTime dateTime, Duration interval) {
    final intervalMs = interval.inMilliseconds;
    final rounded =
        (dateTime.millisecondsSinceEpoch / intervalMs).round() * intervalMs;
    return DateTime.fromMillisecondsSinceEpoch(rounded);
  }
}

class CurrencyHelper {
  // Format currency amount
  static String formatCurrency(double amount, {String currency = 'USD'}) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.round()}';
      case 'INR':
        return '₹${amount.toStringAsFixed(2)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  // Convert cents to currency
  static double centsToAmount(int cents) {
    return cents / 100.0;
  }

  // Convert currency to cents
  static int amountToCents(double amount) {
    return (amount * 100).round();
  }

  // Format large numbers with K/M suffixes
  static String formatLargeNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  // Calculate percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }

  // Calculate tip amount
  static double calculateTip(double amount, double percentage) {
    return amount * (percentage / 100);
  }

  // Calculate commission
  static double calculateCommission(double amount, double rate) {
    return amount * (rate / 100);
  }
}

class StringHelper {
  // Capitalize first letter of each word
  static String toTitleCase(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // Generate initials from name
  static String getInitials(String name, {int maxLength = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words.take(maxLength).map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() : '';
    }).join();
    return initials;
  }

  // Generate slug from text
  static String generateSlug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  // Truncate text with ellipsis
  static String truncate(String text, int maxLength,
      {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  // Clean phone number
  static String cleanPhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  // Format phone number
  static String formatPhoneNumber(String phone) {
    final cleaned = cleanPhoneNumber(phone);
    if (cleaned.startsWith('+1') && cleaned.length == 12) {
      // US format: +1 (XXX) XXX-XXXX
      return '+1 (${cleaned.substring(2, 5)}) ${cleaned.substring(5, 8)}-${cleaned.substring(8)}';
    }
    return cleaned;
  }

  // Generate random string
  static String generateRandomString(int length, {bool includeNumbers = true}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    final allChars = includeNumbers ? chars + numbers : chars;

    final random = math.Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => allChars.codeUnitAt(random.nextInt(allChars.length))));
  }

  // Extract numbers from string
  static String extractNumbers(String text) {
    return text.replaceAll(RegExp(r'[^\d]'), '');
  }

  // Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }

  // Convert string to boolean
  static bool? stringToBool(String? value) {
    if (value == null) return null;
    final lower = value.toLowerCase();
    if (lower == 'true' || lower == '1' || lower == 'yes' || lower == 'on') {
      return true;
    } else if (lower == 'false' ||
        lower == '0' ||
        lower == 'no' ||
        lower == 'off') {
      return false;
    }
    return null;
  }
}

class RideHelper {
  // Calculate ETA based on distance and speed
  static Duration calculateETA(double distanceKm, double averageSpeedKmh) {
    if (averageSpeedKmh <= 0) return Duration.zero;
    final hours = distanceKm / averageSpeedKmh;
    return Duration(milliseconds: (hours * 3600 * 1000).round());
  }

  // Calculate fare based on distance and time
  static double calculateBaseFare(
    double distanceKm,
    Duration duration,
    RideType rideType, {
    double baseFare = 5.0,
    double perKmRate = 1.5,
    double perMinuteRate = 0.3,
  }) {
    double fare = baseFare;
    fare += distanceKm * perKmRate;
    fare += duration.inMinutes * perMinuteRate;

    // Apply ride type multiplier
    switch (rideType) {
      case RideType.economy:
        fare *= 0.8;
        break;
      case RideType.premium:
        fare *= 1.5;
        break;
      case RideType.luxury:
        fare *= 2.0;
        break;
      default:
        break;
    }

    return math.max(fare, baseFare); // Ensure minimum fare
  }

  // Check if ride is within service area
  static bool isRideInServiceArea(LocationPoint pickup, LocationPoint dropoff,
      List<LocationPoint> serviceAreaBoundary) {
    return LocationHelper.isPointInPolygon(
            pickup.latitude, pickup.longitude, serviceAreaBoundary) &&
        LocationHelper.isPointInPolygon(
            dropoff.latitude, dropoff.longitude, serviceAreaBoundary);
  }

  // Calculate ride efficiency score
  static double calculateRideEfficiency(
      double actualDistance,
      double optimalDistance,
      Duration actualDuration,
      Duration optimalDuration) {
    final distanceEfficiency = optimalDistance / actualDistance;
    final timeEfficiency = optimalDuration.inSeconds / actualDuration.inSeconds;
    return ((distanceEfficiency + timeEfficiency) / 2) * 100;
  }

  // Generate ride ID
  static String generateRideId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = math.Random().nextInt(10000);
    return 'RIDE_${timestamp}_${random.toString().padLeft(4, '0')}';
  }

  // Check if ride can be pooled
  static bool canPoolRides(
    LocationPoint pickup1,
    LocationPoint dropoff1,
    LocationPoint pickup2,
    LocationPoint dropoff2, {
    double maxDetourKm = 2.0,
  }) {
    // Calculate direct distances
    final ride1Distance = LocationHelper.calculateDistance(pickup1.latitude,
        pickup1.longitude, dropoff1.latitude, dropoff1.longitude);

    final ride2Distance = LocationHelper.calculateDistance(pickup2.latitude,
        pickup2.longitude, dropoff2.latitude, dropoff2.longitude);

    // Calculate pooled route distance (simplified)
    final pickupToPickupDistance = LocationHelper.calculateDistance(
        pickup1.latitude,
        pickup1.longitude,
        pickup2.latitude,
        pickup2.longitude);

    final dropoffToDropoffDistance = LocationHelper.calculateDistance(
        dropoff1.latitude,
        dropoff1.longitude,
        dropoff2.latitude,
        dropoff2.longitude);

    // Check if detour is acceptable
    final totalDetour = pickupToPickupDistance + dropoffToDropoffDistance;
    final averageRideDistance = (ride1Distance + ride2Distance) / 2;

    return totalDetour <= maxDetourKm &&
        totalDetour <= averageRideDistance * 0.3;
  }
}

class UserHelper {
  // Check if user is adult
  static bool isAdult(DateTime dateOfBirth, {int adultAge = 18}) {
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      return age - 1 >= adultAge;
    }
    return age >= adultAge;
  }

  // Calculate user age
  static int calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Generate user display name
  static String generateDisplayName(User user) {
    if (user.firstName.isNotEmpty && user.lastName.isNotEmpty) {
      return '${user.firstName} ${user.lastName[0]}.';
    } else if (user.firstName.isNotEmpty) {
      return user.firstName;
    } else {
      return 'User';
    }
  }

  // Generate username from email
  static String generateUsernameFromEmail(String email) {
    final username = email.split('@')[0];
    return username.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  // Check if user can drive (basic validation)
  static bool canUserDrive(User user, {int minAge = 21, int maxAge = 70}) {
    if (user.profile?.dateOfBirth == null) return false;

    final age = calculateAge(user.profile!.dateOfBirth!);
    return age >= minAge && age <= maxAge;
  }

  // Get user's preferred language
  static String getUserLanguage(User user) {
    return user.settings?.preferredLanguage ?? 'en';
  }

  // Get user's preferred currency
  static String getUserCurrency(User user) {
    return user.settings?.preferredCurrency ?? 'USD';
  }

  // Check if user has completed profile
  static bool hasCompleteProfile(User user) {
    return user.firstName.isNotEmpty &&
        user.lastName.isNotEmpty &&
        user.isVerified &&
        user.profile != null;
  }
}
