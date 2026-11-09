import '../tier_progress.dart';

final class Member {
  const Member({
    required this.id,
    required this.userId,
    required this.name,
    required this.tierId,
    required this.totalPoints,
    required this.rewardsBadgeCount,
    required this.tierProgress,
  });

  final String id;
  final String userId;
  final String name;
  final String tierId;
  final int totalPoints;
  final int rewardsBadgeCount;
  final TierProgressResult tierProgress;
}
