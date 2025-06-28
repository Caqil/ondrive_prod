// server/lib/src/services/location_service.dart

import 'dart:convert';
import 'dart:math' as math;
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ride_hailing_shared/shared.dart';
import '../utils/helpers.dart';
import '../utils/error_codes.dart';
import 'redis_service.dart';

/// Service for location-based operations including geocoding, routing, and tracking
class LocationService {
  static const String _className = 'LocationService';

  // Google Maps configuration
  static String? _googleMapsApiKey;
  static String? _mapboxAccessToken;

  // Caching configuration
  static const int _geocodeCacheDuration = 86400; // 24 hours
  static const int _routeCacheDuration = 1800; // 30 minutes
  static const int _locationUpdateTtl = 300; // 5 minutes

  // Service area configuration
  static const double _maxServiceRadius = 50.0; // 50km radius
  static final List<LocationPoint> _serviceAreaBounds = [
    LocationPoint(latitude: 40.7128, longitude: -74.0060), // NYC example
    LocationPoint(latitude: 40.7589, longitude: -73.9851),
    LocationPoint(latitude: 40.7505, longitude: -73.9934),
    LocationPoint(latitude: 40.7061, longitude: -74.0087),
  ];

  /// Initialize location service with API keys
  static void initialize({
    String? googleMapsApiKey,
    String? mapboxAccessToken,
  }) {
    _googleMapsApiKey = googleMapsApiKey;
    _mapboxAccessToken = mapboxAccessToken;
  }

