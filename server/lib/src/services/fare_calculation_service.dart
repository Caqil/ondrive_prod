// server/lib/src/services/fare_calculation_service.dart

import 'dart:math' as math;
import 'package:serverpod/serverpod.dart';
import 'package:ride_hailing_shared/shared.dart';
import '../utils/helpers.dart';
import '../utils/error_codes.dart';
import 'redis_service.dart';

/// Service for calculating ride fares, surge pricing, and fare negotiations
class FareCalculationService {
  static const String _className = 'FareCalculationService';

  // Base fare configurations
  static const Map<RideType, double> _baseFares = {
    RideType.economy: 3.0,
    RideType.standard: 5.0,
    RideType.premium: 8.0,
    RideType.luxury: 15.0,
    RideType.shared: 2.5,
  };

  static const Map<RideType, double> _perKmRates = {
    RideType.economy: 1.0,
    RideType.standard: 1.5,
    RideType.premium: 2.2,
    RideType.luxury: 3.5,
    RideType.shared: 0.8,
  };

  static const Map<RideType, double> _perMinuteRates = {
    RideType.economy: 0.20,
    RideType.standard: 0.30,
    RideType.premium: 0.45,
    RideType.luxury: 0.60,
    RideType.shared: 0.15,
  };

  static const Map<RideType, double> _minimumFares = {
    RideType.economy: 4.0,
    RideType.standard: 6.0,
    RideType.premium: 10.0,
    RideType.luxury: 20.0,
    RideType.shared: 3.0,
  };

  // Surge and pricing configurations
  static const double _maxSurgeMultiplier = 5.0;
  static const double _serviceFeePercentage = 0.15; // 15%
  static const double _taxPercentage = 0.08; // 8%
  static const double _waypointFee = 2.0; // Per waypoint

