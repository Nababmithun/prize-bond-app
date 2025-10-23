import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _kLoggedIn = 'logged_in';
  static const _kEmail = 'email';
  static const _kToken = 'token';
  static const _kPendingEmail = 'pending_email';

  static Future<void> setLoggedIn(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kLoggedIn, v);
  }

  static Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kLoggedIn) ?? false;
  }

  static Future<void> saveEmail(String email) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kEmail, email);
  }

  static Future<String?> getEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kEmail);
  }

  static Future<void> savePendingEmail(String email) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kPendingEmail, email);
  }

  static Future<String?> getPendingEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kPendingEmail);
  }

  static Future<void> clearPendingEmail() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kPendingEmail);
  }

  static Future<void> saveToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, token);
  }

  static Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kToken);
  }

  static Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
