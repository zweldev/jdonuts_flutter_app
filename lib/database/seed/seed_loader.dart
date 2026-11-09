import '../app_database.dart';
import '../daos/meta_dao.dart';
import 'seed_constants.dart';
import 'seed_failure.dart';
import 'seed_mappers.dart';
import 'seed_source.dart';

class SeedLoader {
  const SeedLoader(this.db, this.source, this.metaDao);

  final AppDatabase db;
  final SeedSource source;
  final MetaDao metaDao;

  Future<void> seedIfNeeded() async {
    if (await _isSeeded()) return;
    await _writeSeed(await _readSeed());
  }

  Future<bool> _isSeeded() async {
    final storedVersion = await metaDao.read(metaKeySeededVersion);
    if (storedVersion == null) return false;
    final parsedVersion = int.tryParse(storedVersion);
    if (parsedVersion == null) {
      throw SeedFailure('meta_entries', metaKeySeededVersion);
    }
    return parsedVersion >= currentSeedVersion;
  }

  Future<_SeedData> _readSeed() async => _SeedData(
    tiers: await _read(seedTiersFile, mapTier),
    products: await _read(seedProductsFile, mapProduct),
    sections: await _read(seedSectionsFile, mapSection),
    banners: await _read(seedBannersFile, mapBanner),
    sectionItems: await _read(seedSectionItemsFile, mapSectionItem),
    shops: await _read(seedShopsFile, mapShop),
    challenges: await _read(seedChallengesFile, mapChallenge),
  );

  Future<void> _writeSeed(_SeedData seed) async {
    await db.transaction(() async {
      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(db.tiers, seed.tiers);
        batch.insertAllOnConflictUpdate(db.products, seed.products);
        batch.insertAllOnConflictUpdate(db.sections, seed.sections);
        batch.insertAllOnConflictUpdate(db.banners, seed.banners);
        batch.insertAllOnConflictUpdate(db.sectionItems, seed.sectionItems);
        batch.insertAllOnConflictUpdate(db.shops, seed.shops);
        batch.insertAllOnConflictUpdate(db.challenges, seed.challenges);
      });
      await metaDao.write(metaKeySeededVersion, '$currentSeedVersion');
    });
  }

  Future<List<T>> _read<T>(
    String name,
    T Function(Map<String, dynamic>) mapper,
  ) async {
    final rows = await source.read(name);
    return rows.map(mapper).toList(growable: false);
  }
}

class _SeedData {
  const _SeedData({
    required this.tiers,
    required this.products,
    required this.sections,
    required this.banners,
    required this.sectionItems,
    required this.shops,
    required this.challenges,
  });

  final List<TiersCompanion> tiers;
  final List<ProductsCompanion> products;
  final List<SectionsCompanion> sections;
  final List<BannersCompanion> banners;
  final List<SectionItemsCompanion> sectionItems;
  final List<ShopsCompanion> shops;
  final List<ChallengesCompanion> challenges;
}
