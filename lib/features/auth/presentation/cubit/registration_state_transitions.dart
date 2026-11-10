import '../../domain/validators/auth_validators.dart';
import 'registration_state.dart';

extension RegistrationStateTransitions on RegistrationState {
  RegistrationState withPhone(String input) => copyWith(
    draft: draft.copyWith(phone: input),
    phoneError: phoneError == null ? null : validatePhoneNumber(input),
    failure: null,
  );

  RegistrationState withPhoneError() =>
      copyWith(phoneError: validatePhoneNumber(draft.phone));

  RegistrationState withName(String firstName, String lastName) {
    final updatedDraft = draft.copyWith(
      firstName: firstName,
      lastName: lastName,
    );
    return copyWith(
      draft: updatedDraft,
      nameError:
          validateName(updatedDraft.firstName, isRequired: true) ??
          validateName(updatedDraft.lastName, isRequired: false),
      failure: null,
    );
  }

  NameError? get nameValidationError =>
      validateName(draft.firstName, isRequired: true) ??
      validateName(draft.lastName, isRequired: false);

  RegistrationState startDateOfBirth() =>
      copyWith(nameError: null, dobError: null);

  RegistrationState withDateOfBirth(
    DateTime dateOfBirth, {
    required DateTime now,
  }) {
    final updatedDraft = draft.copyWith(dateOfBirth: dateOfBirth);
    return copyWith(
      draft: updatedDraft,
      dobError: validateDateOfBirth(updatedDraft.dateOfBirth, now: now),
      failure: null,
    );
  }

  DobError? dateErrorAt(DateTime now) =>
      validateDateOfBirth(draft.dateOfBirth, now: now);
}
