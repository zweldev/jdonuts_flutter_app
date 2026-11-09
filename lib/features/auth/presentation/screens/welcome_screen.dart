import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_images.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/session_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.onboardingBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
            final contentBottom = math.max(
              size.height * 0.082,
              safeBottom + AppSpacing.md,
            );
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppImages.welcomeScreenBackground,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.welcomeOverlayTransparent,
                          AppColors.welcomeOverlayMid,
                          AppColors.welcomeOverlayEnd,
                        ],
                        stops: const [0.64, 0.79, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: size.width * 0.085,
                  right: size.width * 0.085,
                  bottom: contentBottom,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppEntrance(
                        delay: const Duration(milliseconds: 220),
                        child: Text(
                          l10n.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                      AppEntrance(
                        delay: const Duration(milliseconds: 380),
                        child: SizedBox(
                          height: AppDimensions.buttonHeight,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: context
                                .read<SessionCubit>()
                                .completeWelcome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textInverse,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Text(
                              l10n.letsExplore,
                              style: AppTextStyles.titleLarge.copyWith(
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
