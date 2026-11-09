import 'package:drift/drift.dart';

@DataClassName('DbChallenge')
class Challenges extends Table {
  TextColumn get id => text()();
  TextColumn get tab => text()();
  TextColumn get title => text()();
  IntColumn get progress => integer()();
  IntColumn get target => integer()();
  IntColumn get rewardPoints => integer()();
  TextColumn get artStyle => text()();
  TextColumn get image => text()();
  BoolColumn get claimed => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
