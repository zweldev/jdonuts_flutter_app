import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/core/theme/app_design_system.dart';

void main() {
  test('light theme exposes the brand palette and typography', () {
    final theme = AppTheme.light;
    final tokens = theme.extension<AppThemeExtension>()!;

    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.textTheme.displayLarge?.fontSize, 32);
    expect(theme.textTheme.bodyMedium?.fontSize, 14);
    expect(tokens.rewardPointsAccent, AppColors.rewardAccent);
    expect(tokens.promotionalBadge, AppColors.promotionalBadge);
  });

  test('custom theme tokens interpolate between themes', () {
    final start = AppThemeExtension.light;
    final end = start.copyWith(homeHeroBackground: Colors.black);
    final halfway = start.lerp(end, 0.5);

    expect(
      halfway.homeHeroBackground,
      Color.lerp(start.homeHeroBackground, Colors.black, 0.5),
    );
  });

  testWidgets('typography remains within the layout at 1.3x text scale', (
    tester,
  ) async {
    final textStyles = [
      AppTextStyles.displayLarge,
      AppTextStyles.displayMedium,
      AppTextStyles.displaySmall,
      AppTextStyles.headlineLarge,
      AppTextStyles.headlineMedium,
      AppTextStyles.headlineSmall,
      AppTextStyles.titleLarge,
      AppTextStyles.titleMedium,
      AppTextStyles.titleSmall,
      AppTextStyles.bodyLarge,
      AppTextStyles.bodyMedium,
      AppTextStyles.bodySmall,
      AppTextStyles.labelLarge,
      AppTextStyles.labelMedium,
      AppTextStyles.labelSmall,
    ];

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (final style in textStyles)
                    Text(
                      'J’Donuts accessibility typography',
                      style: style,
                      softWrap: true,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