  /// Geocode address to coordinates
  static Future<LocationPoint?> geocodeAddress(
    Session session, {
    required String address,
    String? countryCode,
    bool useCache = true,
  }) async {
    try {
      session.log('$_className: Geocoding address: $address',
          level: LogLevel.info);

      // Check cache first
      if (useCache) {
        final cacheKey =
            'geocode:${address.toLowerCase().replaceAll(' ', '_')}';
        final cached = await RedisService.get(session, cacheKey);
        if (cached != null) {
          final data = jsonDecode(cached);
          return LocationPoint(
            latitude: data['lat'],
            longitude: data['lng'],
          );
        }
      }

      LocationPoint? result;

      // Try Google Maps first
      if (_googleMapsApiKey != null) {
        result = await _geocodeWithGoogle(session, address, countryCode);
      }

      // Fallback to Mapbox if Google fails
      if (result == null && _mapboxAccessToken != null) {
        result = await _geocodeWithMapbox(session, address, countryCode);
      }

      if (result == null) {
        throw Exception(ErrorCodes.geocodingFailed);
      }

      // Cache successful result
      if (useCache) {
        final cacheKey =
            'geocode:${address.toLowerCase().replaceAll(' ', '_')}';
        await RedisService.setWithExpiry(
          session,
          cacheKey,
          jsonEncode({'lat': result.latitude, 'lng': result.longitude}),
          Duration(seconds: _geocodeCacheDuration),
        );
      }

      return result;
    } catch (e, stackTrace) {
      session.log('$_className: Geocoding failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Reverse geocode coordinates to address
  static Future<String?> reverseGeocode(
    Session session, {
    required double latitude,
    required double longitude,
    bool useCache = true,
  }) async {
    try {
      session.log('$_className: Reverse geocoding: $latitude, $longitude',
          level: LogLevel.info);

      // Check cache first
      if (useCache) {
        final cacheKey =
            'reverse_geocode:${latitude.toStringAsFixed(4)}_${longitude.toStringAsFixed(4)}';
        final cached = await RedisService.get(session, cacheKey);
        if (cached != null) {
          return cached;
        }
      }

      String? result;

      // Try Google Maps first
      if (_googleMapsApiKey != null) {
        result = await _reverseGeocodeWithGoogle(session, latitude, longitude);
      }

      // Fallback to Mapbox if Google fails
      if (result == null && _mapboxAccessToken != null) {
        result = await _reverseGeocodeWithMapbox(session, latitude, longitude);
      }

      if (result == null) {
        throw Exception(ErrorCodes.reverseGeocodingFailed);
      }

      // Cache successful result
      if (useCache) {
        final cacheKey =
            'reverse_geocode:${latitude.toStringAsFixed(4)}_${longitude.toStringAsFixed(4)}';
        await RedisService.setWithExpiry(
          session,
          cacheKey,
          result,
          Duration(seconds: _geocodeCacheDuration),
        );
      }

      return result;
    } catch (e, stackTrace) {
      session.log('$_className: Reverse geocoding failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Calculate route between two points
  static Future<RouteInfo?> calculateRoute(
    Session session, {
    required LocationPoint origin,
    required LocationPoint destination,
    List<Waypoint>? waypoints,
    String mode = 'driving',
    bool avoidTolls = false,
    bool useCache = true,
  }) async {
    try {
      session.log(
          '$_className: Calculating route from ${origin.latitude},${origin.longitude} to ${destination.latitude},${destination.longitude}',
          level: LogLevel.info);

      // Check cache first
      if (useCache) {
        final cacheKey =
            _buildRouteCacheKey(origin, destination, waypoints, mode);
        final cached = await RedisService.get(session, cacheKey);
        if (cached != null) {
          final data = jsonDecode(cached);
          return RouteInfo.fromJson(data);
        }
      }

      RouteInfo? result;

      // Try Google Maps first
      if (_googleMapsApiKey != null) {
        result = await _calculateRouteWithGoogle(
          session,
          origin,
          destination,
          waypoints,
          mode,
          avoidTolls,
        );
      }

      // Fallback to Mapbox if Google fails
      if (result == null && _mapboxAccessToken != null) {
        result = await _calculateRouteWithMapbox(
          session,
          origin,
          destination,
          waypoints,
          mode,
        );
      }

      if (result == null) {
        throw Exception(ErrorCodes.routeCalculationFailed);
      }

      // Cache successful result
      if (useCache) {
        final cacheKey =
            _buildRouteCacheKey(origin, destination, waypoints, mode);
        await RedisService.setWithExpiry(
          session,
          cacheKey,
          jsonEncode(result.toJson()),
          Duration(seconds: _routeCacheDuration),
        );
      }

      return result;
    } catch (e, stackTrace) {
      session.log('$_className: Route calculation failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Update driver location
  static Future<void> updateDriverLocation(
    Session session, {
    required int driverId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
    bool isAvailable = true,
  }) async {
    try {
      session.log('$_className: Updating driver location: $driverId',
          level: LogLevel.debug);

      final locationUpdate = LocationUpdate(
        userId: driverId,
        latitude: latitude,
        longitude: longitude,
        heading: heading,
        speed: speed,
        accuracy: accuracy,
        timestamp: DateTime.now(),
        source: LocationSource.gps,
        isActive: isAvailable,
      );

      // Store in Redis with TTL
      final locationKey = 'driver_location:$driverId';
      await RedisService.setWithExpiry(
        session,
        locationKey,
        jsonEncode(locationUpdate.toJson()),
        Duration(seconds: _locationUpdateTtl),
      );

      // Update spatial index for nearby driver queries
      await _updateSpatialIndex(
          session, driverId, latitude, longitude, isAvailable);

      // Store in database for historical tracking
      await _storeLocationInDatabase(session, locationUpdate);
    } catch (e, stackTrace) {
      session.log('$_className: Failed to update driver location: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
    }
  }

  /// Find nearby drivers
  static Future<List<DriverLocation>> findNearbyDrivers(
    Session session, {
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int maxResults = 20,
    RideType? rideType,
    bool onlyAvailable = true,
  }) async {
    try {
      session.log(
          '$_className: Finding nearby drivers at $latitude,$longitude within ${radiusKm}km',
          level: LogLevel.info);

      final nearbyDrivers = <DriverLocation>[];

      // Get drivers from spatial index
      final gridKeys = _getGridKeys(latitude, longitude, radiusKm);

      for (final gridKey in gridKeys) {
        final driverIds =
            await RedisService.getSet(session, 'grid:$gridKey') ?? [];

        for (final driverIdStr in driverIds) {
          final driverId = int.tryParse(driverIdStr);
          if (driverId == null) continue;

          final driverLocation = await _getDriverLocation(session, driverId);
          if (driverLocation == null) continue;

          // Check if driver meets criteria
          if (onlyAvailable && !driverLocation.isAvailable) continue;

          // Calculate distance
          final distance = LocationHelper.calculateDistance(
            latitude,
            longitude,
            driverLocation.latitude,
            driverLocation.longitude,
          );

          if (distance <= radiusKm) {
            nearbyDrivers.add(driverLocation);
          }
        }
      }

      // Sort by distance and limit results
      nearbyDrivers.sort((a, b) {
        final distanceA = LocationHelper.calculateDistance(
            latitude, longitude, a.latitude, a.longitude);
        final distanceB = LocationHelper.calculateDistance(
            latitude, longitude, b.latitude, b.longitude);
        return distanceA.compareTo(distanceB);
      });

      return nearbyDrivers.take(maxResults).toList();
    } catch (e, stackTrace) {
      session.log('$_className: Failed to find nearby drivers: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// Check if location is within service area
  static Future<bool> isLocationInServiceArea(
    Session session, {
    required double latitude,
    required double longitude,
  }) async {
    try {
      // Check if within service bounds
      if (!LocationHelper.isPointInPolygon(
        latitude,
        longitude,
        _serviceAreaBounds,
      )) {
        return false;
      }

      // Additional checks can be added here (e.g., specific area restrictions)
      return true;
    } catch (e) {
      session.log('$_className: Error checking service area: $e',
          level: LogLevel.error);
      return false;
    }
  }

  /// Calculate ETA for driver to pickup location
  static Future<Duration?> calculatePickupETA(
    Session session, {
    required int driverId,
    required LocationPoint pickupLocation,
  }) async {
    try {
      final driverLocation = await _getDriverLocation(session, driverId);
      if (driverLocation == null) return null;

      final driverPoint = LocationPoint(
        latitude: driverLocation.latitude,
        longitude: driverLocation.longitude,
      );

      final route = await calculateRoute(
        session,
        origin: driverPoint,
        destination: pickupLocation,
      );

      return route?.duration;
    } catch (e) {
      session.log('$_className: Error calculating pickup ETA: $e',
          level: LogLevel.error);
      return null;
    }
  }

  /// Get location suggestions for autocomplete
  static Future<List<Map<String, dynamic>>> getLocationSuggestions(
    Session session, {
    required String query,
    double? latitude,
    double? longitude,
    int maxResults = 5,
  }) async {
    try {
      if (query.length < 3) return [];

      // Check cache first
      final cacheKey = 'suggestions:${query.toLowerCase()}';
      final cached = await RedisService.get(session, cacheKey);
      if (cached != null) {
        final List<dynamic> data = jsonDecode(cached);
        return data.cast<Map<String, dynamic>>();
      }

      List<Map<String, dynamic>> suggestions = [];

      // Get suggestions from Google Places API
      if (_googleMapsApiKey != null) {
        suggestions = await _getPlaceSuggestions(
          session,
          query,
          latitude,
          longitude,
          maxResults,
        );
      }

      // Cache results
      await RedisService.setWithExpiry(
        session,
        cacheKey,
        jsonEncode(suggestions),
        Duration(hours: 1),
      );

      return suggestions;
    } catch (e) {
      session.log('$_className: Error getting location suggestions: $e',
          level: LogLevel.error);
      return [];
    }
  }

  // Private helper methods

  static Future<LocationPoint?> _geocodeWithGoogle(
    Session session,
    String address,
    String? countryCode,
  ) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      var url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$_googleMapsApiKey';

      if (countryCode != null) {
        url += '&components=country:$countryCode';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['status'] != 'OK' || data['results'].isEmpty) return null;

      final location = data['results'][0]['geometry']['location'];
      return LocationPoint(
        latitude: location['lat'].toDouble(),
        longitude: location['lng'].toDouble(),
      );
    } catch (e) {
      session.log('$_className: Google geocoding error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static Future<LocationPoint?> _geocodeWithMapbox(
    Session session,
    String address,
    String? countryCode,
  ) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      var url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$encodedAddress.json?access_token=$_mapboxAccessToken&limit=1';

      if (countryCode != null) {
        url += '&country=$countryCode';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['features'].isEmpty) return null;

      final coordinates = data['features'][0]['center'];
      return LocationPoint(
        latitude: coordinates[1].toDouble(),
        longitude: coordinates[0].toDouble(),
      );
    } catch (e) {
      session.log('$_className: Mapbox geocoding error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static Future<String?> _reverseGeocodeWithGoogle(
    Session session,
    double latitude,
    double longitude,
  ) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_googleMapsApiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['status'] != 'OK' || data['results'].isEmpty) return null;

      return data['results'][0]['formatted_address'];
    } catch (e) {
      session.log('$_className: Google reverse geocoding error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static Future<String?> _reverseGeocodeWithMapbox(
    Session session,
    double latitude,
    double longitude,
  ) async {
    try {
      final url =
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json?access_token=$_mapboxAccessToken&limit=1';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['features'].isEmpty) return null;

      return data['features'][0]['place_name'];
    } catch (e) {
      session.log('$_className: Mapbox reverse geocoding error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static Future<RouteInfo?> _calculateRouteWithGoogle(
    Session session,
    LocationPoint origin,
    LocationPoint destination,
    List<Waypoint>? waypoints,
    String mode,
    bool avoidTolls,
  ) async {
    try {
      var url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=$mode&'
          'key=$_googleMapsApiKey';

      if (waypoints != null && waypoints.isNotEmpty) {
        final waypointStr =
            waypoints.map((w) => '${w.latitude},${w.longitude}').join('|');
        url += '&waypoints=$waypointStr';
      }

      if (avoidTolls) {
        url += '&avoid=tolls';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['status'] != 'OK' || data['routes'].isEmpty) return null;

      final route = data['routes'][0];
      final leg = route['legs'][0];

      return RouteInfo(
        distance: leg['distance']['value'] / 1000.0, // Convert to km
        duration: Duration(seconds: leg['duration']['value']),
        polyline: route['overview_polyline']['points'],
        bounds: {
          'northeast': route['bounds']['northeast'],
          'southwest': route['bounds']['southwest'],
        },
        steps: (leg['steps'] as List)
            .map((step) => {
                  'instruction': step['html_instructions'],
                  'distance': step['distance']['value'],
                  'duration': step['duration']['value'],
                })
            .toList(),
      );
    } catch (e) {
      session.log('$_className: Google route calculation error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static Future<RouteInfo?> _calculateRouteWithMapbox(
    Session session,
    LocationPoint origin,
    LocationPoint destination,
    List<Waypoint>? waypoints,
    String mode,
  ) async {
    try {
      var coordinates = '${origin.longitude},${origin.latitude}';

      if (waypoints != null && waypoints.isNotEmpty) {
        for (final waypoint in waypoints) {
          coordinates += ';${waypoint.longitude},${waypoint.latitude}';
        }
      }

      coordinates += ';${destination.longitude},${destination.latitude}';

      final profile = mode == 'walking' ? 'walking' : 'driving';
      final url =
          'https://api.mapbox.com/directions/v5/mapbox/$profile/$coordinates?'
          'steps=true&geometries=polyline&access_token=$_mapboxAccessToken';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      if (data['routes'].isEmpty) return null;

      final route = data['routes'][0];

      return RouteInfo(
        distance: route['distance'] / 1000.0, // Convert to km
        duration: Duration(seconds: route['duration'].round()),
        polyline: route['geometry'],
        bounds: null, // Mapbox doesn't provide bounds directly
        steps: (route['legs'][0]['steps'] as List)
            .map((step) => {
                  'instruction': step['maneuver']['instruction'],
                  'distance': step['distance'],
                  'duration': step['duration'],
                })
            .toList(),
      );
    } catch (e) {
      session.log('$_className: Mapbox route calculation error: $e',
          level: LogLevel.error);
      return null;
    }
  }

  static String _buildRouteCacheKey(
    LocationPoint origin,
    LocationPoint destination,
    List<Waypoint>? waypoints,
    String mode,
  ) {
    var key =
        'route:${origin.latitude.toStringAsFixed(4)}_${origin.longitude.toStringAsFixed(4)}_'
        '${destination.latitude.toStringAsFixed(4)}_${destination.longitude.toStringAsFixed(4)}_$mode';

    if (waypoints != null && waypoints.isNotEmpty) {
      key += '_${waypoints.length}wp';
    }

    return key;
  }

  static Future<void> _updateSpatialIndex(
    Session session,
    int driverId,
    double latitude,
    double longitude,
    bool isAvailable,
  ) async {
    try {
      // Simple grid-based spatial indexing
      final gridKey =
          '${(latitude * 100).floor()}_${(longitude * 100).floor()}';

      if (isAvailable) {
        await RedisService.addToSet(
            session, 'grid:$gridKey', driverId.toString());
      } else {
        await RedisService.removeFromSet(
            session, 'grid:$gridKey', driverId.toString());
      }
    } catch (e) {
      session.log('$_className: Error updating spatial index: $e',
          level: LogLevel.error);
    }
  }

  static List<String> _getGridKeys(
      double latitude, double longitude, double radiusKm) {
    final keys = <String>[];

    // Calculate grid cells that might contain drivers within radius
    final cellSize = 0.01; // Approximately 1km
    final cellRadius = (radiusKm / 111.0 / cellSize).ceil(); // Rough conversion

    final centerLat = (latitude * 100).floor();
    final centerLng = (longitude * 100).floor();

    for (int latOffset = -cellRadius; latOffset <= cellRadius; latOffset++) {
      for (int lngOffset = -cellRadius; lngOffset <= cellRadius; lngOffset++) {
        keys.add('${centerLat + latOffset}_${centerLng + lngOffset}');
      }
    }

    return keys;
  }

  static Future<DriverLocation?> _getDriverLocation(
      Session session, int driverId) async {
    try {
      final locationKey = 'driver_location:$driverId';
      final cached = await RedisService.get(session, locationKey);
      if (cached == null) return null;

      final data = jsonDecode(cached);
      return DriverLocation.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  static Future<void> _storeLocationInDatabase(
      Session session, LocationUpdate locationUpdate) async {
    try {
      // TODO: Implement database storage for location history
      // This would typically store in a time-series database or dedicated location table
    } catch (e) {
      session.log('$_className: Error storing location in database: $e',
          level: LogLevel.error);
    }
  }

  static Future<List<Map<String, dynamic>>> _getPlaceSuggestions(
    Session session,
    String query,
    double? latitude,
    double? longitude,
    int maxResults,
  ) async {
    try {
      var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=${Uri.encodeComponent(query)}&'
          'key=$_googleMapsApiKey&'
          'types=establishment|geocode';

      if (latitude != null && longitude != null) {
        url += '&location=$latitude,$longitude&radius=50000'; // 50km radius
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body);
      if (data['status'] != 'OK') return [];

      final predictions = data['predictions'] as List;
      return predictions
          .take(maxResults)
          .map((prediction) => {
                'place_id': prediction['place_id'],
                'description': prediction['description'],
                'main_text': prediction['structured_formatting']['main_text'],
                'secondary_text':
                    prediction['structured_formatting']['secondary_text'] ?? '',
                'types': prediction['types'],
              })
          .toList();
    } catch (e) {
      session.log('$_className: Error getting place suggestions: $e',
          level: LogLevel.error);
      return [];
    }
  }
}
