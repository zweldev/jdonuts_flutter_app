import 'package:drift/drift.dart';

import 'tiers.dart';
import 'users.dart';

@DataClassName('DbMember')
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().unique().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get tierId => text().references(Tiers, #id)();
  IntColumn get totalPoints => integer()();
  IntColumn get rewardsBadgeCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
