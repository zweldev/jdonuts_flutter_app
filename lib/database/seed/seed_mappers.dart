import 'package:drift/drift.dart';

import '../app_database.dart';
import 'seed_failure.dart';

T _field<T>(
  Map<String, dynamic> row,
  String name,
  String file,
  T Function(Object?) cast,
) {
  if (!row.containsKey(name)) throw SeedFailure(file, name);
  try {
    return cast(row[name]);
  } on TypeError catch (error) {
    throw SeedFailure(file, name, error);
  }
}

String _string(Map<String, dynamic> row, String name, String file) =>
    _field(row, name, file, (value) => value as String);

int _int(Map<String, dynamic> row, String name, String file) =>
    _field(row, name, file, (value) => value as int);

bool _bool(Map<String, dynamic> row, String name, String file) =>
    _field(row, name, file, (value) => value as bool);

int? _nullableInt(Map<String, dynamic> row, String name, String file) =>
    _field(row, name, file, (value) => value as int?);

String? _nullableString(Map<String, dynamic> row, String name, String file) =>
    _field(row, name, file, (value) => value as String?);

TiersCompanion mapTier(Map<String, dynamic> row) => TiersCompanion.insert(
  id: _string(row, 'id', 'tiers.json'),
  name: _string(row, 'name', 'tiers.json'),
  minPoints: _int(row, 'minPoints', 'tiers.json'),
  sortOrder: _int(row, 'sortOrder', 'tiers.json'),
);

ProductsCompanion mapProduct(Map<String, dynamic> row) =>
    ProductsCompanion.insert(
      id: _string(row, 'id', 'products.json'),
      code: _string(row, 'code', 'products.json'),
      name: _string(row, 'name', 'products.json'),
      priceMmk: _int(row, 'priceMmk', 'products.json'),
      isNew: _bool(row, 'isNew', 'products.json'),
      discountPercent: Value(
        _nullableInt(row, 'discountPercent', 'products.json'),
      ),
      imageUrl: _string(row, 'imageUrl', 'products.json'),
      description: _string(row, 'description', 'products.json'),
    );

SectionsCompanion mapSection(Map<String, dynamic> row) =>
    SectionsCompanion.insert(
      id: _string(row, 'id', 'sections.json'),
      title: _string(row, 'title', 'sections.json'),
      sortOrder: _int(row, 'sortOrder', 'sections.json'),
    );

BannersCompanion mapBanner(Map<String, dynamic> row) => BannersCompanion.insert(
  id: _string(row, 'id', 'banners.json'),
  badgeText: Value(_nullableString(row, 'badgeText', 'banners.json')),
  title: _string(row, 'title', 'banners.json'),
  image: _string(row, 'image', 'banners.json'),
  styleKey: _string(row, 'styleKey', 'banners.json'),
  sortOrder: _int(row, 'sortOrder', 'banners.json'),
  targetProductId: Value(
    _nullableString(row, 'targetProductId', 'banners.json'),
  ),
);

SectionItemsCompanion mapSectionItem(Map<String, dynamic> row) =>
    SectionItemsCompanion.insert(
      sectionId: _string(row, 'sectionId', 'section_items.json'),
      productId: _string(row, 'productId', 'section_items.json'),
      sortOrder: _int(row, 'sortOrder', 'section_items.json'),
    );

ShopsCompanion mapShop(Map<String, dynamic> row) => ShopsCompanion.insert(
  id: _string(row, 'id', 'shops.json'),
  name: _string(row, 'name', 'shops.json'),
  address: _string(row, 'address', 'shops.json'),
  image: _string(row, 'image', 'shops.json'),
  sortOrder: _int(row, 'sortOrder', 'shops.json'),
);

ChallengesCompanion mapChallenge(Map<String, dynamic> row) =>
    ChallengesCompanion.insert(
      id: _string(row, 'id', 'challenges.json'),
      tab: _string(row, 'tab', 'challenges.json'),
      title: _string(row, 'title', 'challenges.json'),
      progress: _int(row, 'progress', 'challenges.json'),
      target: _int(row, 'target', 'challenges.json'),
      rewardPoints: _int(row, 'rewardPoints', 'challenges.json'),
      artStyle: _string(row, 'artStyle', 'challenges.json'),
      image: _string(row, 'image', 'challenges.json'),
      claimed: Value(_bool(row, 'claimed', 'challenges.json')),
      sortOrder: _int(row, 'sortOrder', 'challenges.json'),
    );
