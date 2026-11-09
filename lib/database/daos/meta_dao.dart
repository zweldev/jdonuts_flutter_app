import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/meta_entries.dart';

part 'meta_dao.g.dart';

@DriftAccessor(tables: [MetaEntries])
class MetaDao extends DatabaseAccessor<AppDatabase> with _$MetaDaoMixin {
  MetaDao(super.db);

  Future<String?> read(String key) async =>
      (select(metaEntries)..where((entry) => entry.key.equals(key)))
          .getSingleOrNull()
          .then((entry) => entry?.value);

  Future<void> write(String key, String value) => into(
    metaEntries,
  ).insertOnConflictUpdate(MetaEntriesCompanion.insert(key: key, value: value));
}
