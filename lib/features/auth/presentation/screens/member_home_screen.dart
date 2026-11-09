import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/app_icons.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/home_dao.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/repositories/member_store.dart';
import '../../../members/domain/tier_progress.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/session_store.dart';
import '../../domain/repositories/user_store.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/session_cubit.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({
    super.key,
    required this.memberStore,
    required this.sessionStore,
    required this.userStore,
    required this.homeDao,
  });

  final MemberStore memberStore;
  final SessionStore sessionStore;
  final UserStore userStore;
  final HomeDao? homeDao;

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  late Future<_HomeData> _homeData = _loadHomeData();
  int _selectedTab = 0;

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
    if (index == 4) {
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(AppLocalizations.of(context).logout),
            onTap: () {
              Navigator.pop(context);
              _signOut();
            },
          ),
        ),
      );
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
        child: FutureBuilder<_HomeData>(
          future: _homeData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _HomeLoadError(onRetry: _refresh);
            }
            if (!snapshot.hasData) return const _HomeSkeleton();
            return _HomeContent(data: snapshot.data!, onRefresh: _refresh);
          },
        ),
      ),
      bottomNavigationBar: _HomeBottomNavigation(
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
  const _HomeContent({required this.data, required this.onRefresh});

  final _HomeData data;
  final Future<void> Function() onRefresh;

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
              child: _HomeHero(
                member: data.member,
                user: data.user,
                banners: data.catalog.banners,
              ),
            ),
            if (sections.isEmpty)
              const SliverToBoxAdapter(
                child: _EmptyCatalog(message: 'No product sections yet.'),
              )
            else
              for (final section in sections)
                SliverToBoxAdapter(child: _ProductSection(section: section)),
            SliverToBoxAdapter(child: _NearbyShops(shops: data.catalog.shops)),
            const SliverToBoxAdapter(child: SizedBox(height: 22)),
          ],
        ),
      ),
    );
  }
}

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
    final name = member?.name ?? _userName(user) ?? 'J’Donuts member';
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
                            '${_tierName(member?.tierId)} member',
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
                      tooltip: 'Notifications',
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('No new notifications.'),
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

class _BannerCarousel extends StatefulWidget {
  const _BannerCarousel({required this.banners});

  final List<DbBanner> banners;

  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.75,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.043),
      child: PageView.builder(
        controller: _controller,
        padEnds: false,
        itemCount: widget.banners.length,
        itemBuilder: (context, index) {
          final banner = widget.banners[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _BannerCard(banner: banner),
          );
        },
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final DbBanner banner;

  @override
  Widget build(BuildContext context) {
    final color = _bannerColor(banner.styleKey);
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: color),
          const _BannerConfetti(),
          Positioned(
            top: 108,
            left: 40,
            right: 40,
            height: 130,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: _CatalogImage(path: banner.image, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 92,
            left: 0,
            right: 0,
            child: Align(
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.storefront_rounded, color: color, size: 22),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (banner.badgeText != null)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      border: Border.all(color: AppColors.surface, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      child: Text(
                        banner.badgeText!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textInverse,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  banner.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textInverse,
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerConfetti extends StatelessWidget {
  const _BannerConfetti();

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(child: CustomPaint(painter: _ConfettiPainter())),
  );
}

class _ConfettiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.decorativeWhite
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 18; index++) {
      final x = (index * 67.0 + 17) % size.width;
      final y = (index * 43.0 + 15) % (size.height * 0.66);
      canvas.drawLine(Offset(x, y), Offset(x + 13, y + 13), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => false;
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({required this.section});

  final HomeCatalogSection section;

  @override
  Widget build(BuildContext context) {
    final isSeasonal = section.section.id == 'seasonal';
    final isPopular = section.section.id == 'popular';
    final isOrderAgain = section.section.id == 'order_again';
    final title = isPopular ? 'Popular 🔥' : section.section.title;
    final cardWidth = isSeasonal ? 265.0 : 176.0;
    final imageHeight = isSeasonal
        ? 176.0
        : isPopular
        ? 266.0
        : 178.0;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 21),
                  ),
                ),
                Material(
                  color: AppColors.surface,
                  shape: const CircleBorder(),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textPrimary,
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (section.products.isEmpty)
            const _EmptyCatalog(message: 'Nothing here yet.')
          else
            SizedBox(
              height: imageHeight + 78,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: section.products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 18),
                itemBuilder: (context, index) {
                  final product = section.products[index];
                  return _ProductCard(
                    product: product,
                    width: cardWidth,
                    imageHeight: imageHeight,
                    imageFit: isSeasonal ? BoxFit.cover : BoxFit.contain,
                    showDiscount: isSeasonal || isOrderAgain,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.width,
    required this.imageHeight,
    required this.imageFit,
    required this.showDiscount,
  });

  final Product product;
  final double width;
  final double imageHeight;
  final BoxFit imageFit;
  final bool showDiscount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => context.push('/product', extra: product),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AppColors.surface),
                    _CatalogImage(path: product.imageUrl, fit: imageFit),
                    if (showDiscount)
                      if (product.discountPercent case final discount?)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: _PillBadge(label: '$discount% off'),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.promotionalBadge,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _NearbyShops extends StatelessWidget {
  const _NearbyShops({required this.shops});

  final List<DbShop> shops;

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: _EmptyCatalog(message: 'No nearby shops found.'),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    return CustomPaint(
      painter: _ShopLandscapePainter(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 24, 24, 0),
            child: Text(
              "There are ${shops.length} J'Donut shops near you. 😊",
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textInverse,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 16, 24, 0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'EXPLORE NOW',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 286,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: width * 0.097),
              scrollDirection: Axis.horizontal,
              itemCount: shops.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) =>
                  _ShopCard(shop: shops[index], width: width * 0.716),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop, required this.width});

  final DbShop shop;
  final double width;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            width: double.infinity,
            height: 145,
            child: _CatalogImage(path: shop.image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          shop.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          shop.address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Order Online',
          style: AppTextStyles.titleSmall.copyWith(color: AppColors.secondary),
        ),
      ],
    ),
  );
}

