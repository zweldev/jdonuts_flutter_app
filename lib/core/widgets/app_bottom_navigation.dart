import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icons.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_design_system.dart';

class AppBottomNavigation extends StatefulWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation> {
  var _animatedIndex = 0;
  var _hasSyncedInitialIndex = false;

  static const _icons = [
    AppIcons.home,
    AppIcons.crown,
    AppIcons.order,
    AppIcons.wallet,
    AppIcons.settings,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasSyncedInitialIndex) return;
    _hasSyncedInitialIndex = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animatedIndex = widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant AppBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _animatedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final labels = [
      l10n.homeTitle,
      l10n.rewardTabLabel,
      l10n.orderTabLabel,
      l10n.walletTabLabel,
      l10n.profileTabLabel,
    ];
    return ColoredBox(
      color: AppColors.primary,
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slotWidth = constraints.maxWidth / _icons.length;
            final pillWidth = slotWidth * (_animatedIndex == 1 ? 1.42 : 1.12);
            final pillLeft =
                (slotWidth * (_animatedIndex + 0.5) - pillWidth / 2).clamp(
                  0.0,
                  constraints.maxWidth - pillWidth,
                );
            return SizedBox(
              height: 68,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppRadius.xl),
                        ),
                      ),
                      child: Row(
                        children: [
                          for (var index = 0; index < _icons.length; index++)
                            Expanded(
                              child: Semantics(
                                button: true,
                                label: labels[index],
                                selected: index == _animatedIndex,
                                child: InkWell(
                                  onTap: () => widget.onSelected(index),
                                  child: Center(
                                    child: index == _animatedIndex
                                        ? const SizedBox(
                                            width: AppDimensions.iconLarge,
                                            height: AppDimensions.iconLarge,
                                          )
                                        : SvgPicture.asset(
                                            _icons[index],
                                            width: AppDimensions.iconMedium,
                                            height: AppDimensions.iconMedium,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.textInverse,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: reduceMotion
                        ? Duration.zero
                        : AppMotion.bottomNavPill,
                    curve: AppMotion.tabCurve,
                    left: pillLeft,
                    top: AppSpacing.xs,
                    bottom: AppSpacing.xs,
                    width: pillWidth,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: AppColors.textInverse,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              _icons[_animatedIndex],
                              width: AppDimensions.iconMedium,
                              height: AppDimensions.iconMedium,
                              colorFilter: const ColorFilter.mode(
                                AppColors.textInverse,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                labels[_animatedIndex],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.textInverse,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
