import '../entities/auth_user.dart';

abstract interface class UserStore {
  Future<AuthUser?> findById(String userId);
  Future<AuthUser?> findByPhone(String phoneNumber);
  Future<String> register(AuthUser user);
}

final class AlreadyRegisteredException implements Exception {
  const AlreadyRegisteredException();
}
