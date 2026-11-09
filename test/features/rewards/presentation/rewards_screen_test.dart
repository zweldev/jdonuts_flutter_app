import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/constants/app_images.dart';
import 'package:jdonuts_flutter_app/core/theme/app_design_system.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/database/daos/rewards_dao.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/session_store.dart';
import 'package:jdonuts_flutter_app/features/members/domain/repositories/member_store.dart';
import 'package:jdonuts_flutter_app/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:jdonuts_flutter_app/features/rewards/presentation/widgets/rewards_painters.dart';
import 'package:jdonuts_flutter_app/l10n/app_localizations.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    database = AppDatabase.forTesting(NativeDatabase.memory());
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
          minPoints: 500000,
          sortOrder: 1,
        ),
        TiersCompanion.insert(
          id: 'gold',
          name: 'Gold',
          minPoints: 680500,
          sortOrder: 2,
        ),
        TiersCompanion.insert(
          id: 'platinum',
          name: 'Platinum',
          minPoints: 1000000,
          sortOrder: 3,
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
            totalPoints: 350000,
            rewardsBadgeCount: const Value(3),
          ),
        );
    await database.batch((batch) {
      batch.insertAll(database.challenges, [
        _challenge(
          id: 'eat_donut',
          tab: 'earn',
          title: 'Eat 4 Coco donuts',
          progress: 4,
          target: 4,
          sortOrder: 0,
          artStyle: 'donut_quarters',
          image: 'assets/images/challenge_items/challenge_item_donut.png',
        ),
        _challenge(
          id: 'drink_coffee',
          tab: 'earn',
          title: 'Drink 12 Americanos',
          progress: 9,
          target: 12,
          sortOrder: 1,
          artStyle: 'coffee_arc',
          image: AppImages.challengeItemCoffee,
        ),
        _challenge(
          id: 'gift_challenge',
          tab: 'gift',
          title: 'Send a donut gift',
          progress: 0,
          target: 1,
          sortOrder: 0,
          artStyle: 'donut_quarters',
          image: 'assets/images/challenge_items/challenge_item_donut.png',
        ),
      ]);
    });
  });

  tearDown(() => database.close());

  testWidgets('shows data-backed member tier, points, and challenges', (
    tester,
  ) async {
    await _pumpRewardsScreen(tester, database);

    expect(find.text('J’ Donuts Rewards'), findsOneWidget);
    expect(find.text('350,000'), findsOneWidget);
    expect(find.text('Bronze'), findsOneWidget);
    final pointsRing = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is RewardsRingPainter,
      ),
    );
    expect(
      (pointsRing.painter! as RewardsRingPainter).progress,
      closeTo(0.7, 0.001),
    );
    final tierLadder = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is TierLadderPainter,
      ),
    );
    final ladderPainter = tierLadder.painter! as TierLadderPainter;
    expect(ladderPainter.progress, closeTo(0.7, 0.001));
    expect(
      ladderPainter.progress,
      (pointsRing.painter! as RewardsRingPainter).progress,
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Eat 4 Coco donuts'), findsOneWidget);
    expect(find.text('Drink 12 Americanos'), findsOneWidget);
    expect(find.text('EARN'), findsNWidgets(2));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                AppImages.challengeItemCoffee,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is CoffeeProgressPainter,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Earn button gives visual feedback without awarding points', (
    tester,
  ) async {
    await _pumpRewardsScreen(tester, database, disableAnimations: true);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
    await tester.pump();
    await tester.tap(find.text('EARN').first);
    await tester.pump();

    final member = await database.select(database.members).getSingle();
    expect(member.totalPoints, 350000);
    expect(
      (await (database.select(
        database.challenges,
      )..where((row) => row.id.equals('eat_donut'))).getSingle()).claimed,
      isFalse,
    );
  });

  testWidgets('shows the completed Bronze-to-Silver ladder progression', (
    tester,
  ) async {
    await (database.update(
      database.members,
    )..where((member) => member.id.equals('member'))).write(
      const MembersCompanion(
        tierId: Value('silver'),
        totalPoints: Value(500000),
      ),
    );
    await _pumpRewardsScreen(tester, database, disableAnimations: true);

    expect(find.text('500,000'), findsOneWidget);
    expect(find.text('Silver'), findsOneWidget);

    final ladder = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is TierLadderPainter,
      ),
    );
    final painter = ladder.painter! as TierLadderPainter;
    expect(painter.tierCount, 3);
    expect(painter.currentIndex, 0);
    expect(painter.progress, 0.7);
    final ring = tester.widget<CustomPaint>(
      find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is RewardsRingPainter,
      ),
    );
    expect((ring.painter! as RewardsRingPainter).progress, 0.7);
  });

  testWidgets('Gift tab is disabled and Earn challenges remain selected', (
    tester,
  ) async {
    await _pumpRewardsScreen(tester, database, disableAnimations: true);

    expect(
      find.ancestor(of: find.text('Gift'), matching: find.byType(InkWell)),
      findsNothing,
    );
    await tester.tap(find.text('Gift'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();

    expect(find.text('Eat 4 Coco donuts'), findsOneWidget);
    expect(find.text('Send a donut gift'), findsNothing);
  });
}

Future<void> _pumpRewardsScreen(
  WidgetTester tester,
  AppDatabase database, {
  bool disableAnimations = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: RewardsScreen(
          memberStore: database.memberDao as MemberStore,
          sessionStore: _SessionStore(),
          rewardsDao: RewardsDao(database),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 1250));
  await tester.pump(const Duration(milliseconds: 1250));
}

ChallengesCompanion _challenge({
  required String id,
  required String tab,
  required String title,
  required int progress,
  required int target,
  required int sortOrder,
  required String artStyle,
  required String image,
}) => ChallengesCompanion.insert(
  id: id,
  tab: tab,
  title: title,
  progress: progress,
  target: target,
  rewardPoints: 100,
  artStyle: artStyle,
  image: image,
  sortOrder: sortOrder,
);

class _SessionStore implements SessionStore {
  @override
  Future<String?> readUserId() async => 'user';

  @override
  Future<void> clear() async {}

  @override
  Future<void> writeUserId(String userId) async {}
}
