import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/auth_constants.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/result.dart';

abstract interface class AuthStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class FlutterSecureAuthStorage implements AuthStorage {
  FlutterSecureAuthStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.latency = const Duration(seconds: 1),
    AuthStorage? storage,
  }) : _storage = storage ?? FlutterSecureAuthStorage();

  static const _usersKey = 'jdonuts.users';
  static const _sessionKey = 'jdonuts.session';

  final Duration latency;
  final AuthStorage _storage;
  final Map<String, ({String firstName, String lastName})> _registrationNames =
      {};

  Future<void> _wait() => Future<void>.delayed(latency);

  Future<List<AuthUser>> _readUsers() async {
    final json = await _read(_usersKey);
    if (json == null) {
      return [];
    }

    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded.map((user) {
      if (user is! Map<String, dynamic>) {
        throw const FormatException('Stored user must be a JSON object.');
      }
      return AuthUser.fromJson(user);
    }).toList();
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on _UserNotFoundException {
      return const Failure(UserNotFound());
    } on _InvalidOtpException {
      return const Failure(InvalidOtp());
    } on _StorageException catch (error) {
      return Failure(StorageFailure(error.cause));
    } on FormatException catch (error) {
      return Failure(StorageFailure(error));
    } on Exception catch (error) {
      return Failure(UnknownFailure(error));
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key);
    } on Exception catch (error) {
      throw _StorageException(error);
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key, value);
    } on Exception catch (error) {
      throw _StorageException(error);
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key);
    } on Exception catch (error) {
      throw _StorageException(error);
    }
  }

  @override
  Future<Result<bool>> restoreSession() => _guard(() async {
    final phoneNumber = await _read(_sessionKey);
    if (phoneNumber == null) return false;
    final users = await _readUsers();
    if (users.any((user) => user.phoneNumber == phoneNumber)) return true;
    await _delete(_sessionKey);
    return false;
  });

  @override
  Future<Result<void>> requestOtp(
    String phoneNumber, {
    required bool isRegistration,
  }) => _guard(() async {
    await _wait();
    if (!isRegistration) {
      final users = await _readUsers();
      if (!users.any((user) => user.phoneNumber == phoneNumber)) {
        throw const _UserNotFoundException();
      }
    }
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
    final users = await _readUsers();
    final matches = users.where(
      (account) => account.phoneNumber == phoneNumber,
    );
    if (matches.isEmpty) throw const _UserNotFoundException();
    final user = matches.first;
    await _write(_sessionKey, phoneNumber);
    return user;
  });

  @override
  Future<Result<void>> saveRegistrationName(
    String phoneNumber, {
    required String firstName,
    required String lastName,
  }) => _guard(() async {
    await _wait();
    _registrationNames[phoneNumber] = (
      firstName: firstName,
      lastName: lastName,
    );
  });

  @override
  Future<Result<void>> register(AuthUser user) => _guard(() async {
    await _wait();
    final users = await _readUsers();
    users.removeWhere((account) => account.phoneNumber == user.phoneNumber);
    users.add(user);
    await _write(
      _usersKey,
      jsonEncode(users.map((account) => account.toJson()).toList()),
    );
    await _write(_sessionKey, user.phoneNumber);
    _registrationNames.remove(user.phoneNumber);
  });

  @override
  Future<Result<void>> signOut() => _guard(() => _delete(_sessionKey));
}

final class _StorageException implements Exception {
  const _StorageException(this.cause);

  final Object cause;
}

final class _UserNotFoundException implements Exception {
  const _UserNotFoundException();
}

final class _InvalidOtpException implements Exception {
  const _InvalidOtpException();
}
