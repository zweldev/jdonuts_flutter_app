import 'package:bloc/bloc.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/entities/registration_draft.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/result.dart';
import '../../domain/validators/auth_validators.dart';
import 'session_cubit.dart';
import 'registration_state.dart';
import 'registration_state_transitions.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit(
    this._repository,
    this._sessionCubit, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const RegistrationState());

  final AuthRepository _repository;
  final SessionCubit _sessionCubit;
  final DateTime Function() _now;

  void beginRegistration() => _beginAuth(isRegistration: true);

  void beginLogin() => _beginAuth(isRegistration: false);

  void resetFlow() => emit(const RegistrationState());

  void phoneChanged(String input) {
    emit(state.withPhone(input));
  }

  void phoneFocusLost() => emit(state.withPhoneError());

  void _beginAuth({required bool isRegistration}) {
    emit(
      state.copyWith(
        isRegistration: isRegistration,
        phoneSubmitted: false,
        otpVerified: false,
        nameCompleted: false,
        isLoading: false,
        phoneError: null,
        nameError: null,
        dobError: null,
        failure: null,
      ),
    );
  }

  Future<bool> submitPhone() async {
    final phone = state.draft.phone;
    if (state.isLoading || validatePhoneNumber(phone) != null) return false;
    emit(state.copyWith(isLoading: true, failure: null));
    final result = await _repository.requestOtp();
    if (isClosed) return false;
    switch (result) {
      case Success<void>():
        emit(state.copyWith(isLoading: false, phoneSubmitted: true));
        return true;
      case Failure<void>(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        return false;
    }
  }

  void nameChanged(String firstName, String lastName) {
    emit(state.withName(firstName, lastName));
  }

  Future<bool> submitName() async {
    if (state.isLoading ||
        state.nameCompleted ||
        !state.otpVerified ||
        !state.isRegistration) {
      return false;
    }
    final error = state.nameValidationError;
    if (error != null) {
      emit(state.copyWith(nameError: error));
      return false;
    }
    emit(state.startDateOfBirth().copyWith(nameCompleted: true, failure: null));
    return true;
  }

  void dateOfBirthChanged(DateTime dateOfBirth) {
    emit(state.withDateOfBirth(dateOfBirth, now: _now()));
  }

  Future<bool> submitDateOfBirth() async {
    if (!state.nameCompleted || !state.isRegistration) return false;
    final error = state.dateErrorAt(_now());
    if (error != null) {
      emit(state.copyWith(dobError: error));
      return false;
    }
    if (state.isLoading) return false;
    emit(state.copyWith(isLoading: true, failure: null));
    return _registerDraft();
  }

  Future<bool> _registerDraft() async {
    final user = _createUser(state.draft);
    final result = await _repository.register(user);
    if (isClosed) return false;
    return _handleRegistrationResult(result);
  }

  AuthUser _createUser(RegistrationDraft draft) => AuthUser(
    phoneNumber: _phoneNumber(draft),
    firstName: draft.firstName.trim(),
    lastName: draft.lastName.trim(),
    dateOfBirth: draft.dateOfBirth!,
  );

  String _phoneNumber(RegistrationDraft draft) =>
      canonicalPhoneNumber(draft.phone);

  bool _handleRegistrationResult(Result<void> result) {
    switch (result) {
      case Success<void>():
        _sessionCubit.markRegistered();
        emit(state.copyWith(isLoading: false));
        return true;
      case Failure<void>(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        return false;
    }
  }

  void markOtpVerified() {
    if (state.isRegistration) emit(state.copyWith(otpVerified: true));
  }
}
