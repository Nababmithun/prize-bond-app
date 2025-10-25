/// Central place to keep all backend endpoint paths used by the app.
/// These are **relative paths**; the base URL is configured in [ApiClient].
///
/// Usage:
/// ```dart
/// final res = await ApiClient.dio.post(Endpoints.login, data: {...});
/// ```
class Endpoints {
  Endpoints._(); // No instance

  // ---------------------------
  // Auth: Login / Register / Verify OTP
  // ---------------------------

  /// POST: Customer login
  static const String login = 'customer/login';

  /// POST: Customer registration (returns OTP send status)
  static const String register = 'customer/registration';

  /// POST: Verify registration OTP
  static const String verifyOtp = 'customer/verify-otp';

  // ---------------------------
  // Password: Forgot / Reset
  // ---------------------------

  /// POST: Send forgot-password OTP to email/phone
  static const String forgotPassword = 'customer/forgot-password';

  /// POST: Reset password using email + OTP + new_password
  static const String resetPassword = 'customer/reset-password';

  // ---------------------------
  // Prize Bond: Series & Store
  // ---------------------------

  /// GET: Fetch prize bond series list (for dropdown)
  static const String bondSeriesList = 'bond-series/list';

  /// POST: Create/store a single prize bond
  static const String prizeBondStore = 'prize-bond/store';

  /// POST: Bulk create/store multiple prize bonds
  static const String prizeBondBulkStore = 'prize-bond/bulk-store';

  // ---------------------------
  // Profile
  //---------------------------
  static const String profileUpdate = 'profile/update';
  static const String profileEdit = 'profile/edit';
  // Prize Bond
  static const String prizeBondList = "prize-bond/list";
}
