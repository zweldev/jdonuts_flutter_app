import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/database/app_database.dart';
import 'package:jdonuts_flutter_app/features/home/data/home_dao.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  test(
    'catalog groups and orders products by section item sort order',
    () async {
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
          .into(database.sections)
          .insert(
            SectionsCompanion.insert(
              id: 'popular',
              title: 'Popular',
              sortOrder: 0,
            ),
          );
      await _insertProduct(database, id: 'first', code: 'JD000001');
      await _insertProduct(database, id: 'second', code: 'JD000002');
      await database
          .into(database.sectionItems)
          .insert(
            SectionItemsCompanion.insert(
              sectionId: 'popular',
              productId: 'second',
              sortOrder: 1,
            ),
          );
      await database
          .into(database.sectionItems)
          .insert(
            SectionItemsCompanion.insert(
              sectionId: 'popular',
              productId: 'first',
              sortOrder: 0,
            ),
          );

      final catalog = await HomeDao(database).loadCatalog();

      expect(catalog.sections, hasLength(1));
      final products = await HomeDao(database)
          .loadSectionProducts(catalog.sections.single.section.id);
      expect(products.map((product) => product.id), ['first', 'second']);
      expect(
        (await HomeDao(database).findProductById('first'))?.code,
        'JD000001',
      );
      expect(await HomeDao(database).findProductById('missing'), isNull);
    },
  );
}

Future<void> _insertProduct(
  AppDatabase database, {
  required String id,
  required String code,
}) => database
    .into(database.products)
    .insert(
      ProductsCompanion.insert(
        id: id,
        code: code,
        name: id,
        priceMmk: 2500,
        isNew: false,
        imageUrl: 'assets/images/products/product_1.png',
        description: 'Test product',
      ),
    );
