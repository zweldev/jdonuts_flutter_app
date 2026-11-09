import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.onboardingBackground,
    required this.onboardingGradientStart,
    required this.onboardingGradientEnd,
    required this.rewardPointsAccent,
    required this.silverTier,
    required this.goldTier,
    required this.platinumTier,
    required this.promotionalBadge,
    required this.specialCardBackground,
    required this.homeBackground,
    required this.homeHeroBackground,
    required this.success,
    required this.warning,
    required this.error,
    required this.information,
    required this.disabled,
    required this.overlay,
    required this.divider,
    required this.textTertiary,
    required this.iconSecondary,
  });

  final Color onboardingBackground;
  final Color onboardingGradientStart;
  final Color onboardingGradientEnd;
  final Color rewardPointsAccent;
  final Color silverTier;
  final Color goldTier;
  final Color platinumTier;
  final Color promotionalBadge;
  final Color specialCardBackground;
  final Color homeBackground;
  final Color homeHeroBackground;
  final Color success;
  final Color warning;
  final Color error;
  final Color information;
  final Color disabled;
  final Color overlay;
  final Color divider;
  final Color textTertiary;
  final Color iconSecondary;

  static const light = AppThemeExtension(
    onboardingBackground: AppColors.onboardingBackground,
    onboardingGradientStart: AppColors.onboardingGradientStart,
    onboardingGradientEnd: AppColors.onboardingGradientEnd,
    rewardPointsAccent: AppColors.rewardAccent,
    silverTier: AppColors.silverTier,
    goldTier: AppColors.goldTier,
    platinumTier: AppColors.platinumTier,
    promotionalBadge: AppColors.promotionalBadge,
    specialCardBackground: AppColors.tertiaryLight,
    homeBackground: AppColors.homeBackground,
    homeHeroBackground: AppColors.homeHero,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    information: AppColors.information,
    disabled: AppColors.disabled,
    overlay: AppColors.overlay,
    divider: AppColors.divider,
    textTertiary: AppColors.textTertiary,
    iconSecondary: AppColors.iconSecondary,
  );

  @override
  AppThemeExtension copyWith({
    Color? onboardingBackground,
    Color? onboardingGradientStart,
    Color? onboardingGradientEnd,
    Color? rewardPointsAccent,
    Color? silverTier,
    Color? goldTier,
    Color? platinumTier,
    Color? promotionalBadge,
    Color? specialCardBackground,
    Color? homeBackground,
    Color? homeHeroBackground,
    Color? success,
    Color? warning,
    Color? error,
    Color? information,
    Color? disabled,
    Color? overlay,
    Color? divider,
    Color? textTertiary,
    Color? iconSecondary,
  }) => AppThemeExtension(
    onboardingBackground: onboardingBackground ?? this.onboardingBackground,
    onboardingGradientStart:
        onboardingGradientStart ?? this.onboardingGradientStart,
    onboardingGradientEnd: onboardingGradientEnd ?? this.onboardingGradientEnd,
    rewardPointsAccent: rewardPointsAccent ?? this.rewardPointsAccent,
    silverTier: silverTier ?? this.silverTier,
    goldTier: goldTier ?? this.goldTier,
    platinumTier: platinumTier ?? this.platinumTier,
    promotionalBadge: promotionalBadge ?? this.promotionalBadge,
    specialCardBackground: specialCardBackground ?? this.specialCardBackground,
    homeBackground: homeBackground ?? this.homeBackground,
    homeHeroBackground: homeHeroBackground ?? this.homeHeroBackground,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    information: information ?? this.information,
    disabled: disabled ?? this.disabled,
    overlay: overlay ?? this.overlay,
    divider: divider ?? this.divider,
    textTertiary: textTertiary ?? this.textTertiary,
    iconSecondary: iconSecondary ?? this.iconSecondary,
  );

  @override
  AppThemeExtension lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      onboardingBackground: Color.lerp(
        onboardingBackground,
        other.onboardingBackground,
        t,
      )!,
      onboardingGradientStart: Color.lerp(
        onboardingGradientStart,
        other.onboardingGradientStart,
        t,
      )!,
      onboardingGradientEnd: Color.lerp(
        onboardingGradientEnd,
        other.onboardingGradientEnd,
        t,
      )!,
      rewardPointsAccent: Color.lerp(
        rewardPointsAccent,
        other.rewardPointsAccent,
        t,
      )!,
      silverTier: Color.lerp(silverTier, other.silverTier, t)!,
      goldTier: Color.lerp(goldTier, other.goldTier, t)!,
      platinumTier: Color.lerp(platinumTier, other.platinumTier, t)!,
      promotionalBadge: Color.lerp(
        promotionalBadge,
        other.promotionalBadge,
        t,
      )!,
      specialCardBackground: Color.lerp(
        specialCardBackground,
        other.specialCardBackground,
        t,
      )!,
      homeBackground: Color.lerp(homeBackground, other.homeBackground, t)!,
      homeHeroBackground: Color.lerp(
        homeHeroBackground,
        other.homeHeroBackground,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      information: Color.lerp(information, other.information, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
    );
  }
}
