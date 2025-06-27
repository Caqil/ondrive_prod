import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jwt_token.g.dart';

@JsonSerializable()
class JwtToken extends SerializableEntity {
  @override
  int? id;

  String accessToken;
  String refreshToken;
  String tokenType;
  int expiresIn; // seconds
  int refreshExpiresIn; // seconds
  DateTime issuedAt;
  DateTime expiresAt;
  DateTime refreshExpiresAt;
  List<String>? scopes;

  JwtToken({
    this.id,
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.issuedAt,
    required this.expiresAt,
    required this.refreshExpiresAt,
    this.scopes,
  });

  factory JwtToken.create({
    required String accessToken,
    required String refreshToken,
    String tokenType = 'Bearer',
    required int expiresIn,
    required int refreshExpiresIn,
    List<String>? scopes,
  }) {
    final now = DateTime.now();
    return JwtToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      refreshExpiresIn: refreshExpiresIn,
      issuedAt: now,
      expiresAt: now.add(Duration(seconds: expiresIn)),
      refreshExpiresAt: now.add(Duration(seconds: refreshExpiresIn)),
      scopes: scopes,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isRefreshExpired => DateTime.now().isAfter(refreshExpiresAt);
  bool get needsRefresh =>
      DateTime.now().isAfter(expiresAt.subtract(Duration(minutes: 5)));

  String get authorizationHeader => '$tokenType $accessToken';

  factory JwtToken.fromJson(Map<String, dynamic> json) =>
      _$JwtTokenFromJson(json);
  Map<String, dynamic> toJson() => _$JwtTokenToJson(this);
}
