import '../entities/auth_user.dart';
import '../result.dart';

abstract interface class AuthRepository {
  Future<Result<bool>> restoreSession();
  Future<Result<void>> requestOtp();
  Future<Result<void>> verifyOtp(String phoneNumber, String code);
  Future<Result<AuthUser>> signIn(String phoneNumber);
  Future<Result<void>> register(AuthUser user);
  Future<Result<void>> signOut();
}
