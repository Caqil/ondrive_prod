import 'dart:convert';
import 'dart:math';
import 'package:serverpod/serverpod.dart';
import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ride_hailing_shared/shared.dart';
import '../utils/error_codes.dart';
import '../utils/validators.dart';
import 'redis_service.dart';

/// Authentication and authorization service
class AuthService {
  static const String _className = 'AuthService';

  // JWT configuration
  static const String _jwtSecret =
      'your_jwt_secret_key'; // Should come from config
  static const int _accessTokenExpiry = 86400; // 24 hours
  static const int _refreshTokenExpiry = 604800; // 7 days

  // Session configuration
  static const int _maxLoginAttempts = 5;
  static const int _lockoutDuration = 900; // 15 minutes
  static const int _otpExpiry = 600; // 10 minutes

  /// Register a new user
  static Future<AuthResponse> register(
    Session session, {
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserType userType,
    String? deviceId,
    String? fcmToken,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      session.log('$_className: Registering user with email: $email',
          level: LogLevel.info);

      // Validate input
      final emailValidation = Validators.isValidEmail(email);
      if (!emailValidation) {
        return AuthResponse.error(
          message: 'Invalid email format',
        );
      }

      final passwordValidation = Validators.validatePassword(password);
      if (!passwordValidation.isValid) {
        return AuthResponse.error(
          message: 'Invalid password',
          errors: passwordValidation.errors,
        );
      }

      final phoneValidation = Validators.isValidPhoneNumber(phone);
      if (!phoneValidation) {
        return AuthResponse.error(
          message: 'Invalid phone number',
        );
      }

      // Check if user already exists
      final existingUser = await _findUserByEmail(session, email);
      if (existingUser != null) {
        return AuthResponse.error(
          message: 'Email already exists',
          errors: [ErrorCodes.emailAlreadyExists],
        );
      }

      final existingPhoneUser = await _findUserByPhone(session, phone);
      if (existingPhoneUser != null) {
        return AuthResponse.error(
          message: 'Phone number already exists',
          errors: [ErrorCodes.phoneAlreadyExists],
        );
      }

      // Hash password
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Create user
      final user = User(
        email: email.toLowerCase(),
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        userType: userType,
        createdAt: DateTime.now(),
        isVerified: false,
        isActive: true,
        isOnline: false,
      );

      // Save user to database (would typically be implemented)
      final savedUser = await _saveUser(session, user, hashedPassword);

      // Generate verification tokens
      final emailToken = _generateVerificationToken();
      final phoneToken = _generateOTP();

      // Store verification tokens in Redis
      await RedisService.setWithExpiry(
        session,
        'email_verification:${savedUser.id}',
        emailToken,
        Duration(hours: 24),
      );

      await RedisService.setWithExpiry(
        session,
        'phone_verification:${savedUser.id}',
        phoneToken,
        Duration(minutes: _otpExpiry ~/ 60),
      );

      // Store FCM token if provided
      if (fcmToken != null) {
        await RedisService.set(session, 'fcm_token:${savedUser.id}', fcmToken);
      }

      // Generate JWT tokens
      final jwtToken = await _generateTokens(session, savedUser);

      session.log('$_className: User registered successfully: ${savedUser.id}',
          level: LogLevel.info);

      return AuthResponse.success(
        message: 'Registration successful',
        user: _sanitizeUser(savedUser),
        token: jwtToken,
        metadata: {
          'requires_email_verification': true,
          'requires_phone_verification': true,
          'email_token': emailToken,
          'phone_token': phoneToken,
        },
      );
    } catch (e, stackTrace) {
      session.log('$_className: Registration failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return AuthResponse.error(
        message: 'Registration failed',
        errors: [e.toString()],
      );
    }
  }

