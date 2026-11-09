import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/widgets/app_entrance.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_settings_sheet.dart';
import '../../../../core/widgets/connectivity_banner.dart';
import '../../../../database/app_database.dart';
import '../../data/home_dao.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/repositories/member_store.dart';
import '../../../members/domain/tier_progress.dart';

import 'package:jdonuts_flutter_app/features/auth/domain/entities/auth_user.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/session_store.dart';
import 'package:jdonuts_flutter_app/features/auth/domain/repositories/user_store.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/registration_cubit.dart';
import 'package:jdonuts_flutter_app/features/auth/presentation/cubit/session_cubit.dart';

part 'home_header.dart';
part 'home_banners.dart';
part 'home_products.dart';
part 'home_shops.dart';
part 'home_loading.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({
    super.key,
    required this.memberStore,
    required this.sessionStore,
    required this.userStore,
    required this.homeDao,
    this.connectivityMonitor,
  });

  final MemberStore memberStore;
  final SessionStore sessionStore;
  final UserStore userStore;
  final HomeDao? homeDao;
  final ConnectivityMonitor? connectivityMonitor;

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  late Future<_HomeData> _homeData = _loadHomeData();
  int _selectedTab = 0;
  late bool _wasOnline = widget.connectivityMonitor?.isOnline ?? true;

  @override
  void initState() {
    super.initState();
    widget.connectivityMonitor?.addListener(_onConnectivityChanged);
  }

  @override
  void dispose() {
    widget.connectivityMonitor?.removeListener(_onConnectivityChanged);
    super.dispose();
  }

  void _onConnectivityChanged() {
    final isOnline = widget.connectivityMonitor?.isOnline ?? true;
    if (isOnline && !_wasOnline) _refresh();
    _wasOnline = isOnline;
  }

  Future<_HomeData> _loadHomeData() async {
    final userId = await widget.sessionStore.readUserId();
    if (userId == null) {
      return _HomeData(catalog: await _loadCatalog(), member: null, user: null);
    }
    final results = await Future.wait<Object?>([
      widget.memberStore.findByUserId(userId),
      widget.userStore.findById(userId),
      _loadCatalog(),
    ]);
    return _HomeData(
      member: results[0] as Member?,
      user: results[1] as AuthUser?,
      catalog: results[2] as HomeCatalog,
    );
  }

  Future<HomeCatalog> _loadCatalog() =>
      widget.homeDao?.loadCatalog() ?? Future.value(HomeCatalog.empty);

  Future<void> _refresh() async {
    final refreshed = _loadHomeData();
    setState(() => _homeData = refreshed);
    await refreshed;
  }

  Future<void> _signOut() async {
    context.read<OtpCubit>().reset();
    context.read<RegistrationCubit>().resetFlow();
    await context.read<SessionCubit>().signOut();
  }

  void _selectTab(int index) {
    if (index == 1) {
      context.go('/rewards');
      return;
    }
    if (index == 4) {
      showAppSettingsSheet(context, onLogOut: _signOut);
      return;
    }
    if (index == 0) {
      context.go('/home');
      return;
    }
    setState(() => _selectedTab = index);
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).placeholderNotConnected),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appTheme.homeHeroBackground,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            ConnectivityBanner(monitor: widget.connectivityMonitor),
            Expanded(
              child: FutureBuilder<_HomeData>(
                future: _homeData,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _HomeLoadError(onRetry: _refresh);
                  }
                  if (!snapshot.hasData) return const _HomeSkeleton();
                  return _HomeContent(
                    data: snapshot.data!,
                    onRefresh: _refresh,
                    homeDao: widget.homeDao,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedTab,
        onSelected: _selectTab,
      ),
    );
  }
}

class _HomeData {
  const _HomeData({
    required this.catalog,
    required this.member,
    required this.user,
  });

  final HomeCatalog catalog;
  final Member? member;
  final AuthUser? user;
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.data,
    required this.onRefresh,
    required this.homeDao,
  });

  final _HomeData data;
  final Future<void> Function() onRefresh;
  final HomeDao? homeDao;

  @override
  Widget build(BuildContext context) {
    final sections = data.catalog.sections;
    return ColoredBox(
      color: AppColors.homeBackground,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppEntrance(
                child: _HomeHero(
                  member: data.member,
                  user: data.user,
                  banners: data.catalog.banners,
                ),
              ),
            ),
            if (sections.isEmpty)
              const SliverToBoxAdapter(
                child: _EmptyCatalog(
                  messageKey: _EmptyCatalogMessage.noProductSections,
                ),
              )
            else
              for (var index = 0; index < sections.length; index++)
                SliverToBoxAdapter(
                  child: AppEntrance(
                    delay: AppMotion.homeSectionStagger * index,
                    child: _ProductSection(
                      section: sections[index],
                      homeDao: homeDao,
                    ),
                  ),
                ),
            SliverToBoxAdapter(child: _NearbyShops(shops: data.catalog.shops)),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
          ],
        ),
      ),
    );
  }
}

Color _bannerColor(String styleKey) => switch (styleKey) {
  'purple' => AppColors.promoPurple,
  'orange' => AppColors.promoOrange,
  _ => AppColors.promoCyan,
};

String _number(int value) => value.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (match) => ',',
);
