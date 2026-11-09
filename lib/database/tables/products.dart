import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  IntColumn get priceMmk => integer()();
  BoolColumn get isNew => boolean()();
  IntColumn get discountPercent => integer().nullable()();
  TextColumn get imageUrl => text()();
  TextColumn get description => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
