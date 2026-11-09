import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/session_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFEAF2), Color(0xFFFFF8FA)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFFEF4F9B),
                    size: 64,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF272A32),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF737782)),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: context.read<SessionCubit>().completeWelcome,
                    child: Text(l10n.letsExplore),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
