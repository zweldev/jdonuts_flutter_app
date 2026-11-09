import 'package:flutter/material.dart';

import '../../l10n/app_locale_controller.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_design_system.dart';

Future<void> showAppSettingsSheet(
  BuildContext context, {
  required VoidCallback onLogOut,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => _AppSettingsSheet(onLogOut: onLogOut),
  );
}

class _AppSettingsSheet extends StatelessWidget {
  const _AppSettingsSheet({required this.onLogOut});

  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeController = AppLocaleScope.of(context);
    final useBurmese = localeController.locale.languageCode == 'my';

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              0,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(l10n.settingsTitle, style: AppTextStyles.titleLarge),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.language_rounded),
            title: Text(l10n.languageLabel),
            subtitle: Text(
              useBurmese ? l10n.burmeseLanguage : l10n.englishLanguage,
            ),
            value: useBurmese,
            onChanged: (enabled) =>
                localeController.setLocale(Locale(enabled ? 'my' : 'en')),
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(l10n.logout),
            onTap: () {
              Navigator.pop(context);
              onLogOut();
            },
          ),
        ],
      ),
    );
  }
}
