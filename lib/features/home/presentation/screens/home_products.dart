part of 'member_home_screen.dart';

class _ProductSection extends StatefulWidget {
  const _ProductSection({required this.section, required this.homeDao});

  final HomeCatalogSection section;
  final HomeDao? homeDao;

  @override
  State<_ProductSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends State<_ProductSection> {
  late Future<List<Product>> _products = _loadProducts();

  Future<List<Product>> _loadProducts() =>
      widget.homeDao?.loadSectionProducts(widget.section.section.id) ??
      Future.value(widget.section.products);

  void _retry() => setState(() => _products = _loadProducts());

  @override
  Widget build(BuildContext context) {
    final section = widget.section;
    final isSeasonal = section.section.id == 'seasonal';
    final isPopular = section.section.id == 'popular';
    final isOrderAgain = section.section.id == 'order_again';
    final title = isPopular
        ? AppLocalizations.of(context).popularSectionTitle
        : section.section.title;
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
          FutureBuilder<List<Product>>(
            future: _products,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _ProductSectionError(onRetry: _retry);
              }
              if (!snapshot.hasData) {
                return SizedBox(
                  height: imageHeight + 78,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    children: [
                      _SectionSkeleton(width: cardWidth, height: imageHeight),
                      const SizedBox(width: 18),
                      _SectionSkeleton(width: cardWidth, height: imageHeight),
                    ],
                  ),
                );
              }
              final products = snapshot.data!;
              if (products.isEmpty) {
                return const _EmptyCatalog(
                  messageKey: _EmptyCatalogMessage.noProducts,
                );
              }
              return SizedBox(
                height: imageHeight + 78,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 18),
                  itemBuilder: (context, index) => _ProductCard(
                    product: products[index],
                    width: cardWidth,
                    imageHeight: imageHeight,
                    imageFit: isSeasonal ? BoxFit.cover : BoxFit.contain,
                    showDiscount: isSeasonal || isOrderAgain,
                    heroTag: '${section.section.id}/${products[index].id}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.disabledSurface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
  );
}

class _ProductSectionError extends StatelessWidget {
  const _ProductSectionError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Row(
      children: [
        Expanded(child: Text(AppLocalizations.of(context).sectionLoadError)),
        TextButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).rewardsRetry),
        ),
      ],
    ),
  );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.width,
    required this.imageHeight,
    required this.imageFit,
    required this.showDiscount,
    required this.heroTag,
  });

  final Product product;
  final double width;
  final double imageHeight;
  final BoxFit imageFit;
  final bool showDiscount;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => context.push(
          '/product/${Uri.encodeComponent(product.id)}',
          extra: heroTag,
        ),
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
                    Hero(
                      tag: heroTag,
                      child: _CatalogImage(
                        path: product.imageUrl,
                        fit: imageFit,
                      ),
                    ),
                    if (showDiscount)
                      if (product.discountPercent case final discount?)
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: _PillBadge(
                            label: AppLocalizations.of(context)
                                .discountPercentOff(discount),
                          ),
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
