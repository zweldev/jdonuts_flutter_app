import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/constants/app_images.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/database/seed/seed_constants.dart';
import 'package:jdonuts_flutter_app/database/seed/seed_failure.dart';
import 'package:jdonuts_flutter_app/database/seed/seed_loader.dart';
import 'package:jdonuts_flutter_app/database/seed/seed_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase db;
  late FakeSeedSource source;
  late SeedLoader loader;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    source = FakeSeedSource(_seedRows());
    loader = SeedLoader(db, source, db.metaDao);
  });

  tearDown(() => db.close());

  test('first seed fills all catalog tables and writes its version', () async {
    await loader.seedIfNeeded();

    expect(await db.select(db.tiers).get(), hasLength(1));
    expect(await db.select(db.products).get(), hasLength(1));
    expect(await db.select(db.sections).get(), hasLength(1));
    expect(await db.select(db.banners).get(), hasLength(1));
    expect(await db.select(db.sectionItems).get(), hasLength(1));
    expect(await db.select(db.shops).get(), hasLength(1));
    expect(await db.select(db.challenges).get(), hasLength(1));
    expect(await db.metaDao.read(metaKeySeededVersion), '$currentSeedVersion');
  });

  test('second seed call is a no-op', () async {
    await loader.seedIfNeeded();
    final before = await _snapshot(db);
    final readsBeforeSecondCall = source.readCount;

    await loader.seedIfNeeded();

    expect(await _snapshot(db), before);
    expect(source.readCount, readsBeforeSecondCall);
  });

  test(
    'upserts seed changes without touching users, members, or cart',
    () async {
      await loader.seedIfNeeded();
      await _insertUserMemberAndCart(db);
      final userBefore = (await db.select(db.users).get()).single;
      final memberBefore = (await db.select(db.members).get()).single;
      final cartBefore = (await db.select(db.cartItems).get()).single;
      source.rows['products']!.single['name'] = 'Updated donut';
      await db.metaDao.write(metaKeySeededVersion, '0');

      await loader.seedIfNeeded();

      expect((await db.select(db.products).get()).single.name, 'Updated donut');
      expect((await db.select(db.users).get()).single, userBefore);
      expect((await db.select(db.members).get()).single, memberBefore);
      expect((await db.select(db.cartItems).get()).single, cartBefore);
    },
  );

  test(
    'foreign-key failure rolls back every table and the version flag',
    () async {
      source.rows['section_items']!.single['productId'] = 'missing_product';

      await expectLater(loader.seedIfNeeded(), throwsA(isA<Exception>()));

      expect(await db.select(db.tiers).get(), isEmpty);
      expect(await db.select(db.products).get(), isEmpty);
      expect(await db.select(db.sections).get(), isEmpty);
      expect(await db.metaDao.read(metaKeySeededVersion), isNull);
    },
  );

  test('malformed rows throw SeedFailure with the file and field', () async {
    source.rows['products']!.single.remove('imageUrl');

    await expectLater(
      loader.seedIfNeeded(),
      throwsA(
        isA<SeedFailure>()
            .having((failure) => failure.file, 'file', 'products.json')
            .having((failure) => failure.field, 'field', 'imageUrl'),
      ),
    );
    expect(await db.metaDao.read(metaKeySeededVersion), isNull);
  });

  test(
    'real bundled seeds satisfy schema, relationships, and asset paths',
    () async {
      await SeedLoader(db, const AssetSeedSource(), db.metaDao).seedIfNeeded();

      final tiers = await db.select(db.tiers).get();
      final products = await db.select(db.products).get();
      final sections = await db.select(db.sections).get();
      final sectionItems = await db.select(db.sectionItems).get();
      final shops = await db.select(db.shops).get();
      final silver = tiers.singleWhere((tier) => tier.id == 'silver');
      final gold = tiers.singleWhere((tier) => tier.id == 'gold');

      expect(tiers, hasLength(4));
      expect(
        products.singleWhere((product) => product.id == 'p_coconut').priceMmk,
        3200,
      );
      expect(shops, hasLength(4));
      expect(
        sections.where((section) => section.title == 'Seasonal specials'),
        hasLength(1),
      );
      expect(
        sectionItems.every(
          (item) => products.any((product) => product.id == item.productId),
        ),
        isTrue,
      );
      expect(silver.minPoints, lessThanOrEqualTo(680000));
      expect(gold.minPoints - 680000, 500);

      final imagePaths = <String>[
        ...products.map((product) => product.imageUrl),
        ...(await db.select(db.banners).get()).map((banner) => banner.image),
        ...shops.map((shop) => shop.image),
        ...(await db.select(db.challenges).get()).map(
          (challenge) => challenge.image,
        ),
      ];
      final knownImages = <String>{
        AppImages.challengeItemCoffee,
        AppImages.challengeItemDonut,
        AppImages.product1,
        AppImages.product2,
        AppImages.product3,
        AppImages.product4,
        AppImages.product5,
        AppImages.product6,
        AppImages.seasonalProduct1,
        AppImages.seasonalProduct2,
        AppImages.seasonalProduct3,
        AppImages.seasonalProduct4,
        AppImages.seasonalProduct5,
        AppImages.shop1,
        AppImages.shop2,
        AppImages.shop3,
      };
      expect(imagePaths, everyElement(startsWith('assets/images/')));
      expect(imagePaths, everyElement(isIn(knownImages)));
      expect(imagePaths.every((path) => File(path).existsSync()), isTrue);
    },
  );
}

