import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth_constants.dart';
import '../../domain/result.dart';

part 'otp_state.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    @Default('') String code,
    @Default(0) int attempts,
    @Default(false) bool isLocked,
    @Default(otpResendSeconds) int secondsUntilResend,
    @Default(false) bool isLoading,
    AuthFailure? failure,
  }) = _OtpState;
}
