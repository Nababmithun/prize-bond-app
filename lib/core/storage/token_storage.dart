import 'package:shared_preferences/shared_preferences.dart';

/// Simple key–value storage for auth/session data using [SharedPreferences].
///
/// What it stores:
/// - Logged-in flag
/// - Access token
/// - Primary email
/// - Pending email (e.g., waiting for OTP)
///
/// Notes:
/// - This is NOT encrypted. For high-security tokens consider
///   `flutter_secure_storage` alongside or instead of SharedPreferences.
class TokenStorage {
  TokenStorage._(); // no instance

  // Keys
  static const _kLoggedIn = 'logged_in';
  static const _kEmail = 'email';
  static const _kToken = 'token';
  static const _kPendingEmail = 'pending_email';

  /// Shorthand to get a prefs instance.
  static Future<SharedPreferences> _sp() => SharedPreferences.getInstance();

  // ---------------------------------------------------------------------------
  // Logged-in flag
  // ---------------------------------------------------------------------------

  /// Persist login state (true/false).
  static Future<void> setLoggedIn(bool value) async {
    final sp = await _sp();
    await sp.setBool(_kLoggedIn, value);
  }

  /// Returns whether the user is marked as logged in.
  static Future<bool> isLoggedIn() async {
    final sp = await _sp();
    return sp.getBool(_kLoggedIn) ?? false;
  }

  // ---------------------------------------------------------------------------
  // Email (primary)
  // ---------------------------------------------------------------------------

  /// Save the primary account email.
  static Future<void> saveEmail(String email) async {
    final sp = await _sp();
    await sp.setString(_kEmail, email);
  }

  /// Get the primary account email (if any).
  static Future<String?> getEmail() async {
    final sp = await _sp();
    return sp.getString(_kEmail);
  }

  /// Remove the primary account email.
  static Future<void> clearEmail() async {
    final sp = await _sp();
    await sp.remove(_kEmail);
  }

  // ---------------------------------------------------------------------------
  // Pending email (e.g., registration/forgot password awaiting OTP)
  // ---------------------------------------------------------------------------

  /// Save an email awaiting verification (OTP).
  static Future<void> savePendingEmail(String email) async {
    final sp = await _sp();
    await sp.setString(_kPendingEmail, email);
  }

  /// Get the pending email (if any).
  static Future<String?> getPendingEmail() async {
    final sp = await _sp();
    return sp.getString(_kPendingEmail);
  }

  /// Clear the pending email once verification completes (or cancelled).
  static Future<void> clearPendingEmail() async {
    final sp = await _sp();
    await sp.remove(_kPendingEmail);
  }

  // ---------------------------------------------------------------------------
  // Token
  // ---------------------------------------------------------------------------

  /// Save bearer/access token (plain text – not encrypted).
  static Future<void> saveToken(String token) async {
    final sp = await _sp();
    await sp.setString(_kToken, token);
  }

  /// Get the bearer/access token.
  static Future<String?> getToken() async {
    final sp = await _sp();
    return sp.getString(_kToken);
  }

  /// True if a non-empty token exists.
  static Future<bool> hasToken() async {
    final t = await getToken();
    return (t != null && t.isNotEmpty);
  }

  /// Remove only the token.
  static Future<void> clearToken() async {
    final sp = await _sp();
    await sp.remove(_kToken);
  }

  // ---------------------------------------------------------------------------
  // Session helpers
  // ---------------------------------------------------------------------------

  /// Convenience method to persist a full “logged in” session atomically.
  /// (Saves token + email + logged_in=true)
  static Future<void> persistSession({
    required String token,
    required String email,
  }) async {
    final sp = await _sp();
    await Future.wait([
      sp.setString(_kToken, token),
      sp.setString(_kEmail, email),
      sp.setBool(_kLoggedIn, true),
    ]);
  }

  /// Sign-out convenience method (clears all known keys).
  static Future<void> signOut() async {
    final sp = await _sp();
    await Future.wait([
      sp.remove(_kToken),
      sp.remove(_kEmail),
      sp.remove(_kPendingEmail),
      sp.setBool(_kLoggedIn, false),
    ]);
  }

  /// Nukes everything stored in SharedPreferences (use with care).
  static Future<void> clearAll() async {
    final sp = await _sp();
    await sp.clear();
  }
}
