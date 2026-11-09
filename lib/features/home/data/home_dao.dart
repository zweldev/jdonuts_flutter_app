import 'package:drift/drift.dart';

import '../../../database/app_database.dart';

class HomeDao {
  const HomeDao(this.db);

  final AppDatabase db;

  Future<Product?> findProductById(String productId) => (db.select(
    db.products,
  )..where((row) => row.id.equals(productId))).getSingleOrNull();

  Future<List<Product>> loadSectionProducts(String sectionId) async {
    final items =
        await (db.select(db.sectionItems)
              ..where((row) => row.sectionId.equals(sectionId))
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    if (items.isEmpty) return const [];
    final products = await (db.select(
      db.products,
    )..where((row) => row.id.isIn(items.map((item) => item.productId)))).get();
    final productsById = {for (final product in products) product.id: product};
    return [for (final item in items) ?productsById[item.productId]];
  }

  Future<HomeCatalog> loadCatalog() async {
    final banners = await (db.select(
      db.banners,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final sections = await (db.select(
      db.sections,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final shops = await (db.select(
      db.shops,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();

    return HomeCatalog(
      banners: banners,
      sections: [for (final section in sections) HomeCatalogSection(section)],
      shops: shops,
    );
  }
}

class HomeCatalog {
  const HomeCatalog({
    required this.banners,
    required this.sections,
    required this.shops,
  });

  final List<DbBanner> banners;
  final List<HomeCatalogSection> sections;
  final List<DbShop> shops;

  static const empty = HomeCatalog(banners: [], sections: [], shops: []);
}

class HomeCatalogSection {
  const HomeCatalogSection(this.section, {this.products = const []});

  final DbSection section;
  final List<Product> products;
}
