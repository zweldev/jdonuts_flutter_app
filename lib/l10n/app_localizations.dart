import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'J\'Donuts'**
  String get appTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Round food for\nevery mood'**
  String get onboardingTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'LET\'S GET STARTED'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @socialGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get socialGoogle;

  /// No description provided for @socialApple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get socialApple;

  /// No description provided for @socialFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get socialFacebook;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @placeholderNotConnected.
  ///
  /// In en, this message translates to:
  /// **'This feature is a demo placeholder and is not connected.'**
  String get placeholderNotConnected;

  /// No description provided for @phoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone\nnumber'**
  String get phoneTitle;

  /// No description provided for @phoneCountryPrefix.
  ///
  /// In en, this message translates to:
  /// **'+95'**
  String get phoneCountryPrefix;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberHint;

  /// No description provided for @phoneHelp.
  ///
  /// In en, this message translates to:
  /// **'We’ll text a {otpLength}-digit code to this number.'**
  String phoneHelp(int otpLength);

  /// No description provided for @phoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get phoneEmpty;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number after {prefix}.'**
  String phoneInvalid(Object prefix);

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueLabel;

  /// No description provided for @verifyLabel.
  ///
  /// In en, this message translates to:
  /// **'VERIFY'**
  String get verifyLabel;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your number'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a {otpLength} digit OTP to {phoneNumber}'**
  String otpSentTo(int otpLength, Object phoneNumber);

  /// No description provided for @otpSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'{otpLength} digit verification code'**
  String otpSemanticsLabel(int otpLength);

  /// No description provided for @otpIncorrect.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect. Please try again.'**
  String get otpIncorrect;

  /// No description provided for @otpLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect codes. Resend a code to try again.'**
  String get otpLocked;

  /// No description provided for @otpNoCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get otpNoCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendCountdown.
  ///
  /// In en, this message translates to:
  /// **'resend in {countdown} min'**
  String resendCountdown(Object countdown);

  /// No description provided for @registerNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Register a new account'**
  String get registerNewAccount;

  /// No description provided for @nameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your\nname?'**
  String get nameTitle;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name.'**
  String get nameRequired;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use no more than {maxLength} characters.'**
  String nameTooLong(int maxLength);

  /// No description provided for @nameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use letters and spaces only.'**
  String get nameInvalid;

  /// No description provided for @dobTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your\ndate of birth?'**
  String get dobTitle;

  /// No description provided for @selectBirthday.
  ///
  /// In en, this message translates to:
  /// **'Select your Birthday'**
  String get selectBirthday;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'SELECT'**
  String get select;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @dobMonthHint.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get dobMonthHint;

  /// No description provided for @dobDayHint.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dobDayHint;

  /// No description provided for @dobYearHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get dobYearHint;

  /// No description provided for @dobIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter your complete date of birth.'**
  String get dobIncomplete;

  /// No description provided for @dobFuture.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future.'**
  String get dobFuture;

  /// No description provided for @dobTooYoung.
  ///
  /// In en, this message translates to:
  /// **'You must be at least {minAge} years old.'**
  String dobTooYoung(int minAge);

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found. Register to get started.'**
  String get userNotFound;

  /// No description provided for @networkFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Please try again.'**
  String get networkFailure;

  /// No description provided for @storageFailure.
  ///
  /// In en, this message translates to:
  /// **'Could not save your account. Please try again.'**
  String get storageFailure;

  /// No description provided for @unknownFailure.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownFailure;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to J\'Donuts!'**
  String get welcomeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready. Let\'s explore!'**
  String get welcomeMessage;

  /// No description provided for @letsExplore.
  ///
  /// In en, this message translates to:
  /// **'LET\'S EXPLORE'**
  String get letsExplore;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @progressReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get progressReady;

  /// No description provided for @progressGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get progressGettingStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
