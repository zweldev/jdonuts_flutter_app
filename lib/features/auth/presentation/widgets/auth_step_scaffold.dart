import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_entrance.dart';

class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    required this.title,
    required this.progress,
    required this.child,
    required this.onBack,
    required this.continueLabel,
    required this.isContinueEnabled,
    required this.isLoading,
    required this.onContinue,
    super.key,
  });

  final String title;
  final double progress;
  final Widget child;
  final VoidCallback onBack;
  final String continueLabel;
  final bool isContinueEnabled;
  final bool isLoading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.onboardingGradientStart,
              AppColors.onboardingGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.screenHorizontalPadding,
              AppSpacing.sm,
              AppDimensions.screenHorizontalPadding,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        onTap: onBack,
                        child: const SizedBox(
                          width: AppDimensions.backButtonSize,
                          height: AppDimensions.backButtonSize,
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.textPrimary,
                            size: AppDimensions.iconLarge,
                          ),
                        ),
                      ),
                    ),
                    AuthProgressBadge(progress: progress),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppEntrance(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 27,
                      height: 1.14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppEntrance(
                  delay: const Duration(milliseconds: 90),
                  child: child,
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppEntrance(
                  delay: const Duration(milliseconds: 180),
                  child: AuthPrimaryButton(
                    label: continueLabel,
                    onPressed: isContinueEnabled ? onContinue : null,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SizedBox(
      height: AppDimensions.buttonHeight,
      width: double.infinity,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed && !reduceMotion ? AppMotion.pressedScale : 1,
          duration: reduceMotion ? Duration.zero : AppMotion.buttonPress,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              disabledBackgroundColor: AppColors.disabledSurface,
              disabledForegroundColor: AppColors.textInverse,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: AppDimensions.loaderSize,
                    height: AppDimensions.loaderSize,
                    child: CircularProgressIndicator(
                      strokeWidth: AppDimensions.loaderStrokeWidth,
                      color: AppColors.textInverse,
                    ),
                  )
                : Text(
                    widget.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      letterSpacing: 0.6,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class AuthProgressBadge extends StatelessWidget {
  const AuthProgressBadge({
    required this.progress,
    this.isComplete = false,
    super.key,
  });

  final double progress;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.progressIndicatorSize,
      height: AppDimensions.progressIndicatorSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : AppMotion.progressRing,
            curve: AppMotion.rewardsCurve,
            builder: (context, value, _) => CircularProgressIndicator(
              value: value,
              strokeWidth: AppDimensions.progressStrokeWidth,
              backgroundColor: AppColors.primary.withValues(alpha: 0.35),
              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
            ),
          ),
          if (isComplete || progress >= 1)
            const Icon(
              Icons.check,
              color: AppColors.textInverse,
              size: AppDimensions.iconSmall,
            ),
        ],
      ),
    );
  }
}

InputDecoration authInputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );
}
