import 'package:drift/drift.dart';

import 'products.dart';

@DataClassName('DbCartItem')
class CartItems extends Table {
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantity =>
      integer().customConstraint('NOT NULL CHECK (quantity >= 1)')();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {productId};
}
