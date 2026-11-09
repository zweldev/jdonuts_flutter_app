import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../../../database/app_database.dart';
import '../../../../database/daos/cart_dao.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.cartDao,
  });

  final Product product;
  final CartDao cartDao;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  Future<void> _addToCart() async {
    setState(() => _isAddingToCart = true);
    try {
      await widget.cartDao.addProduct(
        productId: widget.product.id,
        quantity: _quantity,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} added to cart.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'product detail cart action',
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not add this product to your cart.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.homeBackground,
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.iconPrimary,
                iconSize: AppDimensions.iconLarge,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final panelHeight =
                    (constraints.maxHeight * 0.62).clamp(360.0, 520.0) * 1.2;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      _ProductPanel(
                        product: widget.product,
                        quantity: _quantity,
                        height: panelHeight,
                        onDecrement: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                        onIncrement: () => setState(() => _quantity++),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _ProductDescription(
                        description: widget.product.description,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                );
              },
            ),
          ),
          _AddToCartButton(
            quantity: _quantity,
            priceMmk: widget.product.priceMmk,
            isLoading: _isAddingToCart,
            onPressed: _addToCart,
          ),
        ],
      ),
    ),
  );
}

class _ProductPanel extends StatelessWidget {
  const _ProductPanel({
    required this.product,
    required this.quantity,
    required this.height,
    required this.onDecrement,
    required this.onIncrement,
  });

  final Product product;
  final int quantity;
  final double height;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: AppSpacing.lg,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.code,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    if (product.isNew)
                      const _ProductBadge(label: 'New')
                    else if (product.discountPercent case final discount?)
                      _ProductBadge(label: '$discount%'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 30,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${_formatPrice(product.priceMmk)} MMK',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: _ProductImage(path: product.imageUrl),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: _QuantityControl(
              quantity: quantity,
              onDecrement: onDecrement,
              onIncrement: onIncrement,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProductBadge extends StatelessWidget {
  const _ProductBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.tertiary,
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Text(
        label,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final image = path.startsWith('http')
        ? Image.network(path, fit: BoxFit.contain)
        : Image.asset(path, fit: BoxFit.contain);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: image,
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xs,
    ),
    decoration: BoxDecoration(
      color: AppColors.homeBackground,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      border: Border.all(color: AppColors.surface, width: 2),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QuantityButton(
          icon: Icons.remove_rounded,
          onPressed: onDecrement,
          tooltip: 'Decrease quantity',
        ),
        SizedBox(
          width: 72,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLarge,
          ),
        ),
        _QuantityButton(
          icon: Icons.add_rounded,
          onPressed: onIncrement,
          tooltip: 'Increase quantity',
        ),
      ],
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 40,
    height: 40,
    child: IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: AppDimensions.iconLarge),
    ),
  );
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 76,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.help_rounded,
              color: AppColors.success,
              size: AppDimensions.iconMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "What's\nthis?",
              style: AppTextStyles.headlineSmall.copyWith(height: 1.15),
            ),
          ],
        ),
      ),
      Container(
        width: 1,
        height: 116,
        margin: const EdgeInsets.only(right: AppSpacing.md),
        color: AppColors.surface,
      ),
      Expanded(
        child: Text(
          description,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({
    required this.quantity,
    required this.priceMmk,
    required this.isLoading,
    required this.onPressed,
  });

  final int quantity;
  final int priceMmk;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.md,
    ),
    child: SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary,
          shape: const StadiumBorder(),
        ),
        child: isLoading
            ? const SizedBox(
                width: AppDimensions.loaderSize,
                height: AppDimensions.loaderSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.loaderStrokeWidth,
                  color: AppColors.textInverse,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ADD TO CART',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textInverse,
                      letterSpacing: 1,
                    ),
                  ),
                  Container(
                    height: AppSpacing.xl,
                    width: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    color: AppColors.textInverse.withValues(alpha: 0.7),
                  ),
                  Text(
                    '${_formatPrice(priceMmk * quantity)} MMK',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textInverse,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

String _formatPrice(int price) => price.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (match) => ',',
);
