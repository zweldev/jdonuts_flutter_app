class RegistrationDraft {
  const RegistrationDraft({
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth,
  });

  final String phone;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;

  RegistrationDraft copyWith({
    String? phone,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
  }) {
    return RegistrationDraft(
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}
