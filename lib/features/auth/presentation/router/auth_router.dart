import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts_flutter_app/di/service_locator.dart';

import '../../../../database/daos/home_dao.dart';
import '../../../../database/daos/cart_dao.dart';
import '../../../../database/app_database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/session_store.dart';
import '../../domain/repositories/user_store.dart';
import '../../../members/domain/repositories/member_store.dart';
import '../auth_failure_message.dart';
import '../cubit/session_cubit.dart';
import '../cubit/session_state.dart';
import '../cubit/registration_cubit.dart';
import '../screens/member_home_screen.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../screens/dob_screen.dart';
import '../screens/name_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/phone_screen.dart';
import '../screens/welcome_screen.dart';

class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(Stream<SessionState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<SessionState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAuthRouter(SessionCubit cubit, AuthRouterRefresh refresh) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, routeState) {
      final authState = cubit.state;
      final location = routeState.matchedLocation;
      if (authState.isRestoringSession) {
        return location == '/splash' ? null : '/splash';
      }
      if (authState.failure != null) {
        return location == '/startup-error' ? null : '/startup-error';
      }
      if (!authState.isAuthenticated) {
        if (location == '/splash' ||
            location == '/welcome' ||
            location == '/home') {
          return '/onboarding';
        }
        final registration = context.read<RegistrationCubit>().state;
        if (location == '/otp' && !registration.phoneSubmitted) {
          return '/phone';
        }
        if (location == '/name' &&
            (!registration.otpVerified || !registration.isRegistration)) {
          return registration.phoneSubmitted ? '/otp' : '/phone';
        }
        if (location == '/dob' && !registration.nameCompleted) {
          return registration.otpVerified ? '/name' : '/phone';
        }
        return null;
      }
      if (authState.justRegistered) {
        return location == '/welcome' ? null : '/welcome';
      }
      return location == '/home' || location == '/product' ? null : '/home';
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/startup-error',
        builder: (context, state) => Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                authFailureMessage(
                  AppLocalizations.of(context),
                  cubit.state.failure!,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/phone', builder: (context, state) => const PhoneScreen()),
      GoRoute(path: '/otp', builder: (context, state) => const OtpScreen()),
      GoRoute(path: '/name', builder: (context, state) => const NameScreen()),
      GoRoute(path: '/dob', builder: (context, state) => const DobScreen()),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MemberHomeScreen(
          memberStore: getIt<MemberStore>(),
          sessionStore: getIt<SessionStore>(),
          userStore: getIt<UserStore>(),
          homeDao: getIt.isRegistered<HomeDao>() ? getIt<HomeDao>() : null,
        ),
      ),
      GoRoute(
        path: '/product',
        builder: (context, state) {
          final product = state.extra;
          if (product is! Product) {
            return const Scaffold(
              body: Center(child: Text('Product details are unavailable.')),
            );
          }
          return ProductDetailScreen(
            product: product,
            cartDao: getIt<CartDao>(),
          );
        },
      ),
    ],
  );
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}
