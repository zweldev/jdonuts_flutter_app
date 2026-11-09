import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../domain/auth_constants.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../auth_failure_message.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/auth_step_scaffold.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  RegistrationCubit get _registration => context.read<RegistrationCubit>();

  @override
  void initState() {
    super.initState();
    final draft = context.read<RegistrationCubit>().state.draft;
    _firstName.text = draft.firstName;
    _lastName.text = draft.lastName;
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (await _registration.submitName() && mounted) {
      context.push('/dob');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final firstNameError = validateName(
          state.draft.firstName,
          isRequired: true,
        );
        final nameError = state.nameError ?? firstNameError;
        final isValid =
            firstNameError == null &&
            validateName(state.draft.lastName, isRequired: false) == null;
        return AuthStepScaffold(
          title: l10n.nameTitle,
          progress: 0.75,
          onBack: () => context.pop(),
          continueLabel: l10n.continueLabel,
          isContinueEnabled: isValid && !state.isLoading,
          isLoading: state.isLoading,
          onContinue: _continue,
          child: Column(
            children: [
              TextField(
                controller: _firstName,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) =>
                    _registration.nameChanged(value, _lastName.text),
                decoration: authInputDecoration(hint: l10n.firstNameHint)
                    .copyWith(errorText: _nameErrorText(l10n, nameError)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastName,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) =>
                    _registration.nameChanged(_firstName.text, value),
                decoration: authInputDecoration(hint: l10n.lastNameHint),
              ),
              if (state.failure != null) ...[
                const SizedBox(height: 12),
                Text(
                  authFailureMessage(l10n, state.failure!),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

String? _nameErrorText(AppLocalizations l10n, NameError? error) =>
    switch (error) {
      NameError.required => l10n.nameRequired,
      NameError.tooLong => l10n.nameTooLong(nameMaxLength),
      NameError.invalidCharacters => l10n.nameInvalid,
      null => null,
    };
