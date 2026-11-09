import 'package:drift/drift.dart';

@DataClassName('DbTier')
class Tiers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get minPoints => integer()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
