import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/core/widgets/app_settings_sheet.dart';
import 'package:jdonuts_flutter_app/l10n/app_locale_controller.dart';
import 'package:jdonuts_flutter_app/l10n/app_localizations.dart';

void main() {
  testWidgets('settings switch changes the app language to Burmese', (
    tester,
  ) async {
    final localeController = AppLocaleController();
    addTearDown(localeController.dispose);

    await tester.pumpWidget(
      AppLocaleScope(
        controller: localeController,
        child: AnimatedBuilder(
          animation: localeController,
          builder: (context, _) => MaterialApp(
            locale: localeController.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      showAppSettingsSheet(context, onLogOut: () {}),
                  child: const Text('Open settings'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(localeController.locale, const Locale('my'));
    expect(find.text('ဆက်တင်များ'), findsOneWidget);
    expect(find.text('မြန်မာဘာသာ အသုံးပြုရန်'), findsOneWidget);
    expect(find.text('အကောင့်မှ ထွက်ရန်'), findsOneWidget);
  });
}
