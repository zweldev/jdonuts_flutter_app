import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../domain/auth_constants.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../auth_failure_message.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/auth_step_scaffold.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _blurred = false;

  RegistrationCubit get _registration => context.read<RegistrationCubit>();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<RegistrationCubit>().state.draft.phone;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _blurred = true;
      _registration.phoneFocusLost();
    }
  }

  Future<void> _continue() async {
    if (!await _registration.submitPhone() || !mounted) return;
    context.push('/otp');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final phoneError =
            state.phoneError ??
            (_blurred && validatePhoneNumber(_controller.text) != null
                ? PhoneError.invalid
                : null);
        final isValid = validatePhoneNumber(_controller.text) == null;
        return AuthStepScaffold(
          title: l10n.phoneTitle,
          progress: 0.25,
          onBack: () => context.pop(),
          continueLabel: l10n.continueLabel,
          isContinueEnabled: isValid && !state.isLoading,
          isLoading: state.isLoading,
          onContinue: _continue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: phoneError == null
                        ? AppColors.surface
                        : AppColors.secondary.withValues(alpha: 0.4),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      l10n.phoneCountryPrefix,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9\s-]'),
                          ),
                        ],
                        onChanged: (value) {
                          _registration.phoneChanged(value);
                          setState(() {});
                        },
                        onSubmitted: (_) => _continue(),
                        decoration:
                            authInputDecoration(hint: l10n.phoneNumberHint)
                                .copyWith(
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  errorText: phoneError == null
                                      ? null
                                      : _phoneErrorText(l10n, phoneError),
                                  errorStyle: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(l10n.phoneHelp(otpLength), style: AppTextStyles.bodySmall),
              if (state.failure != null) ...[
                const SizedBox(height: 10),
                Text(
                  authFailureMessage(l10n, state.failure!),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                if (state.failure is UserNotFound)
                  TextButton(
                    onPressed: _registration.beginRegistration,
                    child: Text(l10n.registerNewAccount),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

String _phoneErrorText(AppLocalizations l10n, PhoneError error) =>
    switch (error) {
      PhoneError.empty => l10n.phoneEmpty,
      PhoneError.invalid => l10n.phoneInvalid(phoneCountryPrefix),
    };
