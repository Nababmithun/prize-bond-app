import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'core/utils/internet_checker.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/bond_repository.dart';
import 'viewmodels/auth_view_model.dart';
import 'viewmodels/bond_view_model.dart';
import 'viewmodels/settings_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('bn')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: const BondNotifierApp(),
    ),
  );
}

class BondNotifierApp extends StatelessWidget {
  const BondNotifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          // Internet connectivity checker after UI ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              InternetChecker.startListening(context);
            });
          });

          return MaterialApp(
            navigatorKey: AppRoutes.navKey,
            debugShowCheckedModeBanner: false,
            title: tr('splash.app_name'),
            theme: AppTheme.light(),
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            onGenerateRoute: AppRoutes.onGenerate,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
