import '../entities/member.dart';

abstract interface class MemberStore {
  Future<Member?> findByUserId(String userId);
}
