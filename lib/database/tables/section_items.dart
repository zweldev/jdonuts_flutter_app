import 'package:drift/drift.dart';

import 'products.dart';
import 'sections.dart';

@DataClassName('DbSectionItem')
class SectionItems extends Table {
  TextColumn get sectionId => text().references(Sections, #id)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {sectionId, productId};
}
