part of 'member_home_screen.dart';

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
  Timer? _autoPlayTimer;
  var _reduceMotion = false;
  var _motionInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_motionInitialized && _reduceMotion == reduceMotion) return;
    _motionInitialized = true;
    _reduceMotion = reduceMotion;
    _updateAutoPlay();
  }

  void _updateAutoPlay() {
    _autoPlayTimer?.cancel();
    if (_reduceMotion || widget.banners.length < 2) return;
    _autoPlayTimer = Timer.periodic(AppMotion.bannerAutoPlay, (_) {
      if (!_controller.hasClients || !mounted) return;
      final currentPage = _controller.page?.round() ?? 0;
      final nextPage = (currentPage + 1) % widget.banners.length;
      _controller.animateToPage(
        nextPage,
        duration: AppMotion.bannerSlide,
        curve: AppMotion.rewardsCurve,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
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
