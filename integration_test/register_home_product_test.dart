import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jdonuts_flutter_app/database/seed/seed_loader.dart';
import 'package:jdonuts_flutter_app/di/service_locator.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/session_store.dart';
import 'package:jdonuts_flutter_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    if (getIt.isRegistered<SessionStore>()) {
      await getIt<SessionStore>().clear();
    }
  });

  testWidgets('registers, opens Home, and opens a product by ID', (
    tester,
  ) async {
    configureDependencies();
    await getIt<SeedLoader>().seedIfNeeded();
    await getIt<SessionStore>().clear();

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();

    final phone =
        '9${(DateTime.now().millisecondsSinceEpoch % 100000000).toString().padLeft(8, '0')}';
    await tester.enterText(find.byType(TextField).first, phone);
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).last, '123456');
    await tester.pumpAndSettle();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Test');
    await tester.enterText(find.byType(TextField).at(1), 'Member');
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('SELECT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to the\nworld of J’donuts'), findsOneWidget);
    await tester.tap(find.text("LET'S EXPLORE"));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    final coconutDonut = find.text('Coconut Donut').first;
    await tester.ensureVisible(coconutDonut);
    await tester.pumpAndSettle();
    await tester.tap(coconutDonut);
    await tester.pumpAndSettle();
    expect(find.text('JD022123'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsWidgets);

    await getIt<SessionStore>().clear();
  });
}
