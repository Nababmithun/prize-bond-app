import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// THEME + ROUTES
import 'core/theme/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/internet_checker.dart';

// REPOSITORIES
import 'data/repositories/ProfileRepository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/bond_repository.dart';

// VIEWMODELS
import 'data/repositories/change_password_repository.dart';
import 'data/viewmodels/ProfileViewModel.dart';
import 'data/viewmodels/auth_view_model.dart';
import 'data/viewmodels/bond_view_model.dart';
import 'data/viewmodels/change_password_view_model.dart';
import 'data/viewmodels/settings_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
    debugPrint(' Uncaught zone error: $error');
  });
}

class BondNotifierApp extends StatelessWidget {
  const BondNotifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //  Global State + Repositories
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => BondRepository()),
        Provider(create: (_) => ProfileRepository()),
        Provider(create: (_) => ChangePasswordRepository()),

        //  ViewModels
        ChangeNotifierProvider(create: (c) => AuthViewModel(c.read<AuthRepository>())),
        ChangeNotifierProvider(create: (c) => BondViewModel(c.read<BondRepository>())),
        ChangeNotifierProvider(create: (c) => ProfileViewModel(c.read<ProfileRepository>())),
        ChangeNotifierProvider(create: (c) => ChangePasswordViewModel(c.read<ChangePasswordRepository>())),
      ],
      child: Builder(
        builder: (context) {
          // Internet check
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 400), () {
              InternetChecker.startListening(context);
            });
          });

          return MaterialApp(
            navigatorKey: AppRoutes.navKey,
            debugShowCheckedModeBanner: false,

            //  Localization
            title: tr('splash.app_name'),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,

            //  Theme
            theme: AppTheme.light(),

            //  Navigation
            onGenerateRoute: AppRoutes.onGenerate,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
