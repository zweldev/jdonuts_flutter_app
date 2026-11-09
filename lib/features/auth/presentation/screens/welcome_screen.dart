import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/app_images.dart';
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
        systemNavigationBarColor: Color(0xFFFFF1F6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF8FB),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
            final contentBottom = math.max(
              size.height * 0.082,
              safeBottom + 16,
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
                          const Color(0x00FFF1F6),
                          const Color(0xEFFFF1F6),
                          const Color(0xFFFFF1F6),
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
                      Text(
                        l10n.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF252832),
                          fontSize: 28,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 34),
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: context
                              .read<SessionCubit>()
                              .completeWelcome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF55C9E0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            l10n.letsExplore,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
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
