import 'package:flutter/material.dart';

import '../network/connectivity_monitor.dart';
import '../theme/app_design_system.dart';
import '../../l10n/app_localizations.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key, required this.monitor});

  final ConnectivityMonitor? monitor;

  @override
  Widget build(BuildContext context) {
    final connectivity = monitor;
    if (connectivity == null) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: connectivity,
      builder: (context, _) {
        if (connectivity.isOnline) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          color: AppColors.textPrimary,
          child: Text(
            AppLocalizations.of(context).offlineBanner,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textInverse,
            ),
          ),
        );
      },
    );
  }
}
