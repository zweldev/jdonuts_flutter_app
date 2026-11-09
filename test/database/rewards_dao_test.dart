import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/database/daos/rewards_dao.dart';

void main() {
  late AppDatabase database;
  late RewardsDao rewardsDao;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    rewardsDao = RewardsDao(database);
    await _insertFixture(database);
  });

  tearDown(() => database.close());

  test('loads challenge tabs in sort order', () async {
    final earn = await rewardsDao.loadChallenges('earn');
    final gift = await rewardsDao.loadChallenges('gift');

    expect(earn.map((challenge) => challenge.id), ['complete', 'incomplete']);
    expect(gift.map((challenge) => challenge.id), ['gift']);
  });

  test('loads tiers in sort order', () async {
    final tiers = await rewardsDao.loadTiers();

    expect(tiers.map((tier) => tier.id), ['bronze', 'silver']);
  });
}

Future<void> _insertFixture(AppDatabase database) async {
  await database.batch((batch) {
    batch.insertAll(database.tiers, [
      TiersCompanion.insert(
        id: 'bronze',
        name: 'Bronze',
        minPoints: 0,
        sortOrder: 0,
      ),
      TiersCompanion.insert(
        id: 'silver',
        name: 'Silver',
        minPoints: 100,
        sortOrder: 1,
      ),
    ]);
  });
  await database
      .into(database.users)
      .insert(
        UsersCompanion.insert(
          id: 'user',
          phone: '+959251234567',
          firstName: 'Test',
          lastName: 'Member',
          dateOfBirth: DateTime(2000),
          createdAt: DateTime(2026),
        ),
      );
  await database
      .into(database.members)
      .insert(
        MembersCompanion.insert(
          id: 'member',
          userId: 'user',
          name: 'Test Member',
          tierId: 'bronze',
          totalPoints: 0,
        ),
      );
  await database.batch((batch) {
    batch.insertAll(database.challenges, [
      _challenge(
        id: 'complete',
        tab: 'earn',
        title: 'Complete challenge',
        progress: 1,
        target: 1,
        sortOrder: 0,
      ),
      _challenge(
        id: 'incomplete',
        tab: 'earn',
        title: 'Incomplete challenge',
        progress: 0,
        target: 2,
        sortOrder: 1,
      ),
      _challenge(
        id: 'gift',
        tab: 'gift',
        title: 'Gift challenge',
        progress: 0,
        target: 1,
        sortOrder: 0,
      ),
    ]);
  });
}

ChallengesCompanion _challenge({
  required String id,
  required String tab,
  required String title,
  required int progress,
  required int target,
  required int sortOrder,
}) => ChallengesCompanion.insert(
  id: id,
  tab: tab,
  title: title,
  progress: progress,
  target: target,
  rewardPoints: 100,
  artStyle: 'donut_quarters',
  image: 'assets/images/challenge_items/challenge_item_donut.png',
  sortOrder: sortOrder,
);
