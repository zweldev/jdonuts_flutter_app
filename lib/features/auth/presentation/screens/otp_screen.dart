import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' as material_ui;
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_design_system.dart';
import '../../domain/auth_constants.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../auth_failure_message.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';
import '../cubit/registration_cubit.dart';
import '../widgets/auth_step_scaffold.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _shakeController;
  late final OtpCubit _otpCubit;

  @override
  void initState() {
    super.initState();
    _otpCubit = context.read<OtpCubit>();
    _controller.text = _otpCubit.state.code;
    _otpCubit.startCountdown();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _otpCubit.leaveStep();
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final success = await _otpCubit.submit(_controller.text);
    if (!mounted) return;
    if (success && context.read<RegistrationCubit>().state.isRegistration) {
      _otpCubit.leaveStep();
      context.push('/name');
      return;
    }
    if (!success && _otpCubit.state.failure != null) {
      _controller.clear();
      _shakeController.forward(from: 0);
    }
  }

  Future<void> _resend() async {
    if (await _otpCubit.resend() && mounted) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubit, OtpState>(
      buildWhen: (previous, current) =>
          previous.attempts != current.attempts ||
          previous.isLocked != current.isLocked ||
          previous.isLoading != current.isLoading ||
          previous.failure != current.failure,
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final registration = context.read<RegistrationCubit>().state;
        final phoneNumber =
            '$phoneCountryPrefix${normalizePhoneNumber(registration.draft.phone)}';
        final canContinue =
            _controller.text.length == otpLength &&
            !state.isLocked &&
            !state.isLoading;
        final defaultPinTheme = PinTheme(
          width: 46,
          height: 54,
          textStyle: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
            border: Border.fromBorderSide(BorderSide(color: AppColors.surface)),
          ),
        );
        final errorPinTheme = defaultPinTheme.copyDecorationWith(
          border: const Border.fromBorderSide(
            BorderSide(color: AppColors.secondary),
          ),
        );
        return AuthStepScaffold(
          title: l10n.otpTitle,
          titleTextAlign: TextAlign.center,
          progress: 0.5,
          onBack: () {
            _otpCubit.leaveStep();
            context.pop();
          },
          continueLabel: l10n.verifyLabel,
          isContinueEnabled: canContinue,
          isLoading: state.isLoading,
          onContinue: _verify,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.otpSentTo(otpLength, phoneNumber),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(
                    math.sin(_shakeController.value * math.pi * 6) * 7,
                    0,
                  ),
                  child: child,
                ),
                child: Center(
                  child: Semantics(
                    label: l10n.otpSemanticsLabel(otpLength),
                    child: material_ui.Material(
                      color: Colors.transparent,
                      child: Pinput(
                        key: const ValueKey('otp_pinput'),
                        length: otpLength,
                        controller: _controller,
                        enabled: !state.isLocked,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        showCursor: false,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme,
                        submittedPinTheme: defaultPinTheme,
                        followingPinTheme: defaultPinTheme,
                        errorPinTheme: errorPinTheme,
                        forceErrorState: state.failure != null,
                        separatorBuilder: (_) => const SizedBox(width: 7),
                        onChanged: (_) {
                          _otpCubit.codeChanged(_controller.text);
                          setState(() {});
                        },
                        onSubmitted: (_) => _verify(),
                      ),
                    ),
                  ),
                ),
              ),
              if (state.failure != null) ...[
                const SizedBox(height: 9),
                Text(
                  state.isLocked
                      ? l10n.otpLocked
                      : authFailureMessage(l10n, state.failure!),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l10n.otpNoCode, style: AppTextStyles.bodySmall),
                  _OtpResendButton(
                    isLoading: state.isLoading,
                    onResend: _resend,
                  ),
                ],
              ),
              if (!registration.isRegistration && state.failure is UserNotFound)
                TextButton(
                  onPressed: () {
                    context.read<RegistrationCubit>().beginRegistration();
                    context.pop();
                  },
                  child: Text(l10n.registerNewAccount),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _OtpResendButton extends StatelessWidget {
  const _OtpResendButton({required this.isLoading, required this.onResend});

  final bool isLoading;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OtpCubit, OtpState, int>(
      selector: (state) => state.secondsUntilResend,
      builder: (context, secondsUntilResend) {
        final l10n = AppLocalizations.of(context);
        final time = Duration(seconds: secondsUntilResend);
        final countdown =
            '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';
        return TextButton(
          onPressed: secondsUntilResend == 0 && !isLoading ? onResend : null,
          child: Text(
            secondsUntilResend == 0
                ? l10n.resendCode
                : l10n.resendCountdown(countdown),
          ),
        );
      },
    );
  }
}