  /// Calculate complete fare breakdown for a ride
  static Future<FareBreakdown> calculateFare(
    Session session, {
    required LocationPoint pickup,
    required LocationPoint dropoff,
    required RideType rideType,
    List<Waypoint>? waypoints,
    DateTime? scheduledAt,
    bool includeSurge = true,
    Map<String, dynamic>? rideContext,
  }) async {
    try {
      session.log('$_className: Calculating fare for ${rideType.toString()}',
          level: LogLevel.info);

      // Calculate distance and estimated duration
      final distance = LocationHelper.calculateDistance(
        pickup.latitude,
        pickup.longitude,
        dropoff.latitude,
        dropoff.longitude,
      );

      // Add waypoint distances
      double totalDistance = distance;
      if (waypoints != null && waypoints.isNotEmpty) {
        totalDistance += _calculateWaypointDistance(pickup, waypoints, dropoff);
      }

      final estimatedDuration =
          RideHelper.calculateETA(totalDistance, 30.0); // 30 km/h average

      // Get base rates
      final baseFare = _baseFares[rideType] ?? _baseFares[RideType.standard]!;
      final perKmRate =
          _perKmRates[rideType] ?? _perKmRates[RideType.standard]!;
      final perMinuteRate =
          _perMinuteRates[rideType] ?? _perMinuteRates[RideType.standard]!;

      // Calculate base components
      double distanceFare = totalDistance * perKmRate;
      double timeFare = estimatedDuration.inMinutes * perMinuteRate;
      double waypointFare = (waypoints?.length ?? 0) * _waypointFee;

      // Calculate surge pricing
      double surgeMultiplier = 1.0;
      double surgeFare = 0.0;

      if (includeSurge) {
        surgeMultiplier = await _calculateSurgeMultiplier(
          session,
          pickup,
          scheduledAt ?? DateTime.now(),
          rideType,
        );

        // Apply surge only to variable costs (distance + time)
        surgeFare = (distanceFare + timeFare) * (surgeMultiplier - 1);
        distanceFare *= surgeMultiplier;
        timeFare *= surgeMultiplier;
      }

      // Calculate subtotal
      final subtotal = baseFare + distanceFare + timeFare + waypointFare;

      // Calculate fees and taxes
      final serviceFee = math.max(subtotal * _serviceFeePercentage, 1.0);
      final tax = subtotal * _taxPercentage;

      // Calculate total
      final totalBeforeMinimum = subtotal + serviceFee + tax;
      final minimumFare =
          _minimumFares[rideType] ?? _minimumFares[RideType.standard]!;
      final totalFare = math.max(totalBeforeMinimum, minimumFare);

      // Apply minimum fare adjustment
      final minimumAdjustment =
          totalFare > totalBeforeMinimum ? totalFare - totalBeforeMinimum : 0.0;

      return FareBreakdown(
        baseFare: baseFare,
        distanceFare: distanceFare,
        timeFare: timeFare,
        surgeFare: surgeFare,
        waypointFare: waypointFare,
        serviceFee: serviceFee + minimumAdjustment,
        tax: tax,
        tips: 0.0,
        discount: 0.0,
        totalFare: totalFare,
        currency: 'USD',
        surgeMultiplier: surgeMultiplier,
        breakdown: {
          'distance_km': totalDistance,
          'duration_minutes': estimatedDuration.inMinutes,
          'waypoint_count': waypoints?.length ?? 0,
          'ride_type': rideType.toString(),
          'minimum_fare_applied': minimumAdjustment > 0,
          'calculation_time': DateTime.now().toIso8601String(),
        },
      );
    } catch (e, stackTrace) {
      session.log('$_className: Fare calculation failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      throw Exception(ErrorCodes.fareCalculationFailed);
    }
  }

  /// Calculate surge multiplier based on supply/demand
  static Future<double> _calculateSurgeMultiplier(
    Session session,
    LocationPoint location,
    DateTime requestTime,
    RideType rideType,
  ) async {
    try {
      // Get current supply and demand metrics
      final supplyDemandData = await _getSupplyDemandMetrics(session, location);

      // Time-based multiplier
      double timeMultiplier = _getTimeBasedMultiplier(requestTime);

      // Weather-based multiplier
      double weatherMultiplier = await _getWeatherMultiplier(session, location);

      // Supply/demand multiplier
      double supplyDemandMultiplier =
          _calculateSupplyDemandMultiplier(supplyDemandData);

      // Event-based multiplier
      double eventMultiplier =
          await _getEventMultiplier(session, location, requestTime);

      // Combine all multipliers
      double totalMultiplier = timeMultiplier *
          weatherMultiplier *
          supplyDemandMultiplier *
          eventMultiplier;

      // Apply ride type modifier
      totalMultiplier *= _getRideTypeMultiplier(rideType);

      // Cap at maximum surge
      return math.min(totalMultiplier, _maxSurgeMultiplier);
    } catch (e) {
      session.log('$_className: Error calculating surge: $e',
          level: LogLevel.error);
      return 1.0; // Default to no surge
    }
  }

  /// Calculate fare range for negotiation
  static Future<Map<String, double>> calculateNegotiationRange(
    Session session, {
    required FareBreakdown baseFare,
    required int availableDrivers,
    required double averageWaitTime,
    double negotiationFactor = 0.3,
  }) async {
    try {
      // Base negotiation range (±30% by default)
      final baseAmount = baseFare.totalFare;
      final rangeAmount = baseAmount * negotiationFactor;

      // Adjust based on supply
      double supplyAdjustment = 1.0;
      if (availableDrivers < 3) {
        supplyAdjustment = 1.2; // Higher prices when few drivers
      } else if (availableDrivers > 10) {
        supplyAdjustment = 0.9; // Lower prices when many drivers
      }

      // Adjust based on wait time
      double waitTimeAdjustment = 1.0;
      if (averageWaitTime > 10) {
        waitTimeAdjustment = 1.15; // Higher prices for long waits
      } else if (averageWaitTime < 3) {
        waitTimeAdjustment = 0.95; // Lower prices for quick pickup
      }

      final adjustedBase = baseAmount * supplyAdjustment * waitTimeAdjustment;
      final adjustedRange = rangeAmount * supplyAdjustment;

      return {
        'minimum': math.max(adjustedBase - adjustedRange, baseAmount * 0.5),
        'suggested': adjustedBase,
        'maximum': adjustedBase + adjustedRange,
        'originalFare': baseAmount,
        'supplyAdjustment': supplyAdjustment,
        'waitTimeAdjustment': waitTimeAdjustment,
      };
    } catch (e) {
      session.log('$_className: Error calculating negotiation range: $e',
          level: LogLevel.error);
      return {
        'minimum': baseFare.totalFare * 0.7,
        'suggested': baseFare.totalFare,
        'maximum': baseFare.totalFare * 1.3,
        'originalFare': baseFare.totalFare,
      };
    }
  }

  /// Calculate commission for driver earnings
  static Future<Commission> calculateCommission(
    Session session, {
    required double totalFare,
    required RideType rideType,
    required int driverId,
    Map<String, dynamic>? driverMetrics,
  }) async {
    try {
      // Base commission rates by ride type
      const baseCommissionRates = {
        RideType.economy: 0.20, // 20%
        RideType.standard: 0.22, // 22%
        RideType.premium: 0.25, // 25%
        RideType.luxury: 0.28, // 28%
        RideType.shared: 0.18, // 18%
      };

      double commissionRate = baseCommissionRates[rideType] ?? 0.22;

      // Apply driver performance adjustments
      if (driverMetrics != null) {
        final rating = driverMetrics['rating'] as double? ?? 0.0;
        final totalRides = driverMetrics['totalRides'] as int? ?? 0;
        final acceptanceRate =
            driverMetrics['acceptanceRate'] as double? ?? 0.0;

        // Bonus for high-rated drivers
        if (rating >= 4.8) {
          commissionRate *= 0.95; // 5% reduction
        } else if (rating >= 4.5) {
          commissionRate *= 0.98; // 2% reduction
        }

        // Bonus for experienced drivers
        if (totalRides >= 1000) {
          commissionRate *= 0.97; // 3% reduction
        } else if (totalRides >= 500) {
          commissionRate *= 0.99; // 1% reduction
        }

        // Penalty for low acceptance rate
        if (acceptanceRate < 0.8) {
          commissionRate *= 1.05; // 5% increase
        }
      }

      final commissionAmount = totalFare * commissionRate;
      final driverEarnings = totalFare - commissionAmount;

      return Commission(
        id: null,
        rideId: '', // Will be set by caller
        driverId: driverId,
        totalFare: totalFare,
        commissionRate: commissionRate,
        commissionAmount: commissionAmount,
        driverEarnings: driverEarnings,
        platformFee:
            commissionAmount * 0.1, // 10% of commission as platform fee
        paymentProcessingFee: totalFare * 0.029, // 2.9% payment processing
        createdAt: DateTime.now(),
        status: CommissionStatus.pending,
      );
    } catch (e) {
      session.log('$_className: Error calculating commission: $e',
          level: LogLevel.error);
      rethrow;
    }
  }

  /// Calculate discount application
  static FareBreakdown applyDiscount(
    FareBreakdown originalFare, {
    required String discountCode,
    required DiscountType discountType,
    required double discountValue,
    double? maxDiscount,
  }) {
    double discountAmount = 0.0;

    switch (discountType) {
      case DiscountType.percentage:
        discountAmount = originalFare.totalFare * (discountValue / 100);
        break;
      case DiscountType.fixed:
        discountAmount = discountValue;
        break;
      case DiscountType.firstRideFree:
        discountAmount = originalFare.totalFare;
        break;
    }

    // Apply maximum discount limit
    if (maxDiscount != null) {
      discountAmount = math.min(discountAmount, maxDiscount);
    }

    // Ensure discount doesn't exceed fare
    discountAmount = math.min(discountAmount, originalFare.totalFare);

    final newTotal = math.max(0.0, originalFare.totalFare - discountAmount);

    return FareBreakdown(
      baseFare: originalFare.baseFare,
      distanceFare: originalFare.distanceFare,
      timeFare: originalFare.timeFare,
      surgeFare: originalFare.surgeFare,
      waypointFare: originalFare.waypointFare,
      serviceFee: originalFare.serviceFee,
      tax: originalFare.tax,
      tips: originalFare.tips,
      discount: discountAmount,
      totalFare: newTotal,
      currency: originalFare.currency,
      surgeMultiplier: originalFare.surgeMultiplier,
      breakdown: {
        ...originalFare.breakdown ?? {},
        'discount_code': discountCode,
        'discount_type': discountType.toString(),
        'original_total': originalFare.totalFare,
      },
    );
  }

  /// Calculate estimated fare for multiple ride types
  static Future<Map<RideType, FareBreakdown>> calculateMultiTypeFares(
    Session session, {
    required LocationPoint pickup,
    required LocationPoint dropoff,
    List<Waypoint>? waypoints,
    DateTime? scheduledAt,
  }) async {
    final fares = <RideType, FareBreakdown>{};

    for (final rideType in RideType.values) {
      try {
        final fare = await calculateFare(
          session,
          pickup: pickup,
          dropoff: dropoff,
          rideType: rideType,
          waypoints: waypoints,
          scheduledAt: scheduledAt,
        );
        fares[rideType] = fare;
      } catch (e) {
        session.log('$_className: Failed to calculate fare for $rideType: $e',
            level: LogLevel.warning);
      }
    }

    return fares;
  }

  // Private helper methods

  static double _calculateWaypointDistance(
    LocationPoint pickup,
    List<Waypoint> waypoints,
    LocationPoint dropoff,
  ) {
    double totalDistance = 0.0;
    LocationPoint currentPoint = pickup;

    for (final waypoint in waypoints) {
      totalDistance += LocationHelper.calculateDistance(
        currentPoint.latitude,
        currentPoint.longitude,
        waypoint.latitude,
        waypoint.longitude,
      );
      currentPoint = LocationPoint(
        latitude: waypoint.latitude,
        longitude: waypoint.longitude,
      );
    }

    // Add final segment to dropoff
    totalDistance += LocationHelper.calculateDistance(
      currentPoint.latitude,
      currentPoint.longitude,
      dropoff.latitude,
      dropoff.longitude,
    );

    return totalDistance;
  }

  static Future<Map<String, dynamic>> _getSupplyDemandMetrics(
    Session session,
    LocationPoint location,
  ) async {
    try {
      // Create a grid key for the location (simplified)
      final gridKey =
          'supply_demand:${location.latitude.toStringAsFixed(2)}_${location.longitude.toStringAsFixed(2)}';

      final cached = await RedisService.get(session, gridKey);
      if (cached != null) {
        return {'drivers': 5, 'requests': 3}; // Simplified
      }

      // Default metrics if no data available
      return {'drivers': 5, 'requests': 3};
    } catch (e) {
      return {'drivers': 5, 'requests': 3};
    }
  }

  static double _getTimeBasedMultiplier(DateTime requestTime) {
    final hour = requestTime.hour;
    final dayOfWeek = requestTime.weekday;

    // Rush hour multipliers
    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      return dayOfWeek <= 5 ? 1.5 : 1.2; // Higher on weekdays
    }

    // Late night multipliers
    if (hour >= 22 || hour <= 5) {
      return dayOfWeek >= 6 ? 1.8 : 1.4; // Higher on weekends
    }

    // Weekend night multipliers
    if (dayOfWeek >= 6 && hour >= 20) {
      return 1.6;
    }

    return 1.0;
  }

