import 'package:flutter/material.dart';

// Screens
import '../../ui/auth/forgot/ForgotEmailView.dart';
import '../../ui/auth/forgot/ResetPasswordView.dart';
import '../../ui/auth/login/login_view.dart';
import '../../ui/auth/register/signup_view.dart';
import '../../ui/auth/register/verify_view.dart';
import '../../ui/home/home_view.dart';
import '../../ui/splash/splash_view.dart';
import '../../ui/subscription/subscription_view.dart';
import '../../ui/notifications/notifications_view.dart';
import '../../ui/profile/profile_view.dart';
import '../../ui/profile/edit_profile_view.dart';
import '../../ui/settings/settings_view.dart';
import '../../ui/settings/change_password_view.dart';
import '../../ui/settings/change_language_view.dart';
import '../../ui/settings/referral_code_view.dart';
import '../../ui/bonds/DrawListView.dart';
import '../../ui/bonds/DrawDetailView.dart';
import '../../ui/bonds/AddBondView.dart';
import '../../ui/bonds/WinningResultView.dart';

/// Centralized named routes & navigator key.
/// NOTE: No logic has been changed from your original file.
/// Only documentation & comments added for clarity.
class AppRoutes {
  AppRoutes._(); // prevent instantiation

  /// Global navigator key (useful for navigation without BuildContext).
  static final navKey = GlobalKey<NavigatorState>();

  // ---------------------------------------------------------------------------
  // Route names
  // ---------------------------------------------------------------------------
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const verify = '/verify';
  static const forgotEmail = '/forgotEmail';
  static const resetPassword = '/resetPassword';
  static const home = '/home';
  static const subscription = '/subscription';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const settings = '/settings';
  static const changePassword = '/changePassword';
  static const changeLanguage = '/changeLanguage';
  static const referral = '/referral';
  static const draw = '/draw';
  static const drawResults = '/drawResults';
  static const addBondSingle = '/addBondSingle';
  static const addBondMulti = '/addBondMulti';

  // ---------------------------------------------------------------------------
  // Route factory
  // ---------------------------------------------------------------------------
  /// onGenerateRoute resolves a route name to a [Route].
  /// Keep arguments handling at the screen-level (as you already do).
  static Route<dynamic> onGenerate(RouteSettings s) {
    switch (s.name) {
      case splash:
        return _r(const SplashView());

      case login:
        return _r(const LoginView());

      case signup:
        return _r(const SignupView());

      case verify:
      // You’re already extracting the email inside VerifyView via ctor arg.
        return _r(VerifyView(emailFromRouteArg: s.arguments as String?));

      case forgotEmail:
        return _r(const ForgotEmailView());

      case resetPassword:
        return _r(const ResetPasswordView());

      case home:
        return _r(const HomeView());

      case subscription:
        return _r(const SubscriptionView());

      case notifications:
        return _r(const NotificationsView());

      case profile:
        return _r(const ProfileView());

      case editProfile:
        return _r(const EditProfileView());

      case settings:
        return _r(const SettingsView());

      case changePassword:
        return _r(const ChangePasswordView());

      case changeLanguage:
        return _r(const ChangeLanguageView());

      case referral:
        return _r(const ReferralCodeView());

      case draw:
        return _r(const DrawListView());

      case drawResults:
        return _r(const DrawDetailView());

      case addBondSingle:
        return _r(const AddBondView());

      case addBondMulti:
        return _r(const WinningResultView());

      default:
        return _r(const Scaffold(
          body: Center(child: Text('Route not found')),
        ));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helper: standard material page route
  // ---------------------------------------------------------------------------
  static MaterialPageRoute _r(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
