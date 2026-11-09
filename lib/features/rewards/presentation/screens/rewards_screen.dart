import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_bottom_navigation.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/rewards_dao.dart';
import '../../../../features/auth/domain/repositories/session_store.dart';
import '../../../../features/auth/presentation/cubit/otp_cubit.dart';
import '../../../../features/auth/presentation/cubit/registration_cubit.dart';
import '../../../../features/auth/presentation/cubit/session_cubit.dart';
import '../../../../features/members/domain/entities/member.dart';
import '../../../../features/members/domain/repositories/member_store.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/rewards_challenges.dart';
import '../widgets/rewards_header.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({
    super.key,
    required this.memberStore,
    required this.sessionStore,
    required this.rewardsDao,
  });

  final MemberStore memberStore;
  final SessionStore sessionStore;
  final RewardsDao rewardsDao;

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryAnimation;
  late Future<_RewardsData> _data;
  String _selectedTab = 'earn';
  var _reduceMotion = false;
  var _entryStarted = false;

  @override
  void initState() {
    super.initState();
    _entryAnimation = AnimationController(
      vsync: this,
      duration: AppMotion.rewardsEntry,
    );
    _data = _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion && _entryStarted) _entryAnimation.value = 1;
  }

  Future<_RewardsData> _loadData() async {
    final userId = await widget.sessionStore.readUserId();
    if (userId == null) throw StateError('Rewards require a member session.');
    final results = await Future.wait<Object>([
      widget.memberStore
          .findByUserId(userId)
          .then(
            (member) =>
                member ?? (throw StateError('Member data is unavailable.')),
          ),
      widget.rewardsDao.loadChallenges(_selectedTab),
      widget.rewardsDao.loadTiers(),
    ]);
    return _RewardsData(
      member: results[0] as Member,
      challenges: results[1] as List<DbChallenge>,
      tiers: results[2] as List<DbTier>,
    );
  }

  Future<void> _refresh() async {
    final nextData = _loadData();
    setState(() {
      _data = nextData;
    });
    await nextData;
  }

  void _selectTab(String tab) {
    if (_selectedTab == tab) return;
    setState(() {
      _selectedTab = tab;
      _data = _loadData();
    });
  }

  void _startEntryAnimation() {
    if (_entryStarted) return;
    _entryStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_reduceMotion) {
        _entryAnimation.value = 1;
      } else {
        _entryAnimation.forward(from: 0);
      }
    });
  }

  void _onNavigationSelected(int index) {
    if (index == 0) {
      context.go('/home');
    } else if (index == 4) {
      _showLogoutSheet();
    } else if (index != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).placeholderNotConnected),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: Text(AppLocalizations.of(context).logout),
          onTap: () async {
            Navigator.pop(context);
            context.read<OtpCubit>().reset();
            context.read<RegistrationCubit>().resetFlow();
            await context.read<SessionCubit>().signOut();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _entryAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.homeBackground,
    body: SafeArea(
      bottom: false,
      child: FutureBuilder<_RewardsData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _RewardsError(onRetry: _refresh);
          }
          if (!snapshot.hasData) return const _RewardsLoading();
          _startEntryAnimation();
          final data = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: RewardsHeader(
                    member: data.member,
                    tiers: data.tiers,
                    entryAnimation: _entryAnimation,
                  ),
                ),
                SliverToBoxAdapter(
                  child: RewardsChallenges(
                    selectedTab: _selectedTab,
                    challenges: data.challenges,
                    onTabSelected: _selectTab,
                    entryAnimation: _entryAnimation,
                    reduceMotion: _reduceMotion,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    bottomNavigationBar: AppBottomNavigation(
      selectedIndex: 1,
      onSelected: _onNavigationSelected,
    ),
  );
}

class _RewardsData {
  const _RewardsData({
    required this.member,
    required this.challenges,
    required this.tiers,
  });

  final Member member;
  final List<DbChallenge> challenges;
  final List<DbTier> tiers;
}

class _RewardsLoading extends StatelessWidget {
  const _RewardsLoading();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      const _Skeleton(width: 210, height: 32),
      const SizedBox(height: AppSpacing.xl),
      const _Skeleton(height: 270, radius: AppRadius.xl),
      const SizedBox(height: AppSpacing.xl),
      for (var index = 0; index < 3; index++) ...[
        const _Skeleton(height: 164, radius: AppRadius.xl),
        const SizedBox(height: AppSpacing.md),
      ],
    ],
  );
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({
    this.width,
    required this.height,
    this.radius = AppRadius.md,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _RewardsError extends StatelessWidget {
  const _RewardsError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppLocalizations.of(context).rewardsLoadError,
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).rewardsRetry),
          ),
        ],
      ),
    ),
  );
}
