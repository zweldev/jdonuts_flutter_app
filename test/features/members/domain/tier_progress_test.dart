import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/features/members/domain/tier_progress.dart';

void main() {
  final tiers = [
    const Tier(id: 'bronze', name: 'Bronze', minPoints: 0, sortOrder: 0),
    const Tier(id: 'silver', name: 'Silver', minPoints: 500, sortOrder: 1),
    const Tier(id: 'gold', name: 'Gold', minPoints: 1000, sortOrder: 2),
    const Tier(id: 'platinum', name: 'Platinum', minPoints: 1500, sortOrder: 3),
  ];

  test('middle tier computes remaining points and progress fraction', () {
    final progress = _success('silver', 700, tiers);

    expect(progress.currentTier.id, 'silver');
    expect(progress.nextTier?.id, 'gold');
    expect(progress.pointsToNextTier, 300);
    expect(progress.progressFraction, 0.4);
  });

  test('points exactly at next threshold complete the tier', () {
    final progress = _success('silver', 1000, tiers);

    expect(progress.pointsToNextTier, 0);
    expect(progress.progressFraction, 1);
  });

  test('points above next threshold clamp progress and remaining points', () {
    final progress = _success('silver', 1200, tiers);

    expect(progress.pointsToNextTier, 0);
    expect(progress.progressFraction, 1);
  });

  test('top tier has no next tier or remaining points', () {
    final progress = _success('platinum', 1800, tiers);

    expect(progress.nextTier, isNull);
    expect(progress.pointsToNextTier, isNull);
    expect(progress.progressFraction, 1);
  });

  test('unsorted tiers produce the same progress as sorted tiers', () {
    final sorted = _success('silver', 700, tiers);
    final unsorted = _success('silver', 700, tiers.reversed.toList());

    expect(unsorted.currentTier, sorted.currentTier);
    expect(unsorted.nextTier, sorted.nextTier);
    expect(unsorted.pointsToNextTier, sorted.pointsToNextTier);
    expect(unsorted.progressFraction, sorted.progressFraction);
  });

  test('unknown tier ID returns a typed failure', () {
    final result = calculateTierProgress(
      tierId: 'diamond',
      totalPoints: 700,
      tiers: tiers,
    );

    expect(result, isA<TierProgressFailure>());
    expect((result as TierProgressFailure).tierId, 'diamond');
  });

  test('equal tier thresholds do not divide by zero', () {
    final progress = _success('silver', 50, [
      const Tier(id: 'bronze', name: 'Bronze', minPoints: 0, sortOrder: 0),
      const Tier(id: 'silver', name: 'Silver', minPoints: 100, sortOrder: 1),
      const Tier(id: 'gold', name: 'Gold', minPoints: 100, sortOrder: 2),
    ]);

    expect(progress.nextTier?.id, 'gold');
    expect(progress.progressFraction.isFinite, isTrue);
    expect(progress.progressFraction, 0);
  });

  test('progress changes when only the total points change', () {
    final first = _success('silver', 600, tiers);
    final second = _success('silver', 800, tiers);

    expect(first.pointsToNextTier, 400);
    expect(second.pointsToNextTier, 200);
    expect(first.progressFraction, 0.2);
    expect(second.progressFraction, 0.6);
  });
}

TierProgress _success(String tierId, int totalPoints, List<Tier> tiers) {
  final result = calculateTierProgress(
    tierId: tierId,
    totalPoints: totalPoints,
    tiers: tiers,
  );
  expect(result, isA<TierProgressSuccess>());
  return (result as TierProgressSuccess).progress;
}
