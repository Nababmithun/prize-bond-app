class Endpoints {

  //Login  / Register / Verify-Otp
  // POST
  static const String login = 'customer/login';
  // POST
  static const String register = 'customer/registration';
  // POST
  static const String verifyOtp = 'customer/verify-otp';

  // Forgot / Reset password
  // POST
  static const String forgotPassword = 'customer/forgot-password';
  // POST
  static const String resetPassword = 'customer/reset-password';

  // Add New Bond
  // GET
  static const String bondSeriesList = 'bond-series/list';
  // GET
  static const String prizeBondStore = 'prize-bond/store';
  // POST
  static const String prizeBondBulkStore = 'prize-bond/bulk-store';


}
