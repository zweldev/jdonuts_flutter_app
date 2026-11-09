import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../database/app_database.dart';
import '../../../../features/members/domain/entities/member.dart';
import '../../../../features/members/domain/tier_progress.dart';
import '../../../../l10n/app_localizations.dart';
import 'rewards_painters.dart';

const _rewardsProgressFraction = 0.7;

class RewardsHeader extends StatelessWidget {
  const RewardsHeader({
    super.key,
    required this.member,
    required this.tiers,
    required this.entryAnimation,
  });

  final Member? member;
  final List<DbTier> tiers;
  final Animation<double> entryAnimation;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.surface,
    child: Column(
      children: [
        _RewardsTitleRow(
          badgeCount: member?.rewardsBadgeCount ?? 0,
          entryAnimation: entryAnimation,
        ),
        _RewardsOverview(
          member: member,
          tiers: tiers,
          entryAnimation: entryAnimation,
        ),
      ],
    ),
  );
}

class _RewardsTitleRow extends StatelessWidget {
  const _RewardsTitleRow({
    required this.badgeCount,
    required this.entryAnimation,
  });

  final int badgeCount;
  final Animation<double> entryAnimation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final badgeAnimation = CurvedAnimation(
      parent: entryAnimation,
      curve: const Interval(
        AppMotion.badgeStart,
        AppMotion.badgeEnd,
        curve: Curves.elasticOut,
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.xl,
        right: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.rewardsTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
            ),
          ),
          ScaleTransition(
            scale: badgeAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              decoration: const BoxDecoration(
                color: AppColors.tertiary,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.xxl),
                  right: Radius.circular(AppRadius.xxl),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.rewardsBadge,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textInverse,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.surface,
                    child: Text(
                      '$badgeCount',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsOverview extends StatelessWidget {
  const _RewardsOverview({
    required this.member,
    required this.tiers,
    required this.entryAnimation,
  });

  final Member? member;
  final List<DbTier> tiers;
  final Animation<double> entryAnimation;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
    child: SizedBox(
      height: AppDimensions.rewardsOverviewHeight,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _TierLadder(
              member: member,
              tiers: tiers,
              entryAnimation: entryAnimation,
            ),
          ),
          Expanded(
            flex: 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final ringSize = math.min(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return Center(
                  child: _PointsRing(
                    member: member,
                    entryAnimation: entryAnimation,
                    size: ringSize,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _TierLadder extends StatelessWidget {
  const _TierLadder({
    required this.member,
    required this.tiers,
    required this.entryAnimation,
  });

  final Member? member;
  final List<DbTier> tiers;
  final Animation<double> entryAnimation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progressResult = member?.tierProgress;
    final progress = progressResult is TierProgressSuccess
        ? progressResult.progress
        : null;
    final orderedTiers = [...tiers]
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));
    final currentIsBaseTier =
        orderedTiers.isNotEmpty && member?.tierId == orderedTiers.first.id;
    final visibleTiers = currentIsBaseTier
        ? orderedTiers
        : orderedTiers.skip(1).toList(growable: false);
    if (visibleTiers.isEmpty) return const SizedBox.shrink();
    final currentIndex = visibleTiers.indexWhere(
      (tier) => tier.id == member?.tierId,
    );
    final nextTierId = progress?.nextTier?.id;
    final ladderProgress = _rewardsProgressFraction;
    final lineAnimation = CurvedAnimation(
      parent: entryAnimation,
      curve: const Interval(
        AppMotion.ringStart,
        AppMotion.ringEnd,
        curve: AppMotion.rewardsCurve,
      ),
    );
    return SizedBox(
      height: AppDimensions.rewardsTierStepHeight * visibleTiers.length,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.xxxl,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: lineAnimation,
                    builder: (context, _) => CustomPaint(
                      painter: TierLadderPainter(
                        tierCount: visibleTiers.length,
                        currentIndex: currentIndex,
                        progress: ladderProgress * lineAnimation.value,
                      ),
                    ),
                  ),
                ),
                for (var index = 0; index < visibleTiers.length; index++)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: index * AppDimensions.rewardsTierStepHeight,
                    height: AppDimensions.rewardsTierStepHeight,
                    child: Center(
                      child: _TierBadge(
                        tier: visibleTiers[index],
                        isCurrent: index == currentIndex,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              children: [
                for (var index = 0; index < visibleTiers.length; index++)
                  Expanded(
                    child: _TierLabel(
                      tier: visibleTiers[index],
                      index: index,
                      currentIndex: currentIndex,
                      nextTierId: nextTierId,
                      pointsToNextTier: progress?.pointsToNextTier,
                      entryAnimation: entryAnimation,
                      l10n: l10n,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.tier, required this.isCurrent});

  final DbTier tier;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: AppSpacing.xxl,
    height: AppSpacing.xxxl,
    child: CustomPaint(
      painter: TierShieldPainter(
        color: _tierColor(tier.id),
        isCurrent: isCurrent,
        letter: tier.name.characters.first.toUpperCase(),
      ),
    ),
  );
}

class _TierLabel extends StatelessWidget {
  const _TierLabel({
    required this.tier,
    required this.index,
    required this.currentIndex,
    required this.nextTierId,
    required this.pointsToNextTier,
    required this.entryAnimation,
    required this.l10n,
  });

  final DbTier tier;
  final int index;
  final int currentIndex;
  final String? nextTierId;
  final int? pointsToNextTier;
  final Animation<double> entryAnimation;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isCurrent = index == currentIndex;
    final isNext = tier.id == nextTierId;
    final tierStart = math.min(index * AppMotion.tierStagger, 0.55).toDouble();
    final tierEnd = math
        .min(tierStart + AppMotion.challengeEnterDuration, 1)
        .toDouble();
    final animation = CurvedAnimation(
      parent: entryAnimation,
      curve: Interval(tierStart, tierEnd, curve: AppMotion.rewardsCurve),
    );
    final status = isCurrent
        ? l10n.rewardsHereNow
        : isNext
        ? l10n.rewardsPointsRemaining(
            _formatPoints(pointsToNextTier ?? 0),
            tier.name,
          )
        : l10n.rewardsYoullBeHereSoon;
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.12, 0),
          end: Offset.zero,
        ).animate(animation),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tier.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              Text(
                status,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsRing extends StatelessWidget {
  const _PointsRing({
    required this.member,
    required this.entryAnimation,
    required this.size,
  });

  final Member? member;
  final Animation<double> entryAnimation;
  final double size;

  @override
  Widget build(BuildContext context) {
    final points = member?.totalPoints ?? 0;
    final ringAnimation = CurvedAnimation(
      parent: entryAnimation,
      curve: const Interval(
        AppMotion.ringStart,
        AppMotion.ringEnd,
        curve: AppMotion.rewardsCurve,
      ),
    );
    final pointsAnimation = Tween<double>(
      begin: 0,
      end: points.toDouble(),
    ).animate(ringAnimation);
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: pointsAnimation,
        builder: (context, _) {
          final animatedPoints = pointsAnimation.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: RewardsRingPainter(
                  progress: _rewardsProgressFraction * ringAnimation.value,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).rewardsTotalPoints,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    _formatPoints(animatedPoints.round()),
                    maxLines: 1,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.secondary,
                      fontSize: size * 0.135,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

Color _tierColor(String id) => switch (id) {
  'silver' => AppColors.silverTier,
  'gold' => AppColors.goldTier,
  'platinum' => AppColors.platinumTier,
  _ => AppColors.primary,
};

String _formatPoints(int points) => points.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (match) => ',',
);
