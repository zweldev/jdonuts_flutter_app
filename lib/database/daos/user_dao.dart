import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/domain/entities/auth_user.dart';
import '../../features/auth/domain/repositories/user_store.dart';
import '../../features/auth/domain/validators/auth_validators.dart';
import '../app_database.dart';
import '../tables/users.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase>
    with _$UserDaoMixin
    implements UserStore {
  UserDao(super.db);

  static const _uuid = Uuid();

  @override
  Future<AuthUser?> findById(String userId) async {
    final row = await (select(
      users,
    )..where((user) => user.id.equals(userId))).getSingleOrNull();
    return row == null ? null : _toAuthUser(row);
  }

  @override
  Future<AuthUser?> findByPhone(String phoneNumber) async {
    final row =
        await (select(users)..where(
              (user) => user.phone.equals(canonicalPhoneNumber(phoneNumber)),
            ))
            .getSingleOrNull();
    return row == null ? null : _toAuthUser(row);
  }

  AuthUser _toAuthUser(User row) => AuthUser(
    id: row.id,
    phoneNumber: row.phone,
    firstName: row.firstName,
    lastName: row.lastName,
    dateOfBirth: row.dateOfBirth,
  );

  @override
  Future<String> register(AuthUser user) async {
    final phone = canonicalPhoneNumber(user.phoneNumber);
    return transaction(() async {
      final existing = await (select(
        users,
      )..where((row) => row.phone.equals(phone))).getSingleOrNull();
      if (existing != null) throw const AlreadyRegisteredException();
      final userId = _uuid.v4();
      await into(users).insert(
        UsersCompanion.insert(
          id: userId,
          phone: phone,
          firstName: user.firstName,
          lastName: user.lastName,
          dateOfBirth: user.dateOfBirth,
          createdAt: DateTime.now(),
        ),
      );
      await into(db.members).insert(
        MembersCompanion.insert(
          id: _uuid.v4(),
          userId: userId,
          name: [
            user.firstName.trim(),
            user.lastName.trim(),
          ].where((part) => part.isNotEmpty).join(' '),
          tierId: 'bronze',
          totalPoints: 0,
        ),
      );
      return userId;
    });
  }
}
