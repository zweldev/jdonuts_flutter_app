import '../app_database.dart';

class CartDao {
  const CartDao(this.db);

  final AppDatabase db;

  Future<void> addProduct({
    required String productId,
    required int quantity,
  }) async {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'Must be at least one.');
    }

    await db.transaction(() async {
      final existing = await (db.select(
        db.cartItems,
      )..where((item) => item.productId.equals(productId))).getSingleOrNull();
      await db
          .into(db.cartItems)
          .insertOnConflictUpdate(
            CartItemsCompanion.insert(
              productId: productId,
              quantity: (existing?.quantity ?? 0) + quantity,
              updatedAt: DateTime.now(),
            ),
          );
    });
  }
}
