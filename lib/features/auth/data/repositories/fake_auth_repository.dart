import '../../domain/auth_constants.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/session_store.dart';
import '../../domain/repositories/user_store.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    required this._userStore,
    required this._sessionStore,
    this.latency = fakeAuthLatency,
  });

  final UserStore _userStore;
  final SessionStore _sessionStore;
  final Duration latency;

  Future<void> _wait() => Future<void>.delayed(latency);

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on AlreadyRegisteredException {
      return const Failure(AlreadyRegistered());
    } on _UserNotFoundException {
      return const Failure(UserNotFound());
    } on _InvalidOtpException {
      return const Failure(InvalidOtp());
    } on Exception catch (error) {
      return Failure(StorageFailure(error));
    } on Object catch (error) {
      return Failure(UnknownFailure(error));
    }
  }

  @override
  Future<Result<bool>> restoreSession() => _guard(() async {
    final userId = await _sessionStore.readUserId();
    if (userId == null) return false;
    if (await _userStore.findById(userId) != null) return true;
    await _sessionStore.clear();
    return false;
  });

  @override
  Future<Result<void>> requestOtp() => _guard(() async {
    await _wait();
  });

  @override
  Future<Result<void>> verifyOtp(String phoneNumber, String code) =>
      _guard(() async {
        await _wait();
        if (code != fakeOtpCode) throw const _InvalidOtpException();
      });

  @override
  Future<Result<AuthUser>> signIn(String phoneNumber) => _guard(() async {
    await _wait();
    final normalizedPhone = canonicalPhoneNumber(phoneNumber);
    final user = await _userStore.findByPhone(normalizedPhone);
    if (user == null) throw const _UserNotFoundException();
    final userId = user.id;
    if (userId == null) throw const _UserNotFoundException();
    await _sessionStore.writeUserId(userId);
    return user;
  });

  @override
  Future<Result<void>> register(AuthUser user) => _guard(() async {
    await _wait();
    final normalizedUser = user.copyWith(
      phoneNumber: canonicalPhoneNumber(user.phoneNumber),
    );
    final userId = await _userStore.register(normalizedUser);
    await _sessionStore.writeUserId(userId);
  });

  @override
  Future<Result<void>> signOut() => _guard(_sessionStore.clear);
}

final class _UserNotFoundException implements Exception {
  const _UserNotFoundException();
}

final class _InvalidOtpException implements Exception {
  const _InvalidOtpException();
}
