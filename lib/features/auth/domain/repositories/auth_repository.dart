import '../entities/auth_user.dart';
import '../result.dart';

abstract interface class AuthRepository {
  Future<Result<bool>> restoreSession();
  Future<Result<void>> requestOtp(
    String phoneNumber, {
    required bool isRegistration,
  });
  Future<Result<void>> verifyOtp(String phoneNumber, String code);
  Future<Result<AuthUser>> signIn(String phoneNumber);
  Future<Result<void>> saveRegistrationName(
    String phoneNumber, {
    required String firstName,
    required String lastName,
  });
  Future<Result<void>> register(AuthUser user);
  Future<Result<void>> signOut();
}
