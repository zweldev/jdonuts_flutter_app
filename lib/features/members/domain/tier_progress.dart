import 'dart:math' as math;

final class Tier {
  const Tier({
    required this.id,
    required this.name,
    required this.minPoints,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final int minPoints;
  final int sortOrder;
}

final class TierProgress {
  const TierProgress({
    required this.currentTier,
    required this.nextTier,
    required this.pointsToNextTier,
    required this.progressFraction,
  });

  final Tier currentTier;
  final Tier? nextTier;
  final int? pointsToNextTier;
  final double progressFraction;
}

sealed class TierProgressResult {
  const TierProgressResult();
}

final class TierProgressSuccess extends TierProgressResult {
  const TierProgressSuccess(this.progress);

  final TierProgress progress;
}

final class TierProgressFailure extends TierProgressResult {
  const TierProgressFailure(this.tierId);

  final String tierId;
}

TierProgressResult calculateTierProgress({
  required String tierId,
  required int totalPoints,
  required List<Tier> tiers,
}) {
  final orderedTiers = [...tiers]
    ..sort((left, right) {
      final order = left.sortOrder.compareTo(right.sortOrder);
      return order == 0 ? left.id.compareTo(right.id) : order;
    });
  final currentIndex = orderedTiers.indexWhere((tier) => tier.id == tierId);
  if (currentIndex < 0) return TierProgressFailure(tierId);

  final currentTier = orderedTiers[currentIndex];
  final nextTier = _nextTier(orderedTiers, currentTier);
  return TierProgressSuccess(
    TierProgress(
      currentTier: currentTier,
      nextTier: nextTier,
      pointsToNextTier: _pointsToNextTier(nextTier, totalPoints),
      progressFraction: _progressFraction(currentTier, nextTier, totalPoints),
    ),
  );
}

Tier? _nextTier(List<Tier> tiers, Tier currentTier) {
  for (final tier in tiers) {
    if (tier.sortOrder > currentTier.sortOrder) return tier;
  }
  return null;
}

int? _pointsToNextTier(Tier? nextTier, int totalPoints) {
  if (nextTier == null) return null;
  return math.max(0, nextTier.minPoints - totalPoints);
}

double _progressFraction(Tier currentTier, Tier? nextTier, int totalPoints) {
  if (nextTier == null) return 1;
  final pointRange = nextTier.minPoints - currentTier.minPoints;
  if (pointRange <= 0) {
    return totalPoints >= nextTier.minPoints ? 1 : 0;
  }
  return ((totalPoints - currentTier.minPoints) / pointRange)
      .clamp(0, 1)
      .toDouble();
}
