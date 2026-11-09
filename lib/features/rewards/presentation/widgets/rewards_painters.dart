import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';

class RewardsRingPainter extends CustomPainter {
  const RewardsRingPainter({required this.progress});

  static const _sprinklePositions = <double>[
    0.018,
    0.072,
    0.126,
    0.181,
    0.237,
    0.293,
    0.347,
    0.402,
    0.458,
    0.513,
    0.568,
    0.624,
    0.679,
    0.735,
    0.791,
    0.846,
    0.902,
    0.958,
  ];

  static const _sprinkleAngles = <double>[
    -0.72,
    0.28,
    0.68,
    -0.18,
    0.48,
    -0.55,
    0.12,
    0.76,
    -0.35,
    0.42,
    -0.68,
    0.2,
    0.58,
    -0.12,
    0.72,
    -0.43,
    0.32,
    -0.62,
  ];

  static const _sprinkleLengths = <double>[
    0.24,
    0.2,
    0.27,
    0.22,
    0.25,
    0.19,
    0.28,
    0.21,
    0.26,
    0.2,
    0.24,
    0.22,
    0.27,
    0.19,
    0.25,
    0.22,
    0.2,
    0.26,
  ];

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final strokeWidth = size.width * 0.21;
    final radius = (size.width - strokeWidth) / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final track = Paint()
      ..color = AppColors.homeBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, track);

    final sweep = progress.clamp(0, 1) * math.pi * 2;
    if (sweep > 0) {
      final ring = Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.secondary, AppColors.rewardRingHighlight],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        ).createShader(bounds)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(bounds, -math.pi / 2, sweep, false, ring);
      _drawSprinkles(canvas, center, radius, strokeWidth);
    }

    canvas.drawCircle(
      center,
      radius - strokeWidth * 0.53,
      Paint()..color = AppColors.surface,
    );
  }

  void _drawSprinkles(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
  ) {
    const colors = [
      AppColors.rewardSprinkleWhite,
      AppColors.rewardSprinkleLight,
      AppColors.rewardSprinkleWhite,
      AppColors.rewardSprinkleMid,
    ];
    for (var index = 0; index < _sprinklePositions.length; index++) {
      final position = _sprinklePositions[index];
      if (position >= progress) break;
      final angle = -math.pi / 2 + math.pi * 2 * position;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      final sprinkleAngle = angle + math.pi / 2 + _sprinkleAngles[index];
      final direction = Offset(
        math.cos(sprinkleAngle),
        math.sin(sprinkleAngle),
      );
      final halfLength = strokeWidth * _sprinkleLengths[index] / 2;
      final paint = Paint()
        ..color = colors[index % colors.length]
        ..strokeWidth = math.max(2, strokeWidth * 0.055)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        point - direction * halfLength,
        point + direction * halfLength,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(RewardsRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class TierLadderPainter extends CustomPainter {
  const TierLadderPainter({
    required this.tierCount,
    required this.currentIndex,
    required this.progress,
  });

  final int tierCount;
  final int currentIndex;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (tierCount < 2) return;
    final centerX = size.width / 2;
    final stepHeight = size.height / tierCount;
    final top = stepHeight / 2;
    final bottom = size.height - stepHeight / 2;
    final track = Paint()
      ..color = AppColors.border
      ..strokeWidth = 2;
    canvas.drawLine(Offset(centerX, top), Offset(centerX, bottom), track);

    if (currentIndex < 0 || currentIndex >= tierCount - 1) return;
    final startY = top + currentIndex * stepHeight;
    final endY = startY + stepHeight * progress.clamp(0, 1);
    canvas.drawLine(
      Offset(centerX, startY),
      Offset(centerX, endY),
      Paint()
        ..color = AppColors.secondary
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(TierLadderPainter oldDelegate) =>
      oldDelegate.tierCount != tierCount ||
      oldDelegate.currentIndex != currentIndex ||
      oldDelegate.progress != progress;
}

class TierShieldPainter extends CustomPainter {
  const TierShieldPainter({
    required this.color,
    required this.isCurrent,
    required this.letter,
  });

  final Color color;
  final bool isCurrent;
  final String letter;

  @override
  void paint(Canvas canvas, Size size) {
    final shield = Path()
      ..moveTo(size.width / 2, size.height * 0.04)
      ..lineTo(size.width * 0.94, size.height * 0.22)
      ..lineTo(size.width * 0.87, size.height * 0.67)
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.89,
        size.width / 2,
        size.height * 0.98,
      )
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.89,
        size.width * 0.13,
        size.height * 0.67,
      )
      ..lineTo(size.width * 0.06, size.height * 0.22)
      ..close();
    canvas.drawShadow(shield, color.withValues(alpha: 0.18), 2, true);
    canvas.drawPath(shield, Paint()..color = color.withValues(alpha: 0.3));
    canvas.drawPath(
      shield,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isCurrent ? 2 : 1,
    );
    _drawStar(canvas, Offset(size.width * 0.34, size.height * 0.31), 4, color);
    _drawStar(canvas, Offset(size.width * 0.66, size.height * 0.31), 4, color);
    _drawCenteredText(canvas, size, letter, baseline: size.height * 0.72);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final points = <Offset>[];
    for (var index = 0; index < 10; index++) {
      final angle = -math.pi / 2 + index * math.pi / 5;
      final pointRadius = index.isEven ? radius : radius * 0.45;
      points.add(
        center + Offset(math.cos(angle), math.sin(angle)) * pointRadius,
      );
    }
    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawCenteredText(
    Canvas canvas,
    Size size,
    String text, {
    required double baseline,
  }) {
    if (text.isEmpty) return;
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: size.width * 0.32,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        baseline - textPainter.height,
      ),
    );
  }

  @override
  bool shouldRepaint(TierShieldPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.isCurrent != isCurrent ||
      oldDelegate.letter != letter;
}

class DonutProgressClipper extends CustomClipper<Path> {
  const DonutProgressClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    if (progress >= 1) return Path()..addRect(Offset.zero & size);
    final center = size.center(Offset.zero);
    final radius = size.longestSide;
    return Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(
        center.dx + math.cos(-math.pi / 2) * radius,
        center.dy + math.sin(-math.pi / 2) * radius,
      )
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 2 * progress.clamp(0, 1),
        false,
      )
      ..close();
  }

  @override
  bool shouldReclip(DonutProgressClipper oldClipper) =>
      oldClipper.progress != progress;
}

class CoffeeProgressPainter extends CustomPainter {
  const CoffeeProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final arcBounds = Rect.fromLTWH(
      size.width * 0.12,
      size.height * 0.02,
      size.width * 0.76,
      size.height * 0.76,
    );
    final strokeWidth = size.width * 0.055;
    canvas.drawArc(
      arcBounds,
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = AppColors.homeBackground
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      arcBounds,
      math.pi,
      math.pi * progress.clamp(0, 1),
      false,
      Paint()
        ..color = AppColors.tertiary
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(CoffeeProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
