import 'package:drift/drift.dart';

@DataClassName('DbSection')
class Sections extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