class _ShopLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sky = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.promoCyan],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sky);

    final farHill = Path()
      ..moveTo(0, size.height - 98)
      ..cubicTo(
        size.width * 0.24,
        size.height - 190,
        size.width * 0.42,
        size.height - 5,
        size.width * 0.68,
        size.height - 86,
      )
      ..cubicTo(
        size.width * 0.82,
        size.height - 138,
        size.width * 0.91,
        size.height - 104,
        size.width,
        size.height - 125,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(farHill, Paint()..color = AppColors.shopLandscapeFar);

    final nearHill = Path()
      ..moveTo(0, size.height - 42)
      ..cubicTo(
        size.width * 0.32,
        size.height - 104,
        size.width * 0.63,
        size.height - 28,
        size.width,
        size.height - 78,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(nearHill, Paint()..color = AppColors.shopLandscapeNear);

    final grass = Paint()
      ..color = AppColors.shopLandscapeNear
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var index = 0; index < 18; index++) {
      final x = size.width * index / 17;
      final y = size.height - 37 - (index.isEven ? 0 : 7);
      canvas.drawLine(Offset(x, y), Offset(x + 4, y - 15), grass);
    }
  }

  @override
  bool shouldRepaint(covariant _ShopLandscapePainter oldDelegate) => false;
}

class _CatalogImage extends StatelessWidget {
  const _CatalogImage({required this.path, required this.fit});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: fit, errorBuilder: _imageErrorBuilder);
    }
    return Image.asset(path, fit: fit, errorBuilder: _imageErrorBuilder);
  }
}

Widget _imageErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) => const Center(
  child: Icon(
    Icons.image_not_supported_outlined,
    color: AppColors.textSecondary,
  ),
);

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Text(message, style: AppTextStyles.bodySmall),
  );
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Row(
        children: [
          _SkeletonBlock(width: 50, height: 50, radius: 25),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(width: 130, height: 18),
                SizedBox(height: 8),
                _SkeletonBlock(width: 90, height: 12),
              ],
            ),
          ),
          _SkeletonBlock(width: 44, height: 44, radius: 22),
        ],
      ),
      const SizedBox(height: 22),
      const _SkeletonBlock(height: 160, radius: 22),
      const SizedBox(height: 24),
      const _SkeletonBlock(width: 150, height: 20),
      const SizedBox(height: 14),
      const Row(
        children: [
          Expanded(child: _SkeletonBlock(height: 190, radius: 16)),
          SizedBox(width: 12),
          Expanded(child: _SkeletonBlock(height: 190, radius: 16)),
        ],
      ),
    ],
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({this.width, required this.height, this.radius = 8});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.disabledSurface,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _HomeLoadError extends StatelessWidget {
  const _HomeLoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: AppColors.textSecondary,
            size: 36,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).storageFailure,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    ),
  );
}

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _icons = [
    AppIcons.home,
    AppIcons.crown,
    AppIcons.order,
    AppIcons.wallet,
    AppIcons.settings,
  ];
  static const _labels = ['Home', 'Reward', 'Order', 'Wallet', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 350;
    const navigationHeight = 68.0;
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: navigationHeight,
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                for (var index = 0; index < _icons.length; index++)
                  Expanded(
                    flex: index == selectedIndex ? (compact ? 8 : 7) : 5,
                    child: Semantics(
                      button: true,
                      label: _labels[index],
                      selected: index == selectedIndex,
                      child: InkWell(
                        onTap: () => onSelected(index),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: index == selectedIndex
                                ? EdgeInsets.symmetric(
                                    horizontal: compact ? 4 : 8,
                                    vertical: 8,
                                  )
                                : EdgeInsets.zero,
                            decoration: index == selectedIndex
                                ? BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppColors.textInverse,
                                      width: 1,
                                    ),
                                  )
                                : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  _icons[index],
                                  width: compact ? 18 : 20,
                                  height: compact ? 18 : 20,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.textInverse,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (index == selectedIndex) ...[
                                  SizedBox(width: compact ? 4 : 6),
                                  Text(
                                    _labels[index],
                                    style:
                                        (compact
                                                ? AppTextStyles.labelSmall
                                                      .copyWith(fontSize: 9)
                                                : AppTextStyles.labelSmall)
                                            .copyWith(
                                              color: AppColors.textInverse,
                                              fontWeight: FontWeight.w600,
                                            ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
