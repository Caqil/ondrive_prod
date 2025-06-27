import 'package:ride_hailing_shared/src/protocol/tracking/eta_update.dart';
import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

import '../rides/location_point.dart';

part 'location_update.g.dart';

@JsonSerializable()
class LocationUpdate extends SerializableEntity {
  @override
  int? id;

  int userId;
  String? rideId;
  double latitude;
  double longitude;
  double? altitude;
  double? accuracy;
  double? heading;
  double? speed;
  DateTime timestamp;
  LocationSource source;
  Map<String, dynamic>? metadata;

  LocationUpdate({
    this.id,
    required this.userId,
    this.rideId,
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.heading,
    this.speed,
    required this.timestamp,
    this.source = LocationSource.gps,
    this.metadata,
  });

  factory LocationUpdate.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateToJson(this);
}

enum LocationSource {
  gps,
  network,
  passive,
  manual,
}
