class RegistrationDraft {
  const RegistrationDraft({
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirthMonth = '',
    this.dateOfBirthDay = '',
    this.dateOfBirthYear = '',
  });

  final String phone;
  final String firstName;
  final String lastName;
  final String dateOfBirthMonth;
  final String dateOfBirthDay;
  final String dateOfBirthYear;

  RegistrationDraft copyWith({
    String? phone,
    String? firstName,
    String? lastName,
    String? dateOfBirthMonth,
    String? dateOfBirthDay,
    String? dateOfBirthYear,
  }) {
    return RegistrationDraft(
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirthMonth: dateOfBirthMonth ?? this.dateOfBirthMonth,
      dateOfBirthDay: dateOfBirthDay ?? this.dateOfBirthDay,
      dateOfBirthYear: dateOfBirthYear ?? this.dateOfBirthYear,
    );
  }
}
