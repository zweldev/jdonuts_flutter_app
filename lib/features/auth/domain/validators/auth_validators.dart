import '../auth_constants.dart';

enum PhoneError { empty, invalid }

enum NameError { required, tooLong, invalidCharacters }

enum DobError { incomplete, inFuture, tooYoung }

String normalizePhoneNumber(String input) {
  var number = input.replaceAll(RegExp(r'[\s-]'), '');
  if (number.startsWith(phoneCountryPrefix)) {
    number = number.substring(phoneCountryPrefix.length);
  }
  if (number.startsWith('0')) {
    number = number.substring(1);
  }
  return number;
}

PhoneError? validatePhoneNumber(String input) {
  if (input.trim().isEmpty) return PhoneError.empty;
  return RegExp(r'^9\d{7,9}$').hasMatch(normalizePhoneNumber(input))
      ? null
      : PhoneError.invalid;
}

NameError? validateName(String input, {required bool isRequired}) {
  final name = input.trim();
  if (name.isEmpty) {
    return isRequired ? NameError.required : null;
  }
  if (name.runes.length > nameMaxLength) return NameError.tooLong;
  if (!RegExp(r'^[\p{L}\p{M} ]+$', unicode: true).hasMatch(name)) {
    return NameError.invalidCharacters;
  }
  return null;
}

DobError? validateDateOfBirth(DateTime? date, {required DateTime now}) {
  if (date == null) return DobError.incomplete;
  if (date.isAfter(DateTime(now.year, now.month, now.day))) {
    return DobError.inFuture;
  }
  var age = now.year - date.year;
  if (now.month < date.month ||
      (now.month == date.month && now.day < date.day)) {
    age--;
  }
  return age >= minAge ? null : DobError.tooYoung;
}
