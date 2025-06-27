import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';

class EncryptionUtils {
  static const int _saltRounds = 12;
  static const String _algorithm = 'AES-256-GCM';

  // Password hashing using bcrypt
  static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: _saltRounds));
  }

  // Verify password against hash
  static bool verifyPassword(String password, String hash) {
    try {
      return BCrypt.checkpw(password, hash);
    } catch (e) {
      return false;
    }
  }

  // Generate secure random string
  static String generateSecureToken({int length = 32}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Generate cryptographically secure random bytes
  static Uint8List generateRandomBytes(int length) {
    final random = Random.secure();
    return Uint8List.fromList(
        List.generate(length, (_) => random.nextInt(256)));
  }

  // Hash data using SHA-256
  static String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Hash data using SHA-512
  static String sha512Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  // Create HMAC signature
  static String createHmacSignature(String data, String secret) {
    final key = utf8.encode(secret);
    final bytes = utf8.encode(data);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  // Verify HMAC signature
  static bool verifyHmacSignature(
      String data, String signature, String secret) {
    final expectedSignature = createHmacSignature(data, secret);
    return secureCompare(signature, expectedSignature);
  }

  // Secure string comparison to prevent timing attacks
  static bool secureCompare(String a, String b) {
    if (a.length != b.length) return false;

    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  // Generate API key
  static String generateApiKey({String prefix = 'rh'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = generateSecureToken(length: 24);
    final combined = '$timestamp$random';
    final hash = sha256Hash(combined).substring(0, 32);
    return '${prefix}_$hash';
  }

  // Encrypt sensitive data (placeholder - implement with actual encryption library)
  static String encryptSensitiveData(String data, String key) {
    // In production, use proper encryption library like encrypt package
    // This is a placeholder implementation
    final dataBytes = utf8.encode(data);
    final keyBytes = utf8.encode(key);
    final encrypted = <int>[];

    for (int i = 0; i < dataBytes.length; i++) {
      encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64.encode(encrypted);
  }

  // Decrypt sensitive data (placeholder - implement with actual encryption library)
  static String decryptSensitiveData(String encryptedData, String key) {
    // In production, use proper encryption library like encrypt package
    // This is a placeholder implementation
    try {
      final encryptedBytes = base64.decode(encryptedData);
      final keyBytes = utf8.encode(key);
      final decrypted = <int>[];

      for (int i = 0; i < encryptedBytes.length; i++) {
        decrypted.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Failed to decrypt data: $e');
    }
  }

  // Mask sensitive information for logging
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) {
      return '*' * data.length;
    }

    final visible = data.substring(0, visibleChars);
    final masked = '*' * (data.length - visibleChars);
    return '$visible$masked';
  }

  // Mask email address
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final visibleUsername = username.substring(0, 2);
    final maskedUsername = '*' * (username.length - 2);
    return '$visibleUsername$maskedUsername@$domain';
  }

  // Mask phone number
  static String maskPhoneNumber(String phone) {
    if (phone.length <= 4) return '*' * phone.length;

    final lastFour = phone.substring(phone.length - 4);
    final masked = '*' * (phone.length - 4);
    return '$masked$lastFour';
  }

  // Mask credit card number
  static String maskCreditCard(String cardNumber) {
    final cleaned = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length <= 4) return '*' * cleaned.length;

    final lastFour = cleaned.substring(cleaned.length - 4);
    final masked = '*' * (cleaned.length - 4);
    return '$masked$lastFour';
  }

  // Generate verification code
  static String generateVerificationCode({int length = 6}) {
    final random = Random.secure();
    return List.generate(length, (_) => random.nextInt(10)).join();
  }

  // Generate referral code
  static String generateReferralCode({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Calculate password strength
  static PasswordStrength calculatePasswordStrength(String password) {
    if (password.length < 8) return PasswordStrength.weak;

    int score = 0;

    // Length scoring
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    // Character variety scoring
    if (RegExp(r'[a-z]').hasMatch(password)) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 1;

    // No common patterns
    if (!RegExp(r'(123|abc|password|qwerty)', caseSensitive: false)
        .hasMatch(password)) {
      score += 1;
    }

    if (score <= 3) return PasswordStrength.weak;
    if (score <= 5) return PasswordStrength.medium;
    if (score <= 7) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}
