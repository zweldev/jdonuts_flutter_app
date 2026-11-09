import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/session_store.dart';

class SecureSessionStore implements SessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const sessionKey = 'jdonuts.session';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> readUserId() => _storage.read(key: sessionKey);

  @override
  Future<void> writeUserId(String userId) =>
      _storage.write(key: sessionKey, value: userId);

  @override
  Future<void> clear() => _storage.delete(key: sessionKey);
}
