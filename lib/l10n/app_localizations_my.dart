// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'J\'Donuts';

  @override
  String get onboardingTitle => 'Round food for\nevery mood';

  @override
  String get getStarted => 'LET\'S GET STARTED';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get logIn => 'Log In';

  @override
  String get socialGoogle => 'Google';

  @override
  String get socialApple => 'Apple';

  @override
  String get socialFacebook => 'Facebook';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get placeholderNotConnected =>
      'This feature is a demo placeholder and is not connected.';

  @override
  String get phoneTitle => 'Enter your phone\nnumber';

  @override
  String get phoneCountryPrefix => '+95';

  @override
  String get phoneNumberHint => 'Phone number';

  @override
  String phoneHelp(int otpLength) {
    return 'We’ll text a $otpLength-digit code to this number.';
  }

  @override
  String get phoneEmpty => 'Enter your phone number.';

  @override
  String phoneInvalid(Object prefix) {
    return 'Enter a valid phone number after $prefix.';
  }

  @override
  String get continueLabel => 'CONTINUE';

  @override
  String get verifyLabel => 'VERIFY';

  @override
  String get otpTitle => 'Verify your number';

  @override
  String otpSentTo(int otpLength, Object phoneNumber) {
    return 'We\'ve sent a $otpLength digit OTP to $phoneNumber';
  }

  @override
  String otpSemanticsLabel(int otpLength) {
    return '$otpLength digit verification code';
  }

  @override
  String get otpIncorrect => 'That code is incorrect. Please try again.';

  @override
  String get otpLocked =>
      'Too many incorrect codes. Resend a code to try again.';

  @override
  String get otpNoCode => 'Didn\'t receive the code? ';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCountdown(Object countdown) {
    return 'resend in $countdown min';
  }

  @override
  String get registerNewAccount => 'Register a new account';

  @override
  String get nameTitle => 'What\'s your\nname?';

  @override
  String get firstNameHint => 'First Name';

  @override
  String get lastNameHint => 'Last Name';

  @override
  String get nameRequired => 'Please enter your first name.';

  @override
  String nameTooLong(int maxLength) {
    return 'Use no more than $maxLength characters.';
  }

  @override
  String get nameInvalid => 'Use letters and spaces only.';

  @override
  String get dobTitle => 'What\'s your\ndate of birth?';

  @override
  String get selectBirthday => 'Select your Birthday';

  @override
  String get select => 'SELECT';

  @override
  String get close => 'Close';

  @override
  String get dobMonthHint => 'Month';

  @override
  String get dobDayHint => 'Day';

  @override
  String get dobYearHint => 'Year';

  @override
  String get dobIncomplete => 'Enter your complete date of birth.';

  @override
  String get dobFuture => 'Date of birth cannot be in the future.';

  @override
  String dobTooYoung(int minAge) {
    return 'You must be at least $minAge years old.';
  }

  @override
  String get userNotFound => 'No account found. Register to get started.';

  @override
  String get networkFailure => 'Could not connect. Please try again.';

  @override
  String get storageFailure => 'Could not save your account. Please try again.';

  @override
  String get unknownFailure => 'Something went wrong. Please try again.';

  @override
  String get welcomeTitle => 'Welcome to J\'Donuts!';

  @override
  String get welcomeMessage => 'Your account is ready. Let\'s explore!';

  @override
  String get letsExplore => 'LET\'S EXPLORE';

  @override
  String get logout => 'Log out';

  @override
  String get homeTitle => 'Home';

  @override
  String get progressReady => 'Ready';

  @override
  String get progressGettingStarted => 'Getting started';
}
