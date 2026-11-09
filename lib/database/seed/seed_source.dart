import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'seed_failure.dart';

abstract interface class SeedSource {
  Future<List<Map<String, dynamic>>> read(String name);
}

final class AssetSeedSource implements SeedSource {
  const AssetSeedSource();

  @override
  Future<List<Map<String, dynamic>>> read(String name) async {
    final String contents;
    try {
      contents = await rootBundle.loadString('assets/seed/$name.json');
    } on FlutterError catch (error) {
      throw SeedFailure('$name.json', r'$asset', error);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(contents);
    } on FormatException catch (error) {
      throw SeedFailure('$name.json', r'$json', error);
    }
    if (decoded is! List<dynamic>) {
      throw SeedFailure('$name.json', r'$');
    }
    return [
      for (var index = 0; index < decoded.length; index++)
        _asRow(decoded[index], name, index),
    ];
  }

  Map<String, dynamic> _asRow(Object? value, String name, int index) {
    if (value is Map<String, dynamic>) return value;
    throw SeedFailure('$name.json', '\$$index');
  }
}