  static Future<double> _getWeatherMultiplier(
      Session session, LocationPoint location) async {
    try {
      // Simplified weather impact - in production, integrate with weather API
      final random = math.Random();
      final weatherFactor = 0.8 + (random.nextDouble() * 0.4); // 0.8 to 1.2
      return weatherFactor;
    } catch (e) {
      return 1.0;
    }
  }

  static double _calculateSupplyDemandMultiplier(Map<String, dynamic> data) {
    final drivers = data['drivers'] as int? ?? 5;
    final requests = data['requests'] as int? ?? 3;

    if (drivers == 0) return _maxSurgeMultiplier;

    final ratio = requests / drivers;

    if (ratio <= 0.5) return 0.9; // Oversupply
    if (ratio <= 1.0) return 1.0; // Balanced
    if (ratio <= 2.0) return 1.3; // High demand
    if (ratio <= 3.0) return 1.8; // Very high demand

    return math.min(2.5, 1.0 + ratio); // Extreme demand
  }

  static Future<double> _getEventMultiplier(
    Session session,
    LocationPoint location,
    DateTime requestTime,
  ) async {
    try {
      // Simplified event detection
      // In production, integrate with events API or maintain event database
      return 1.0;
    } catch (e) {
      return 1.0;
    }
  }

  static double _getRideTypeMultiplier(RideType rideType) {
    // Additional multiplier based on ride type demand
    switch (rideType) {
      case RideType.luxury:
        return 1.1; // Luxury rides have higher surge sensitivity
      case RideType.shared:
        return 0.9; // Shared rides have lower surge sensitivity
      default:
        return 1.0;
    }
  }
}

// Supporting enums
enum DiscountType {
  percentage,
  fixed,
  firstRideFree,
}
