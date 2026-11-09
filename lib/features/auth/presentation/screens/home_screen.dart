import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/session_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.homeTitle),
            TextButton(
              onPressed: () async {
                context.read<OtpCubit>().reset();
                context.read<RegistrationCubit>().resetFlow();
                await context.read<SessionCubit>().signOut();
              },
              child: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}
