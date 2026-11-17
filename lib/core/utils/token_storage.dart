import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  /// Get Access Token
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (_) {
      return null;
    }
  }

  /// Save Access Token
  static Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (_) {}
  }

  /// Get Refresh Token
  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (_) {
      return null;
    }
  }

  /// Save Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
    } catch (_) {}
  }

  /// Save both tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await saveRefreshToken(refreshToken);
    }
  }

  /// Clear all stored tokens (on logout or session expiration)
  static Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (_) {}
  }

  /// Check if an access token exists
  static Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.trim().isNotEmpty;
  }

  /// Check if access token is locally valid (JWT format and not expired)
  static Future<bool> hasValidAccessToken() async {
    try {
      final token = await getAccessToken();

      if (token == null || token.trim().isEmpty) {
        return false;
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        return false;
      }

      // Safe base64Url decoding of JWT payload
      final normalized = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);

      if (payload is! Map<String, dynamic> || payload['exp'] is! num) {
        return false;
      }

      final expiry = DateTime.fromMillisecondsSinceEpoch(
        (payload['exp'] as num).toInt() * 1000,
      );

      // Return true if expiry is in the future (with 15s grace buffer)
      return expiry.isAfter(DateTime.now().add(const Duration(seconds: 15)));
    } catch (_) {
      return false;
    }
  }
}
