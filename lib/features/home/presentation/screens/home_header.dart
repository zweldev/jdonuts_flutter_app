part of 'member_home_screen.dart';

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.member,
    required this.user,
    required this.banners,
  });

  final Member? member;
  final AuthUser? user;
  final List<DbBanner> banners;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final headerHeight = width * 0.48;
    return SizedBox(
      height: width * 0.91,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        child: ColoredBox(
          color: context.appTheme.homeHeroBackground,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerHeight,
                child: _MemberHeader(
                  member: member,
                  user: user,
                  height: headerHeight,
                ),
              ),
              if (banners.isNotEmpty)
                Positioned(
                  top: headerHeight,
                  left: 0,
                  right: 0,
                  height: width * 0.8,
                  child: _BannerCarousel(banners: banners),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberHeader extends StatelessWidget {
  const _MemberHeader({
    required this.member,
    required this.user,
    required this.height,
  });

  final Member? member;
  final AuthUser? user;
  final double height;

  @override
  Widget build(BuildContext context) {
    final name =
        member?.name ??
        _userName(user) ??
        AppLocalizations.of(context).memberFallback;
    final progress = member?.tierProgress is TierProgressSuccess
        ? (member!.tierProgress as TierProgressSuccess).progress
        : null;
    final remaining = progress?.pointsToNextTier;
    final nextTier = progress?.nextTier?.name;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                top: width * 0.15,
                left: width * 0.07,
                right: width * 0.12,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: width * 0.077,
                      backgroundColor: AppColors.surface,
                      child: CircleAvatar(
                        radius: width * 0.069,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          _initials(name),
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.displaySmall.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.of(context)
                                .homeMemberTier(_tierName(member?.tierId)),
                            style: AppTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: width * 0.18,
                right: -width * 0.03,
                child: Material(
                  color: AppColors.tertiary,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(28),
                  ),
                  child: SizedBox(
                    width: width * 0.19,
                    height: width * 0.12,
                    child: IconButton(
                      tooltip: AppLocalizations.of(context).notifications,
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context).noNotifications,
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          ),
                      icon: SvgPicture.asset(
                        AppIcons.bell,
                        width: 27,
                        height: 27,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textInverse,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (remaining != null && nextTier != null)
                Positioned(
                  top: width * 0.36,
                  left: width * 0.065,
                  right: width * 0.3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      '${_number(remaining)} points left to become $nextTier Member',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static String? _userName(AuthUser? user) {
    if (user == null) return null;
    return [
      user.firstName,
      user.lastName,
    ].where((part) => part.trim().isNotEmpty).join(' ');
  }

  static String _tierName(String? tierId) {
    if (tierId == null || tierId.isEmpty) return 'J’Donuts';
    return '${tierId[0].toUpperCase()}${tierId.substring(1)}';
  }

  static String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    return words
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word.substring(0, 1).toUpperCase())
        .join();
  }
}
