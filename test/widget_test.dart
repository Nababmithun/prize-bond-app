import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/asset_loader.dart';
import 'package:Bond_Notifier/main.dart' as app;

class _FakeLoader extends AssetLoader {
  const _FakeLoader();
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async => {};
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds and shows MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('bn')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const _FakeLoader(),
        child: const app.BondNotifierApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
