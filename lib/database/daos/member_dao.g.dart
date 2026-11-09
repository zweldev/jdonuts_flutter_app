// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_dao.dart';

// ignore_for_file: type=lint
mixin _$MemberDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $TiersTable get tiers => attachedDatabase.tiers;
  $MembersTable get members => attachedDatabase.members;
  MemberDaoManager get managers => MemberDaoManager(this);
}

class MemberDaoManager {
  final _$MemberDaoMixin _db;
  MemberDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$TiersTableTableManager get tiers =>
      $$TiersTableTableManager(_db.attachedDatabase, _db.tiers);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db.attachedDatabase, _db.members);
}
