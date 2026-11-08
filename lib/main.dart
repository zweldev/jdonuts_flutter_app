import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'di/service_locator.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'l10n/app_localizations.dart';
import 'features/auth/presentation/cubit/otp_cubit.dart';
import 'features/auth/presentation/cubit/registration_cubit.dart';
import 'features/auth/presentation/router/auth_router.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SessionCubit _sessionCubit;
  late final RegistrationCubit _registrationCubit;
  late final OtpCubit _otpCubit;
  late final AuthRouterRefresh _refresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final repository = getIt<AuthRepository>();
    _sessionCubit = SessionCubit(repository);
    _registrationCubit = RegistrationCubit(repository, _sessionCubit);
    _otpCubit = OtpCubit(repository, _registrationCubit, _sessionCubit);
    _refresh = AuthRouterRefresh(_sessionCubit.stream);
    _router = createAuthRouter(_sessionCubit, _refresh);
    _sessionCubit.restoreSession();
  }

  @override
  void dispose() {
    _router.dispose();
    _refresh.dispose();
    _otpCubit.close();
    _registrationCubit.close();
    _sessionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _sessionCubit),
        BlocProvider.value(value: _registrationCubit),
        BlocProvider.value(value: _otpCubit),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF55C9E0),
            surface: const Color(0xFFFFF8FA),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF8FA),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}
