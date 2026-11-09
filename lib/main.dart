import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' as material_ui;

import 'core/theme/app_design_system.dart';
import 'di/service_locator.dart';
import 'database/seed/seed_loader.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'l10n/app_localizations.dart';
import 'features/auth/presentation/cubit/otp_cubit.dart';
import 'features/auth/presentation/cubit/registration_cubit.dart';
import 'features/auth/presentation/router/auth_router.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  try {
    await getIt<SeedLoader>().seedIfNeeded();
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'offline seed startup',
      ),
    );
    runApp(_StartupErrorApp(error: error));
    return;
  }
  runApp(const MyApp());
}

class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(
      body: Center(
        child: SelectableText('Unable to load offline data.\n$error'),
      ),
    ),
  );
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
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          material_ui.GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
