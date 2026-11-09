import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/database/daos/cart_dao.dart';

void main() {
  late AppDatabase database;
  late CartDao cartDao;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    cartDao = CartDao(database);
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
            description: 'A delicious donut.',
          ),
        );
  });

  tearDown(() => database.close());

  test('adds quantities to an existing cart row', () async {
    await cartDao.addProduct(productId: 'coconut', quantity: 2);
    await cartDao.addProduct(productId: 'coconut', quantity: 3);

    final item = await database.select(database.cartItems).getSingle();
    expect(item.productId, 'coconut');
    expect(item.quantity, 5);
  });

  test('rejects invalid quantities', () async {
    await expectLater(
      cartDao.addProduct(productId: 'coconut', quantity: 0),
      throwsArgumentError,
    );
    expect(await database.select(database.cartItems).get(), isEmpty);
  });
}
