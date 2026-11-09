import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_design_system.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    required this.fit,
    this.alignment = Alignment.center,
  });

  final String path;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        alignment: alignment,
        placeholder: (context, url) => const _ImagePlaceholder(),
        errorWidget: (context, url, error) => const _ImageError(),
      );
    }
    return Image.asset(
      path,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) => const _ImageError(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: AppColors.surface,
    child: Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: AppColors.surface,
    child: Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSecondary,
      ),
    ),
  );
}
