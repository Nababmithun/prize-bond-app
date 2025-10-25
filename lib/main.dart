import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/internet_checker.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/bond_repository.dart';
import 'data/viewmodels/auth_view_model.dart';
import 'data/viewmodels/bond_view_model.dart';
import 'data/viewmodels/settings_view_model.dart';


/// ----------------------------------------------------------------------------
/// ENTRY POINT
/// ----------------------------------------------------------------------------
/// - Initializes EasyLocalization
/// - Wraps runApp with runZonedGuarded for safe error capture (no behavior change)
/// - Renders BondNotifierApp as the root widget
/// ----------------------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // (Optional but safe) — Crash-safe zone; doesn't change your app flow.
  runZonedGuarded(() {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('bn')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        saveLocale: true,
        child: const BondNotifierApp(),
      ),
    );
  }, (error, stack) {
    // You can forward this to Crashlytics/Sentry later if you want.
    // debugPrint('Uncaught zone error: $error');
  });
}

/// ----------------------------------------------------------------------------
/// ROOT APP WIDGET
/// ----------------------------------------------------------------------------
/// - Provides all ViewModels & Repositories
/// - Wires up localization & theme
/// - Starts InternetChecker after first frame
/// - Uses onGenerateRoute with initialRoute = Splash
/// ----------------------------------------------------------------------------
class BondNotifierApp extends StatelessWidget {
  const BondNotifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels / Repositories (DI)
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => BondRepository()),
        ChangeNotifierProvider(
          create: (c) => AuthViewModel(c.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => BondViewModel(c.read<BondRepository>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Start listening to connectivity a tiny bit later so context is mounted.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 400), () {
              InternetChecker.startListening(context);
            });
          });

          return MaterialApp(
            navigatorKey: AppRoutes.navKey,
            debugShowCheckedModeBanner: false,

            // Localization
            title: tr('splash.app_name'),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,

            // Theme
            theme: AppTheme.light(),

            // Navigation
            onGenerateRoute: AppRoutes.onGenerate,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
