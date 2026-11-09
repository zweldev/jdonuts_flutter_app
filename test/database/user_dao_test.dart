import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/features/members/domain/tier_progress.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/entities/auth_user.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test(
    'transaction inserts tier, user, and member and reads the member',
    () async {
      await database.transaction(() async {
        await _insertTier(database);
        await _insertUser(database);
        await _insertMember(database);
      });

      final member = await database.memberDao.findByUserId('user-1');
      expect(member?.id, 'member-1');
      expect(member?.tierId, 'bronze');
      expect(member?.totalPoints, 25);
      final tierProgress = member?.tierProgress;
      expect(tierProgress, isA<TierProgressSuccess>());
      expect(
        (tierProgress! as TierProgressSuccess).progress.pointsToNextTier,
        75,
      );
    },
  );

  test('register creates a Silver demo member for the new user', () async {
    await _insertTier(database, silverMinPoints: 500000);

    final userId = await database.userDao.register(
      AuthUser(
        phoneNumber: '+959251234567',
        firstName: 'New',
        lastName: 'Member',
        dateOfBirth: DateTime(2000, 5, 1),
      ),
    );

    final member = await database.memberDao.findByUserId(userId);
    expect(member?.name, 'New Member');
    expect(member?.tierId, 'silver');
    expect(member?.totalPoints, 500000);
    final tierProgress = member?.tierProgress as TierProgressSuccess;
    expect(tierProgress.progress.progressFraction, 0);
  });

  test('upgrades existing demo members to the Silver threshold', () async {
    final directory = await Directory.systemTemp.createTemp(
      'jdonuts-db-upgrade-',
    );
    final file = File('${directory.path}/v1.sqlite');
    final versionOne = AppDatabase.forTesting(NativeDatabase(file));
    var versionOneClosed = false;
    try {
      await _insertTier(versionOne, silverMinPoints: 500000);
      await _insertUser(versionOne);
      await versionOne
          .into(versionOne.members)
          .insert(
            MembersCompanion.insert(
              id: 'member-1',
              userId: 'user-1',
              name: 'Ye Min',
              tierId: 'bronze',
              totalPoints: 0,
            ),
          );
      await versionOne.customStatement('PRAGMA user_version = 1');
      await versionOne.close();
      versionOneClosed = true;

      final upgraded = AppDatabase.forTesting(NativeDatabase(file));
      try {
        final member = (await upgraded.select(upgraded.members).get()).single;
        expect(upgraded.schemaVersion, 3);
        expect(member.tierId, 'silver');
        expect(member.totalPoints, 500000);
      } finally {
        await upgraded.close();
      }
    } finally {
      if (!versionOneClosed) await versionOne.close();
      await directory.delete(recursive: true);
    }
  });

  test('member insertion rejects unknown tier and user IDs', () async {
    await _insertTier(database);
    await _insertUser(database);

    await expectLater(
      _insertMember(database, tierId: 'unknown'),
      throwsA(isA<Exception>()),
    );
    await expectLater(
      _insertMember(database, userId: 'unknown'),
      throwsA(isA<Exception>()),
    );
  });

  test('cart rejects quantity zero', () async {
    await _insertProduct(database);

    await expectLater(
      database
          .into(database.cartItems)
          .insert(
            CartItemsCompanion.insert(
              productId: 'product-1',
              quantity: 0,
              updatedAt: DateTime(2026),
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('members table does not store points to next tier', () async {
    await database.customSelect('SELECT 1').getSingle();

    final columns = await database
        .customSelect('PRAGMA table_info(members)')
        .get();

    expect(
      columns.map((row) => row.read<String>('name')),
      isNot(contains('points_to_next_tier')),
    );
  });

  test('fresh database creates all tables at schema version three', () async {
    await database.customSelect('SELECT 1').getSingle();

    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('meta_entries', 'tiers', 'products', 'sections', "
          "'banners', 'section_items', 'shops', 'challenges', 'users', "
          "'members', 'cart_items')",
        )
        .get();

    expect(tables, hasLength(11));
    expect(database.schemaVersion, 3);
  });

  test('products persist their catalog fields', () async {
    await _insertProduct(database);

    final product = (await database.select(database.products).get()).single;
    expect(product.id, 'product-1');
    expect(product.code, 'JD022123');
    expect(product.name, 'Coconut Donut');
    expect(product.priceMmk, 3200);
    expect(product.isNew, isTrue);
    expect(product.discountPercent, isNull);
    expect(product.imageUrl, 'https://example.com/coconut.jpg');
    expect(product.description, 'Enjoy our scrumptious donuts.');
  });
}

Future<void> _insertTier(
  AppDatabase database, {
  int silverMinPoints = 100,
}) async {
  await database
      .into(database.tiers)
      .insert(
        TiersCompanion.insert(
          id: 'bronze',
          name: 'Bronze',
          minPoints: 0,
          sortOrder: 0,
        ),
      );
  await database
      .into(database.tiers)
      .insert(
        TiersCompanion.insert(
          id: 'silver',
          name: 'Silver',
          minPoints: silverMinPoints,
          sortOrder: 1,
        ),
      );
  await database
      .into(database.tiers)
      .insert(
        TiersCompanion.insert(
          id: 'gold',
          name: 'Gold',
          minPoints: 680500,
          sortOrder: 2,
        ),
      );
}

Future<void> _insertUser(AppDatabase database) => database
    .into(database.users)
    .insert(
      UsersCompanion.insert(
        id: 'user-1',
        phone: '+959254135592',
        firstName: 'Ye',
        lastName: 'Min',
        dateOfBirth: DateTime(2000, 5, 1),
        createdAt: DateTime(2026),
      ),
    );

Future<void> _insertMember(
  AppDatabase database, {
  String userId = 'user-1',
  String tierId = 'bronze',
}) => database
    .into(database.members)
    .insert(
      MembersCompanion.insert(
        id: 'member-1',
        userId: userId,
        name: 'Ye Min',
        tierId: tierId,
        totalPoints: 25,
      ),
    );

Future<void> _insertProduct(AppDatabase database) => database
    .into(database.products)
    .insert(
      ProductsCompanion.insert(
        id: 'product-1',
        code: 'JD022123',
        name: 'Coconut Donut',
        priceMmk: 3200,
        isNew: true,
        imageUrl: 'https://example.com/coconut.jpg',
        description: 'Enjoy our scrumptious donuts.',
      ),
    );
