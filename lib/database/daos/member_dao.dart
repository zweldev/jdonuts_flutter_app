import 'package:drift/drift.dart';

import '../../features/members/domain/entities/member.dart';
import '../../features/members/domain/repositories/member_store.dart';
import '../../features/members/domain/tier_progress.dart';
import '../app_database.dart';
import '../tables/members.dart';
import '../tables/tiers.dart';

part 'member_dao.g.dart';

@DriftAccessor(tables: [Members, Tiers])
class MemberDao extends DatabaseAccessor<AppDatabase>
    with _$MemberDaoMixin
    implements MemberStore {
  MemberDao(super.db);

  @override
  Future<Member?> findByUserId(String userId) async {
    final row = await (select(
      members,
    )..where((member) => member.userId.equals(userId))).getSingleOrNull();
    if (row == null) return null;
    final tierRows = await select(tiers).get();
    final tierProgress = calculateTierProgress(
      tierId: row.tierId,
      totalPoints: row.totalPoints,
      tiers: tierRows
          .map(
            (tier) => Tier(
              id: tier.id,
              name: tier.name,
              minPoints: tier.minPoints,
              sortOrder: tier.sortOrder,
            ),
          )
          .toList(),
    );
    return Member(
      id: row.id,
      userId: row.userId,
      name: row.name,
      tierId: row.tierId,
      totalPoints: row.totalPoints,
      rewardsBadgeCount: row.rewardsBadgeCount,
      tierProgress: tierProgress,
    );
  }
}
