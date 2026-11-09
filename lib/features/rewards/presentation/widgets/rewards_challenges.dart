import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../database/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import 'rewards_painters.dart';

class RewardsChallenges extends StatelessWidget {
  const RewardsChallenges({
    super.key,
    required this.selectedTab,
    required this.challenges,
    required this.onTabSelected,
    required this.entryAnimation,
    required this.reduceMotion,
  });

  final String selectedTab;
  final List<DbChallenge> challenges;
  final ValueChanged<String> onTabSelected;
  final Animation<double> entryAnimation;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.homeBackground,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        children: [
          _ChallengeTabs(
            selectedTab: selectedTab,
            onSelected: onTabSelected,
            reduceMotion: reduceMotion,
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: reduceMotion ? Duration.zero : AppMotion.tabContent,
            switchInCurve: AppMotion.tabCurve,
            switchOutCurve: AppMotion.tabCurve,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.035),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: challenges.isEmpty
                ? _EmptyChallenges(key: ValueKey(selectedTab))
                : Column(
                    key: ValueKey(selectedTab),
                    children: [
                      for (var index = 0; index < challenges.length; index++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _StaggeredChallenge(
                            challenge: challenges[index],
                            index: index,
                            entryAnimation: entryAnimation,
                            reduceMotion: reduceMotion,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyChallenges extends StatelessWidget {
  const _EmptyChallenges({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.xxxl,
    ),
    child: Column(
      children: [
        const Icon(
          Icons.card_giftcard_rounded,
          size: AppDimensions.iconExtraLarge,
          color: AppColors.iconSecondary,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocalizations.of(context).rewardsEmptyTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppLocalizations.of(context).rewardsEmptyMessage,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );
}

class _ChallengeTabs extends StatelessWidget {
  const _ChallengeTabs({
    required this.selectedTab,
    required this.onSelected,
    required this.reduceMotion,
  });

  final String selectedTab;
  final ValueChanged<String> onSelected;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = constraints.maxWidth / 4;
        final earnTab = selectedTab == 'earn';
        return SizedBox(
          height: AppSpacing.xxxl + AppSpacing.xs,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: reduceMotion ? Duration.zero : AppMotion.tabIndicator,
                curve: AppMotion.tabCurve,
                left: earnTab ? 0 : tabWidth * 2,
                top: 0,
                bottom: 0,
                width: tabWidth * (earnTab ? 2 : 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _TabTarget(
                      label: l10n.rewardsEarnTab,
                      selected: earnTab,
                      onTap: () => onSelected('earn'),
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Expanded(
                    child: _TabTarget(
                      label: l10n.rewardsGiftTab,
                      selected: !earnTab,
                      onTap: () => onSelected('gift'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabTarget extends StatelessWidget {
  const _TabTarget({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Center(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleLarge.copyWith(
            color: selected ? AppColors.textInverse : AppColors.textSecondary,
          ),
        ),
      ),
    ),
  );
}

class _StaggeredChallenge extends StatelessWidget {
  const _StaggeredChallenge({
    required this.challenge,
    required this.index,
    required this.entryAnimation,
    required this.reduceMotion,
  });

  final DbChallenge challenge;
  final int index;
  final Animation<double> entryAnimation;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final start = math.min(index * AppMotion.challengeStagger, 0.52).toDouble();
    final end = math
        .min(start + AppMotion.challengeEnterDuration, 1)
        .toDouble();
    final animation = CurvedAnimation(
      parent: entryAnimation,
      curve: Interval(start, end, curve: AppMotion.rewardsCurve),
    );
    if (reduceMotion) return _ChallengeCard(challenge: challenge);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12),
          end: Offset.zero,
        ).animate(animation),
        child: _ChallengeCard(challenge: challenge),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});

  final DbChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final isComplete = challenge.progress >= challenge.target;
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppDimensions.rewardsChallengeMinHeight,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: SizedBox.square(
              dimension: AppDimensions.rewardsArtworkSize,
              child: _ChallengeArtwork(challenge: challenge),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 6,
            child: _ChallengeDetails(
              challenge: challenge,
              isComplete: isComplete,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeDetails extends StatelessWidget {
  const _ChallengeDetails({required this.challenge, required this.isComplete});

  final DbChallenge challenge;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          challenge.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.rewardsChallengeProgress(challenge.progress, challenge.target),
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _EarnButton(isComplete: isComplete),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                l10n.rewardsPointUnit(_formatPoints(challenge.rewardPoints)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EarnButton extends StatefulWidget {
  const _EarnButton({required this.isComplete});

  final bool isComplete;

  @override
  State<_EarnButton> createState() => _EarnButtonState();
}

class _EarnButtonState extends State<_EarnButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _attentionController;
  var _reduceMotion = false;
  var _pressed = false;

  @override
  void initState() {
    super.initState();
    _attentionController = AnimationController(
      vsync: this,
      duration: AppMotion.challengeAttention,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    _updateAttention();
  }

  @override
  void didUpdateWidget(covariant _EarnButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAttention();
  }

  void _updateAttention() {
    if (widget.isComplete && !_reduceMotion) {
      if (!_attentionController.isAnimating) {
        _attentionController.repeat(reverse: true);
      }
    } else {
      _attentionController.stop();
      _attentionController.value = 0;
    }
  }

  @override
  void dispose() {
    _attentionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown: (_) => setState(() => _pressed = true),
    onTapUp: (_) => setState(() => _pressed = false),
    onTapCancel: () => setState(() => _pressed = false),
    child: AnimatedBuilder(
      animation: _attentionController,
      builder: (context, child) => AnimatedScale(
        scale: _pressed
            ? AppMotion.pressedScale
            : widget.isComplete && !_reduceMotion
            ? 1 + _attentionController.value * (AppMotion.activeEarnScale - 1)
            : 1,
        duration: _reduceMotion ? Duration.zero : AppMotion.buttonPress,
        child: child,
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: AppSpacing.massive + AppSpacing.sm,
          minHeight: AppSpacing.xxl,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: widget.isComplete
              ? AppColors.primary
              : AppColors.disabledSurface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          AppLocalizations.of(context).rewardsEarnButton,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.8,
          ),
        ),
      ),
    ),
  );
}

class _ChallengeArtwork extends StatelessWidget {
  const _ChallengeArtwork({required this.challenge});

  final DbChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final progress = (challenge.progress / challenge.target)
        .clamp(0, 1)
        .toDouble();
    return switch (challenge.artStyle) {
      'donut_quarters' => _DonutProgressArt(
        imagePath: challenge.image,
        progress: progress,
      ),
      'coffee_arc' => Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.challengeItemCoffee, fit: BoxFit.contain),
          CustomPaint(painter: CoffeeProgressPainter(progress: progress)),
        ],
      ),
      _ => Image.asset(challenge.image, fit: BoxFit.contain),
    };
  }
}

class _DonutProgressArt extends StatelessWidget {
  const _DonutProgressArt({required this.imagePath, required this.progress});

  final String imagePath;
  final double progress;

  static const _grayscaleMatrix = <double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ColorFiltered(
        colorFilter: const ColorFilter.matrix(_grayscaleMatrix),
        child: Image.asset(imagePath, fit: BoxFit.contain),
      ),
      if (progress > 0)
        ClipPath(
          clipper: DonutProgressClipper(progress),
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
    ],
  );
}

String _formatPoints(int points) => points.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (match) => ',',
);