class FakeSeedSource implements SeedSource {
  FakeSeedSource(this.rows);

  final Map<String, List<Map<String, dynamic>>> rows;
  int readCount = 0;

  @override
  Future<List<Map<String, dynamic>>> read(String name) async {
    readCount++;
    return rows[name]!;
  }
}

Map<String, List<Map<String, dynamic>>> _seedRows() => {
  'tiers': [
    {'id': 'silver', 'name': 'Silver', 'minPoints': 500000, 'sortOrder': 1},
  ],
  'products': [
    {
      'id': 'p_coconut',
      'code': 'JD022123',
      'name': 'Coconut Donut',
      'priceMmk': 3200,
      'isNew': true,
      'discountPercent': null,
      'imageUrl': AppImages.product1,
      'description': 'A coconut donut.',
    },
  ],
  'sections': [
    {'id': 'popular', 'title': 'Popular', 'sortOrder': 0},
  ],
  'banners': [
    {
      'id': 'banner_1',
      'badgeText': null,
      'title': 'Fresh donuts',
      'image': AppImages.shop1,
      'styleKey': 'cyan',
      'sortOrder': 0,
      'targetProductId': 'p_coconut',
    },
  ],
  'section_items': [
    {'sectionId': 'popular', 'productId': 'p_coconut', 'sortOrder': 0},
  ],
  'shops': [
    {
      'id': 'shop_1',
      'name': "J'Donut",
      'address': 'Yangon',
      'image': AppImages.shop1,
      'sortOrder': 0,
    },
  ],
  'challenges': [
    {
      'id': 'challenge_1',
      'tab': 'earn',
      'title': 'Eat a donut',
      'progress': 0,
      'target': 1,
      'rewardPoints': 100,
      'artStyle': 'donut_quarters',
      'image': AppImages.challengeItemDonut,
      'claimed': false,
      'sortOrder': 0,
    },
  ],
};

Future<Map<String, Object?>> _snapshot(AppDatabase db) async => {
  'tiers': (await db.select(db.tiers).get())
      .map((row) => row.toJson())
      .toList(),
  'products': (await db.select(db.products).get())
      .map((row) => row.toJson())
      .toList(),
  'sections': (await db.select(db.sections).get())
      .map((row) => row.toJson())
      .toList(),
  'banners': (await db.select(db.banners).get())
      .map((row) => row.toJson())
      .toList(),
  'sectionItems': (await db.select(db.sectionItems).get())
      .map((row) => row.toJson())
      .toList(),
  'shops': (await db.select(db.shops).get())
      .map((row) => row.toJson())
      .toList(),
  'challenges': (await db.select(db.challenges).get())
      .map((row) => row.toJson())
      .toList(),
  'version': await db.metaDao.read(metaKeySeededVersion),
};

Future<void> _insertUserMemberAndCart(AppDatabase db) async {
  await db
      .into(db.users)
      .insert(
        UsersCompanion.insert(
          id: 'user_1',
          phone: '+959123456789',
          firstName: 'Test',
          lastName: 'Member',
          dateOfBirth: DateTime(2000),
          createdAt: DateTime(2026),
        ),
      );
  await db
      .into(db.members)
      .insert(
        MembersCompanion.insert(
          id: 'member_1',
          userId: 'user_1',
          name: 'Test Member',
          tierId: 'silver',
          totalPoints: 680000,
        ),
      );
  await db
      .into(db.cartItems)
      .insert(
        CartItemsCompanion.insert(
          productId: 'p_coconut',
          quantity: 2,
          updatedAt: DateTime(2026),
        ),
      );
}