  /// Login user with email/password
  static Future<AuthResponse> login(
    Session session, {
    required String email,
    required String password,
    String? deviceId,
    String? fcmToken,
  }) async {
    try {
      session.log('$_className: Login attempt for email: $email',
          level: LogLevel.info);

      // Check rate limiting
      final canAttempt = await _checkLoginAttempts(session, email);
      if (!canAttempt) {
        return AuthResponse.error(
          message: 'Too many login attempts. Please try again later.',
          errors: [ErrorCodes.tooManyLoginAttempts],
        );
      }

      // Find user
      final userWithPassword =
          await _findUserByEmailWithPassword(session, email);
      if (userWithPassword == null) {
        await _recordFailedAttempt(session, email);
        return AuthResponse.error(
          message: 'Invalid credentials',
          errors: [ErrorCodes.invalidCredentials],
        );
      }

      final user = userWithPassword['user'] as User;
      final passwordHash = userWithPassword['passwordHash'] as String;

      // Check if user is active
      if (!user.isActive) {
        return AuthResponse.error(
          message: 'Account is disabled',
          errors: [ErrorCodes.accountSuspended],
        );
      }

      // Verify password
      if (!BCrypt.checkpw(password, passwordHash)) {
        await _recordFailedAttempt(session, email);
        return AuthResponse.error(
          message: 'Invalid credentials',
          errors: [ErrorCodes.invalidCredentials],
        );
      }

      // Clear failed attempts
      await RedisService.delete(session, 'login_attempts:$email');

      // Update last login and online status
      user.lastLoginAt = DateTime.now();
      user.isOnline = true;
      await _updateUser(session, user);

      // Store FCM token if provided
      if (fcmToken != null) {
        await RedisService.set(session, 'fcm_token:${user.id}', fcmToken);
      }

      // Generate tokens
      final jwtToken = await _generateTokens(session, user);

      // Store device session if provided
      if (deviceId != null) {
        await _storeDeviceSession(
            session, user.id!, deviceId, jwtToken.refreshToken);
      }

      session.log('$_className: Login successful for user: ${user.id}',
          level: LogLevel.info);

      return AuthResponse.success(
        message: 'Login successful',
        user: _sanitizeUser(user),
        token: jwtToken,
        metadata: {
          'requires_verification': !user.isVerified,
          'is_new_user': false,
        },
      );
    } catch (e, stackTrace) {
      session.log('$_className: Login failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return AuthResponse.error(
        message: 'Login failed',
        errors: [e.toString()],
      );
    }
  }

  /// Refresh access token
  static Future<AuthResponse> refreshToken(
    Session session, {
    required String refreshToken,
  }) async {
    try {
      session.log('$_className: Refreshing token', level: LogLevel.info);

      // Verify refresh token
      final payload = _verifyToken(refreshToken);
      final userId = payload['userId'] as int;
      final tokenType = payload['type'] as String;

      if (tokenType != 'refresh') {
        return AuthResponse.error(
          message: 'Invalid token type',
          errors: [ErrorCodes.invalidToken],
        );
      }

      // Check if token is blacklisted
      final isBlacklisted =
          await RedisService.exists(session, 'blacklist:$refreshToken');
      if (isBlacklisted) {
        return AuthResponse.error(
          message: 'Token has been revoked',
          errors: [ErrorCodes.tokenExpired],
        );
      }

      // Get user
      final user = await _findUserById(session, userId);
      if (user == null || !user.isActive) {
        return AuthResponse.error(
          message: 'User not found or inactive',
          errors: [ErrorCodes.userNotFound],
        );
      }

      // Generate new tokens
      final newJwtToken = await _generateTokens(session, user);

      // Blacklist old refresh token
      await RedisService.setWithExpiry(
        session,
        'blacklist:$refreshToken',
        'revoked',
        Duration(seconds: _refreshTokenExpiry),
      );

      return AuthResponse.success(
        message: 'Token refreshed successfully',
        user: _sanitizeUser(user),
        token: newJwtToken,
      );
    } catch (e, stackTrace) {
      session.log('$_className: Token refresh failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return AuthResponse.error(
        message: 'Token refresh failed',
        errors: [e.toString()],
      );
    }
  }

