import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/auth_constants.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/session_store.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/user_store.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/result.dart';

void main() {
  const phone = '+959254135592';
  final user = AuthUser(
    phoneNumber: phone,
    firstName: 'Ye Min',
    lastName: '',
    dateOfBirth: DateTime(2000, 5, 1),
  );

  test('restore clears a session when its user no longer exists', () async {
    final users = _MemoryUserStore();
    final session = _MemorySessionStore()..phone = phone;
    final repository = FakeAuthRepository(
      userStore: users,
      sessionStore: session,
      latency: Duration.zero,
    );

    expect((await repository.restoreSession() as Success<bool>).value, isFalse);
    expect(session.phone, isNull);
  });

  test('restore accepts a session for an existing user', () async {
    final users = _MemoryUserStore()..addUser(user, id: 'user-1');
    final session = _MemorySessionStore()..phone = 'user-1';
    final repository = FakeAuthRepository(
      userStore: users,
      sessionStore: session,
      latency: Duration.zero,
    );

    expect((await repository.restoreSession() as Success<bool>).value, isTrue);
    expect(session.phone, 'user-1');
  });

  test('OTP request succeeds without checking the user store', () async {
    final repository = _repository(users: {phone: user});

    final result = await repository.requestOtp();

    expect(result, isA<Success<void>>());
  });

  test('register does not replace an existing user', () async {
    final users = _MemoryUserStore()..addUser(user, id: 'user-1');
    final repository = FakeAuthRepository(
      userStore: users,
      sessionStore: _MemorySessionStore(),
      latency: Duration.zero,
    );

    final result = await repository.register(user.copyWith(firstName: 'Other'));

    expect((result as Failure<void>).error, isA<AlreadyRegistered>());
    expect(
      (await users.findByPhone(phone))?.copyWith(id: null),
      user,
    );
  });

  test('login finds no user only after OTP verification', () async {
    final repository = _repository();

    expect(await repository.requestOtp(), isA<Success<void>>());
    expect(
      await repository.verifyOtp(phone, fakeOtpCode),
      isA<Success<void>>(),
    );
    final result = await repository.signIn(phone);

    expect((result as Failure<AuthUser>).error, isA<UserNotFound>());
  });

  test('sign out clears the session and keeps the user', () async {
    final users = _MemoryUserStore()..addUser(user, id: 'user-1');
    final session = _MemorySessionStore()..phone = 'user-1';
    final repository = FakeAuthRepository(
      userStore: users,
      sessionStore: session,
      latency: Duration.zero,
    );

    expect(await repository.signOut(), isA<Success<void>>());
    expect(await session.readUserId(), isNull);
    expect((await users.findByPhone(phone))?.phoneNumber, phone);
  });
}

FakeAuthRepository _repository({
  Map<String, AuthUser> users = const {},
  String? sessionPhone,
}) {
  final userStore = _MemoryUserStore();
  for (final (index, user) in users.values.indexed) {
    userStore.addUser(user, id: 'user-${index + 1}');
  }
  return FakeAuthRepository(
    userStore: userStore,
    sessionStore: _MemorySessionStore()..phone = sessionPhone,
    latency: Duration.zero,
  );
}

class _MemoryUserStore implements UserStore {
  final Map<String, AuthUser> _usersById = {};
  final Map<String, AuthUser> _usersByPhone = {};

  void addUser(AuthUser user, {required String id}) {
    final storedUser = user.copyWith(id: id);
    _usersById[id] = storedUser;
    _usersByPhone[user.phoneNumber] = storedUser;
  }

  @override
  Future<AuthUser?> findById(String userId) async => _usersById[userId];

  @override
  Future<AuthUser?> findByPhone(String phoneNumber) async =>
      _usersByPhone[phoneNumber];

  @override
  Future<String> register(AuthUser user) async {
    if (_usersByPhone.containsKey(user.phoneNumber)) {
      throw const AlreadyRegisteredException();
    }
    final id = 'user-${_usersById.length + 1}';
    addUser(user, id: id);
    return id;
  }
}

class _MemorySessionStore implements SessionStore {
  String? phone;

  @override
  Future<String?> readUserId() async => phone;

  @override
  Future<void> writeUserId(String userId) async => phone = userId;

  @override
  Future<void> clear() async => phone = null;
}
