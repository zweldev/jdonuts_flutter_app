import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/auth_constants.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';
import 'registration_cubit.dart';
import 'session_cubit.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(
    this._repository,
    this._registrationCubit,
    this._sessionCubit, {
    this.tickDuration = const Duration(seconds: 1),
  }) : super(const OtpState());

  final AuthRepository _repository;
  final RegistrationCubit _registrationCubit;
  final SessionCubit _sessionCubit;
  final Duration tickDuration;
  Timer? _timer;

  void startCountdown() {
    _timer?.cancel();
    if (state.secondsUntilResend == 0) return;
    _timer = Timer.periodic(tickDuration, (_) {
      if (isClosed) return;
      if (state.secondsUntilResend <= 1) {
        _timer?.cancel();
        emit(state.copyWith(secondsUntilResend: 0));
      } else {
        emit(state.copyWith(secondsUntilResend: state.secondsUntilResend - 1));
      }
    });
  }

  Future<bool> submit(String code) async {
    if (state.isLoading || state.isLocked || code.length != otpLength) {
      return false;
    }
    if (!_registrationCubit.state.phoneSubmitted) return false;
    if (state.code != code) emit(state.copyWith(code: code));
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await _repository.verifyOtp(_phoneNumber, code);
    if (isClosed) return false;
    switch (result) {
      case Failure<void>(error: InvalidOtp()):
        final attempts = state.attempts + 1;
        emit(
          state.copyWith(
            isLoading: false,
            attempts: attempts,
            isLocked: attempts >= maxOtpAttempts,
            failure: const InvalidOtp(),
            code: '',
          ),
        );
        return false;
      case Failure<void>(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        return false;
      case Success<void>():
        return _completeSignInOrRegistration();
    }
  }

  Future<bool> _completeSignInOrRegistration() async {
    if (_registrationCubit.state.isRegistration) {
      _registrationCubit.markOtpVerified();
      emit(state.copyWith(isLoading: false, failure: null));
      return true;
    }
    final result = await _repository.signIn(_phoneNumber);
    if (isClosed) return false;
    switch (result) {
      case Success():
        _sessionCubit.markLoggedIn();
        emit(state.copyWith(isLoading: false, failure: null));
        return true;
      case Failure(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        return false;
    }
  }

  Future<bool> resend() async {
    if (state.secondsUntilResend > 0 || state.isLoading) return false;
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await _repository.requestOtp(
      _phoneNumber,
      isRegistration: _registrationCubit.state.isRegistration,
    );
    if (isClosed) return false;
    switch (result) {
      case Success<void>():
        emit(
          state.copyWith(
            isLoading: false,
            attempts: 0,
            isLocked: false,
            secondsUntilResend: otpResendSeconds,
            code: '',
          ),
        );
        startCountdown();
        return true;
      case Failure<void>(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        return false;
    }
  }

  void codeChanged(String code) => emit(
    state.copyWith(code: code, failure: code.isEmpty ? state.failure : null),
  );

  void leaveStep() => _timer?.cancel();

  void reset() {
    leaveStep();
    emit(const OtpState());
  }

  String get _phoneNumber =>
      '$phoneCountryPrefix${normalizePhoneNumber(_registrationCubit.state.draft.phone)}';

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
