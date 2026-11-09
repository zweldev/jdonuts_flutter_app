import 'package:drift/drift.dart';

import '../app_database.dart';

class RewardsDao {
  const RewardsDao(this.db);

  final AppDatabase db;

  Future<List<DbChallenge>> loadChallenges(String tab) =>
      (db.select(db.challenges)
            ..where((challenge) => challenge.tab.equals(tab))
            ..orderBy([(challenge) => OrderingTerm.asc(challenge.sortOrder)]))
          .get();

  Future<List<DbTier>> loadTiers() => (db.select(
    db.tiers,
  )..orderBy([(tier) => OrderingTerm.asc(tier.sortOrder)])).get();
}
