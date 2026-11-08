import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/registration_draft.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';

part 'registration_state.freezed.dart';

@freezed
abstract class RegistrationState with _$RegistrationState {
  const factory RegistrationState({
    @Default(true) bool isRegistration,
    @Default(false) bool phoneSubmitted,
    @Default(false) bool otpVerified,
    @Default(false) bool nameCompleted,
    @Default(RegistrationDraft()) RegistrationDraft draft,
    @Default(false) bool isLoading,
    PhoneError? phoneError,
    NameError? nameError,
    DobError? dobError,
    AuthFailure? failure,
  }) = _RegistrationState;
}
