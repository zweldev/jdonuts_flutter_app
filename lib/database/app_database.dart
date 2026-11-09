import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'daos/meta_dao.dart';
import 'daos/member_dao.dart';
import 'daos/user_dao.dart';
import 'tables/banners.dart';
import 'tables/cart_items.dart';
import 'tables/challenges.dart';
import 'tables/meta_entries.dart';
import 'tables/members.dart';
import 'tables/products.dart';
import 'tables/section_items.dart';
import 'tables/sections.dart';
import 'tables/shops.dart';
import 'tables/tiers.dart';
import 'tables/users.dart';

part 'app_database.g.dart';

const currentSchemaVersion = 1;
const databaseFilename = 'jdonuts.sqlite';

@DriftDatabase(
  tables: [
    MetaEntries,
    Tiers,
    Products,
    Sections,
    Banners,
    SectionItems,
    Shops,
    Challenges,
    Users,
    Members,
    CartItems,
  ],
  daos: [MemberDao, UserDao, MetaDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {},
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$databaseFilename');
  return NativeDatabase.createInBackground(file);
});
