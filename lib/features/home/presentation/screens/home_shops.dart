part of 'member_home_screen.dart';

class _NearbyShops extends StatelessWidget {
  const _NearbyShops({required this.shops});

  final List<DbShop> shops;

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: _EmptyCatalog(messageKey: _EmptyCatalogMessage.noNearbyShops),
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
              AppLocalizations.of(context).nearbyShopsCount(shops.length),
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
                AppLocalizations.of(context).exploreNow,
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
          AppLocalizations.of(context).orderOnline,
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
    return AppImage(path: path, fit: fit);
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog({required this.messageKey});

  final _EmptyCatalogMessage messageKey;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Text(switch (messageKey) {
      _EmptyCatalogMessage.noProductSections => AppLocalizations.of(
        context,
      ).noProductSections,
      _EmptyCatalogMessage.noProducts => AppLocalizations.of(
        context,
      ).noProducts,
      _EmptyCatalogMessage.noNearbyShops => AppLocalizations.of(
        context,
      ).noNearbyShops,
    }, style: AppTextStyles.bodySmall),
  );
}

enum _EmptyCatalogMessage { noProductSections, noProducts, noNearbyShops }
