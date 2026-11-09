import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts_flutter_app/di/service_locator.dart';

import '../../../../core/network/connectivity_monitor.dart';
import '../../../home/data/home_dao.dart';
import '../../../../database/daos/cart_dao.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/rewards_dao.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/session_store.dart';
import '../../domain/repositories/user_store.dart';
import '../../../members/domain/repositories/member_store.dart';
import '../auth_failure_message.dart';
import '../cubit/session_cubit.dart';
import '../cubit/session_state.dart';
import '../cubit/registration_cubit.dart';
import '../../../home/presentation/screens/member_home_screen.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../screens/dob_screen.dart';
import '../screens/name_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/phone_screen.dart';
import '../screens/welcome_screen.dart';

class AppRouterRefresh extends ChangeNotifier {
  AppRouterRefresh(Stream<SessionState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<SessionState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter(SessionCubit cubit, AppRouterRefresh refresh) {
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
            location == '/home' ||
            location.startsWith('/product/') ||
            location == '/rewards') {
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
      return location == '/home' ||
              location.startsWith('/product/') ||
              location == '/rewards'
          ? null
          : '/home';
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
          connectivityMonitor: getIt.isRegistered<ConnectivityMonitor>()
              ? getIt<ConnectivityMonitor>()
              : null,
        ),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final extra = state.extra;
          return _ProductRoute(
            productId: state.pathParameters['id']!,
            heroTag: extra is String ? extra : null,
            homeDao: getIt.isRegistered<HomeDao>() ? getIt<HomeDao>() : null,
            cartDao: getIt.isRegistered<CartDao>() ? getIt<CartDao>() : null,
            connectivityMonitor: getIt.isRegistered<ConnectivityMonitor>()
                ? getIt<ConnectivityMonitor>()
                : null,
          );
        },
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => RewardsScreen(
          memberStore: getIt<MemberStore>(),
          sessionStore: getIt<SessionStore>(),
          rewardsDao: getIt<RewardsDao>(),
          connectivityMonitor: getIt.isRegistered<ConnectivityMonitor>()
              ? getIt<ConnectivityMonitor>()
              : null,
        ),
      ),
    ],
  );
}

class _ProductRoute extends StatelessWidget {
  const _ProductRoute({
    required this.productId,
    required this.heroTag,
    required this.homeDao,
    required this.cartDao,
    required this.connectivityMonitor,
  });

  final String productId;
  final String? heroTag;
  final HomeDao? homeDao;
  final CartDao? cartDao;
  final ConnectivityMonitor? connectivityMonitor;

  @override
  Widget build(BuildContext context) {
    final dao = homeDao;
    final cart = cartDao;
    if (dao == null || cart == null) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context).productUnavailable),
        ),
      );
    }
    return FutureBuilder<Product?>(
      future: dao.findProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(AppLocalizations.of(context).productLoadError),
            ),
          );
        }
        final product = snapshot.data;
        if (product == null) {
          return Scaffold(
            body: Center(
              child: snapshot.connectionState == ConnectionState.done
                  ? Text(AppLocalizations.of(context).productUnavailable)
                  : const CircularProgressIndicator(),
            ),
          );
        }
        return ProductDetailScreen(
          product: product,
          cartDao: cart,
          connectivityMonitor: connectivityMonitor,
          heroTag: heroTag,
        );
      },
    );
  }
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
