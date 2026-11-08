import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
      backgroundColor: const Color(0xFFFFF1F6),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/onboarding/onboarding_bg.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x12FFFFFF),
                  Color(0x18FDECF3),
                  Color(0xE6FFF1F6),
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
                      padding: const EdgeInsets.fromLTRB(28, 12, 28, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.43),
                          Text(
                            l10n.onboardingTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF282B33),
                              height: 1.14,
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AuthPrimaryButton(
                            label: l10n.getStarted,
                            onPressed: () => _startFlow(
                              context,
                              context
                                  .read<RegistrationCubit>()
                                  .beginRegistration,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(l10n.alreadyHaveAccount),
                              TextButton(
                                onPressed: () => _startFlow(
                                  context,
                                  context.read<RegistrationCubit>().beginLogin,
                                ),
                                child: Text(l10n.logIn),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialButton(
                                asset: 'assets/images/onboarding/google.svg',
                                label: l10n.socialGoogle,
                                onTap: () => _showPlaceholder(
                                  context,
                                  l10n.socialGoogle,
                                ),
                              ),
                              const SizedBox(width: 28),
                              _SocialButton(
                                asset: 'assets/images/onboarding/apple.svg',
                                label: l10n.socialApple,
                                onTap: () =>
                                    _showPlaceholder(context, l10n.socialApple),
                              ),
                              const SizedBox(width: 28),
                              _SocialButton(
                                asset: 'assets/images/onboarding/facebook.svg',
                                label: l10n.socialFacebook,
                                onTap: () => _showPlaceholder(
                                  context,
                                  l10n.socialFacebook,
                                ),
                              ),
                            ],
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFEF4F9B),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                feature,
                style: const TextStyle(
                  color: Color(0xFF282B33),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.placeholderNotConnected,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF737782)),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(asset, width: 24, height: 24),
          ),
          const SizedBox(height: 7),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
