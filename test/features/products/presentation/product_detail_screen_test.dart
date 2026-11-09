import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/core/theme/app_design_system.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/database/daos/cart_dao.dart';
import 'package:jdonuts_flutter_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:jdonuts_flutter_app/l10n/app_localizations.dart';

void main() {
  late AppDatabase database;
  late Product product;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database
        .into(database.products)
        .insert(
          ProductsCompanion.insert(
            id: 'coconut',
            code: 'JD022123',
            name: 'Coconut Donut',
            priceMmk: 3200,
            isNew: true,
            imageUrl: 'assets/images/products/product_1.png',
            description: 'Enjoy our scrumptious donuts.',
          ),
        );
    product = await database.select(database.products).getSingle();
  });

  tearDown(() => database.close());

  testWidgets('shows product details and adds the selected quantity', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProductDetailScreen(product: product, cartDao: CartDao(database)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('JD022123'), findsOneWidget);
    expect(find.text('Coconut Donut'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsNWidgets(2));
    expect(find.text('ADD TO CART'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(find.text('6,400 MMK'), findsOneWidget);

    await tester.tap(find.text('ADD TO CART'));
    await tester.pumpAndSettle();
    expect(find.text('Coconut Donut added to cart.'), findsOneWidget);
    expect((await database.select(database.cartItems).getSingle()).quantity, 2);
  });
}