  /// Logout user
  static Future<bool> logout(
    Session session, {
    required String accessToken,
    String? refreshToken,
    String? deviceId,
  }) async {
    try {
      session.log('$_className: Logging out user', level: LogLevel.info);

      // Get user ID from token
      final payload = _verifyToken(accessToken);
      final userId = payload['userId'] as int;

      // Update user online status
      final user = await _findUserById(session, userId);
      if (user != null) {
        user.isOnline = false;
        await _updateUser(session, user);
      }

      // Blacklist tokens
      if (accessToken.isNotEmpty) {
        await RedisService.setWithExpiry(
          session,
          'blacklist:$accessToken',
          'revoked',
          Duration(seconds: _accessTokenExpiry),
        );
      }

      if (refreshToken != null && refreshToken.isNotEmpty) {
        await RedisService.setWithExpiry(
          session,
          'blacklist:$refreshToken',
          'revoked',
          Duration(seconds: _refreshTokenExpiry),
        );
      }

      // Remove device session and FCM token
      if (deviceId != null) {
        await RedisService.delete(
            session, 'device_session:${userId}:$deviceId');
      }
      await RedisService.delete(session, 'fcm_token:$userId');

      session.log('$_className: Logout successful', level: LogLevel.info);
      return true;
    } catch (e, stackTrace) {
      session.log('$_className: Logout failed: $e',
          level: LogLevel.error, exception: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Verify email
  static Future<AuthResponse> verifyEmail(
    Session session, {
    required int userId,
    required String token,
  }) async {
    try {
      final storedToken =
          await RedisService.get(session, 'email_verification:$userId');
      if (storedToken == null || storedToken != token) {
        return AuthResponse.error(
          message: 'Invalid or expired verification token',
          errors: [ErrorCodes.emailNotVerified],
        );
      }

      // Update user
      final user = await _findUserById(session, userId);
      if (user == null) {
        return AuthResponse.error(
          message: 'User not found',
          errors: [ErrorCodes.userNotFound],
        );
      }

      user.isVerified = true;
      await _updateUser(session, user);

      // Remove verification token
      await RedisService.delete(session, 'email_verification:$userId');

      return AuthResponse.success(
        message: 'Email verified successfully',
        user: _sanitizeUser(user),
      );
    } catch (e) {
      session.log('$_className: Email verification failed: $e',
          level: LogLevel.error);
      return AuthResponse.error(
        message: 'Email verification failed',
        errors: [e.toString()],
      );
    }
  }

  /// Verify phone
  static Future<AuthResponse> verifyPhone(
    Session session, {
    required int userId,
    required String otp,
  }) async {
    try {
      final storedOtp =
          await RedisService.get(session, 'phone_verification:$userId');
      if (storedOtp == null || storedOtp != otp) {
        return AuthResponse.error(
          message: 'Invalid or expired verification code',
          errors: [ErrorCodes.invalidVerificationCode],
        );
      }

      // Update user
      final user = await _findUserById(session, userId);
      if (user == null) {
        return AuthResponse.error(
          message: 'User not found',
          errors: [ErrorCodes.userNotFound],
        );
      }

      await _updateUser(session, user);

      // Remove verification OTP
      await RedisService.delete(session, 'phone_verification:$userId');

      return AuthResponse.success(
        message: 'Phone verified successfully',
        user: _sanitizeUser(user),
      );
    } catch (e) {
      session.log('$_className: Phone verification failed: $e',
          level: LogLevel.error);
      return AuthResponse.error(
        message: 'Phone verification failed',
        errors: [e.toString()],
      );
    }
  }

  /// Validate access token
  static Future<User?> validateToken(
    Session session, {
    required String token,
  }) async {
    try {
      // Check if token is blacklisted
      final isBlacklisted =
          await RedisService.exists(session, 'blacklist:$token');
      if (isBlacklisted) {
        return null;
      }

      // Verify token
      final payload = _verifyToken(token);
      final userId = payload['userId'] as int;
      final tokenType = payload['type'] as String;

      if (tokenType != 'access') {
        return null;
      }

      // Get user
      final user = await _findUserById(session, userId);
      if (user == null || !user.isActive) {
        return null;
      }

      return user;
    } catch (e) {
      session.log('$_className: Token validation failed: $e',
          level: LogLevel.debug);
      return null;
    }
  }

  /// Reset password
  static Future<AuthResponse> resetPassword(
    Session session, {
    required String email,
  }) async {
    try {
      final user = await _findUserByEmail(session, email);
      if (user == null) {
        // Don't reveal if email exists for security
        return AuthResponse.success(
          message: 'If the email exists, a reset link has been sent',
        );
      }

      final resetToken = _generateVerificationToken();
      await RedisService.setWithExpiry(
        session,
        'password_reset:${user.id}',
        resetToken,
        Duration(hours: 1),
      );

      // TODO: Send reset email via EmailService
      session.log(
          '$_className: Password reset token generated for user: ${user.id}',
          level: LogLevel.info);

      return AuthResponse.success(
        message: 'If the email exists, a reset link has been sent',
        metadata: {'reset_token': resetToken}, // Remove in production
      );
    } catch (e) {
      session.log('$_className: Password reset failed: $e',
          level: LogLevel.error);
      return AuthResponse.error(
        message: 'Password reset failed',
        errors: [e.toString()],
      );
    }
  }

  // Private helper methods

  static Future<User?> _findUserByEmail(Session session, String email) async {
    // TODO: Implement database query
    return null;
  }

  static Future<User?> _findUserByPhone(Session session, String phone) async {
    // TODO: Implement database query
    return null;
  }

  static Future<User?> _findUserById(Session session, int id) async {
    // TODO: Implement database query
    return null;
  }

  static Future<Map<String, dynamic>?> _findUserByEmailWithPassword(
      Session session, String email) async {
    // TODO: Implement database query that returns both user and passwordHash
    return null;
  }

  static Future<User> _saveUser(
      Session session, User user, String passwordHash) async {
    // TODO: Implement database save with password hash
    user.id = Random().nextInt(100000); // Temporary
    return user;
  }

  static Future<void> _updateUser(Session session, User user) async {
    // TODO: Implement database update
  }

  static Future<JwtToken> _generateTokens(Session session, User user) async {
    final now = DateTime.now();

    final accessPayload = {
      'userId': user.id,
      'email': user.email,
      'userType': user.userType.toString(),
      'type': 'access',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': (now.add(Duration(seconds: _accessTokenExpiry)))
              .millisecondsSinceEpoch ~/
          1000,
    };

    final refreshPayload = {
      'userId': user.id,
      'type': 'refresh',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': (now.add(Duration(seconds: _refreshTokenExpiry)))
              .millisecondsSinceEpoch ~/
          1000,
    };

    final accessToken = _generateJWT(accessPayload);
    final refreshToken = _generateJWT(refreshPayload);

    return JwtToken.create(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: _accessTokenExpiry,
      refreshExpiresIn: _refreshTokenExpiry,
    );
  }

  static String _generateJWT(Map<String, dynamic> payload) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final headerEncoded = base64Url.encode(utf8.encode(jsonEncode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(jsonEncode(payload)));

    final signature = _generateSignature('$headerEncoded.$payloadEncoded');

    return '$headerEncoded.$payloadEncoded.$signature';
  }

  static String _generateSignature(String data) {
    final key = utf8.encode(_jwtSecret);
    final bytes = utf8.encode(data);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return base64Url.encode(digest.bytes);
  }

  static Map<String, dynamic> _verifyToken(String token) {
    try {
      if (JwtDecoder.isExpired(token)) {
        throw Exception(ErrorCodes.tokenExpired);
      }

      return JwtDecoder.decode(token);
    } catch (e) {
      throw Exception(ErrorCodes.invalidToken);
    }
  }

  static User _sanitizeUser(User user) {
    // Return user without sensitive information
    return User(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      profileImageUrl: user.profileImageUrl,
      userType: user.userType,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      lastLoginAt: user.lastLoginAt,
      isVerified: user.isVerified,
      isActive: user.isActive,
      isOnline: user.isOnline,
      profile: user.profile,
      settings: user.settings,
      driverProfile: user.driverProfile,
    );
  }

  static String _generateVerificationToken() {
    final random = Random.secure();
    return List.generate(
            32, (i) => random.nextInt(256).toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static String _generateOTP() {
    final random = Random.secure();
    return List.generate(6, (i) => random.nextInt(10)).join();
  }

  static Future<bool> _checkLoginAttempts(Session session, String email) async {
    final key = 'login_attempts:$email';
    final attemptsStr = await RedisService.get(session, key);

    if (attemptsStr != null) {
      final attempts = int.tryParse(attemptsStr) ?? 0;
      if (attempts >= _maxLoginAttempts) {
        return false;
      }
    }
    return true;
  }

  static Future<void> _recordFailedAttempt(
      Session session, String email) async {
    final key = 'login_attempts:$email';
    final attemptsStr = await RedisService.get(session, key);
    final attempts = (int.tryParse(attemptsStr ?? '0') ?? 0) + 1;

    await RedisService.setWithExpiry(
      session,
      key,
      attempts.toString(),
      Duration(seconds: _lockoutDuration),
    );
  }

  static Future<void> _storeDeviceSession(
    Session session,
    int userId,
    String deviceId,
    String refreshToken,
  ) async {
    await RedisService.setWithExpiry(
      session,
      'device_session:$userId:$deviceId',
      refreshToken,
      Duration(seconds: _refreshTokenExpiry),
    );
  }
}
