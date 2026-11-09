part of 'member_home_screen.dart';

class _HomeSkeleton extends StatefulWidget {
  const _HomeSkeleton();

  @override
  State<_HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<_HomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: AppMotion.shimmerCycle,
  );
  var _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion == reduceMotion &&
        _shimmer.isAnimating == !reduceMotion) {
      return;
    }
    _reduceMotion = reduceMotion;
    if (reduceMotion) {
      _shimmer.stop();
      _shimmer.value = 0.5;
    } else {
      _shimmer.repeat();
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _shimmer,
    builder: (context, _) => ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        final shift = _reduceMotion ? 0.0 : _shimmer.value * 2 - 1;
        return LinearGradient(
          begin: Alignment(shift, 0),
          end: Alignment(shift + 1, 0),
          colors: const [
            AppColors.disabledSurface,
            AppColors.surface,
            AppColors.disabledSurface,
          ],
        ).createShader(bounds);
      },
      child: ListView(
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
      ),
    ),
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
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).rewardsRetry),
          ),
        ],
      ),
    ),
  );
}
