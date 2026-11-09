import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/otp_cubit.dart';
import '../widgets/auth_step_scaffold.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.onboardingBackground,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surface.withValues(alpha: 0.07),
                  AppColors.secondaryLight.withValues(alpha: 0.09),
                  AppColors.onboardingBackground.withValues(alpha: 0.9),
                ],
                stops: [0, 0.48, 0.78],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xxxl - AppSpacing.xs,
                        AppSpacing.sm,
                        AppSpacing.xxxl - AppSpacing.xs,
                        AppSpacing.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.43),
                          AppEntrance(
                            delay: const Duration(milliseconds: 100),
                            child: Text(
                              l10n.onboardingTitle,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.displaySmall.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.14,
                                fontSize: 29,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AppEntrance(
                            delay: const Duration(milliseconds: 210),
                            child: AuthPrimaryButton(
                              label: l10n.getStarted,
                              onPressed: () => _startFlow(
                                context,
                                context
                                    .read<RegistrationCubit>()
                                    .beginRegistration,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AppEntrance(
                            delay: const Duration(milliseconds: 290),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(l10n.alreadyHaveAccount),
                                TextButton(
                                  onPressed: () => _startFlow(
                                    context,
                                    context
                                        .read<RegistrationCubit>()
                                        .beginLogin,
                                  ),
                                  child: Text(l10n.logIn),
                                ),
                              ],
                            ),
                          ),
                          AppEntrance(
                            delay: const Duration(milliseconds: 370),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SocialButton(
                                  asset: AppImages.onboardingGoogle,
                                  label: l10n.socialGoogle,
                                  onTap: () => _showPlaceholder(
                                    context,
                                    l10n.socialGoogle,
                                  ),
                                ),
                                const SizedBox(width: 28),
                                _SocialButton(
                                  asset: AppImages.onboardingApple,
                                  label: l10n.socialApple,
                                  onTap: () => _showPlaceholder(
                                    context,
                                    l10n.socialApple,
                                  ),
                                ),
                                const SizedBox(width: 28),
                                _SocialButton(
                                  asset: AppImages.onboardingFacebook,
                                  label: l10n.socialFacebook,
                                  onTap: () => _showPlaceholder(
                                    context,
                                    l10n.socialFacebook,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    _showPlaceholder(context, l10n.termsOfUse),
                                child: Text(l10n.termsOfUse),
                              ),
                              TextButton(
                                onPressed: () => _showPlaceholder(
                                  context,
                                  l10n.privacyPolicy,
                                ),
                                child: Text(l10n.privacyPolicy),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startFlow(BuildContext context, VoidCallback start) {
    context.read<OtpCubit>().reset();
    start();
    context.push('/phone');
  }

  void _showPlaceholder(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.secondary,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(feature, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 8),
              Text(
                l10n.placeholderNotConnected,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  final String asset;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.8),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(asset, width: 24, height: 24),
          ),
          const SizedBox(height: 7),
          Text(label, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
