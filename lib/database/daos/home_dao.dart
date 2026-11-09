import 'package:drift/drift.dart';

import '../app_database.dart';

class HomeDao {
  const HomeDao(this.db);

  final AppDatabase db;

  Future<HomeCatalog> loadCatalog() async {
    final banners = await (db.select(
      db.banners,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final sections = await (db.select(
      db.sections,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final items = await (db.select(
      db.sectionItems,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final products = await db.select(db.products).get();
    final shops = await (db.select(
      db.shops,
    )..orderBy([(row) => OrderingTerm.asc(row.sortOrder)])).get();
    final productsById = {for (final product in products) product.id: product};

    return HomeCatalog(
      banners: banners,
      sections: [
        for (final section in sections)
          HomeCatalogSection(
            section,
            items
                .where((item) => item.sectionId == section.id)
                .map((item) => productsById[item.productId])
                .whereType<Product>()
                .toList(growable: false),
          ),
      ],
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
  const HomeCatalogSection(this.section, this.products);

  final DbSection section;
  final List<Product> products;
}
