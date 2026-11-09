import 'package:drift/drift.dart';

import 'products.dart';

@DataClassName('DbBanner')
class Banners extends Table {
  TextColumn get id => text()();
  TextColumn get badgeText => text().nullable()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  TextColumn get styleKey => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get targetProductId =>
      text().nullable().references(Products, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
