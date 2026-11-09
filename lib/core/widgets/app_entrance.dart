import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

class AppEntrance extends StatelessWidget {
  const AppEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppMotion.screenEntrance,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final totalDuration = delay + duration;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduceMotion ? Duration.zero : totalDuration,
      curve: AppMotion.rewardsCurve,
      child: child,
      builder: (context, value, child) {
        final progress = reduceMotion
            ? 1.0
            : ((value * totalDuration.inMicroseconds - delay.inMicroseconds) /
                      duration.inMicroseconds)
                  .clamp(0.0, 1.0);
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, (1 - progress) * AppMotion.entranceOffset),
            child: child,
          ),
        );
      },
    );
  }
}
