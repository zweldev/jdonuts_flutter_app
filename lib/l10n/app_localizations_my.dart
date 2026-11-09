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
  String get onboardingTitle =>
      'စိတ်ခံစားချက်တိုင်းအတွက်\nအရသာရှိတဲ့ မုန့်ဝိုင်း';

  @override
  String get getStarted => 'စလိုက်ကြစို့';

  @override
  String get alreadyHaveAccount => 'အကောင့်ရှိပြီးသားလား? ';

  @override
  String get logIn => 'အကောင့်ဝင်ရန်';

  @override
  String get socialGoogle => 'Google';

  @override
  String get socialApple => 'Apple';

  @override
  String get socialFacebook => 'Facebook';

  @override
  String get termsOfUse => 'အသုံးပြုမှု စည်းမျဉ်းများ';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String get placeholderNotConnected =>
      'ဤလုပ်ဆောင်ချက်သည် ဒီမိုအတွက်သာဖြစ်ပြီး ချိတ်ဆက်ထားခြင်း မရှိသေးပါ။';

  @override
  String get phoneTitle => 'သင့်ဖုန်း\nနံပါတ်ကို ထည့်ပါ';

  @override
  String get phoneCountryPrefix => '+95';

  @override
  String get phoneNumberHint => 'ဖုန်းနံပါတ်';

  @override
  String phoneHelp(int otpLength) {
    return 'ဤဖုန်းနံပါတ်သို့ ဂဏန်း $otpLength လုံးပါသော အတည်ပြုကုဒ် ပို့ပေးပါမည်။';
  }

  @override
  String get phoneEmpty => 'သင့်ဖုန်းနံပါတ်ကို ထည့်ပါ။';

  @override
  String phoneInvalid(Object prefix) {
    return '$prefix နောက်တွင် မှန်ကန်သော ဖုန်းနံပါတ်ကို ထည့်ပါ။';
  }

  @override
  String get continueLabel => 'ဆက်လုပ်ရန်';

  @override
  String get verifyLabel => 'အတည်ပြုရန်';

  @override
  String get otpTitle => 'သင့်ဖုန်းနံပါတ်ကို အတည်ပြုပါ';

  @override
  String otpSentTo(int otpLength, Object phoneNumber) {
    return 'ဂဏန်း $otpLength လုံးပါသော အတည်ပြုကုဒ်ကို $phoneNumber သို့ ပို့ထားပါသည်။';
  }

  @override
  String otpSemanticsLabel(int otpLength) {
    return 'ဂဏန်း $otpLength လုံးပါသော အတည်ပြုကုဒ်';
  }

  @override
  String get otpIncorrect => 'အတည်ပြုကုဒ် မှားနေပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get otpLocked =>
      'ကုဒ်ကို အကြိမ်များစွာ မှားယွင်းထည့်သွင်းထားပါသည်။ ထပ်ကြိုးစားရန် ကုဒ်အသစ်တောင်းပါ။';

  @override
  String get otpNoCode => 'ကုဒ်မရရှိဘူးလား? ';

  @override
  String get resendCode => 'ကုဒ်အသစ်တောင်းရန်';

  @override
  String resendCountdown(Object countdown) {
    return '$countdown မိနစ်အတွင်း ကုဒ်အသစ်တောင်းနိုင်ပါမည်';
  }

  @override
  String get registerNewAccount => 'အကောင့်အသစ်ဖွင့်ရန်';

  @override
  String get nameTitle => 'သင့်နာမည်\nဘယ်လိုခေါ်ပါသလဲ?';

  @override
  String get firstNameHint => 'ရှေ့နာမည်';

  @override
  String get lastNameHint => 'နောက်နာမည်';

  @override
  String get nameRequired => 'သင့်ရှေ့နာမည်ကို ထည့်ပါ။';

  @override
  String nameTooLong(int maxLength) {
    return 'စာလုံးရေ $maxLength ထက် မပိုစေရပါ။';
  }

  @override
  String get nameInvalid =>
      'အက္ခရာများနှင့် စကားလုံးကြားလပ်နေရာကိုသာ အသုံးပြုပါ။';

  @override
  String get dobTitle => 'သင့်မွေးနေ့\nဘယ်နေ့ဖြစ်ပါသလဲ?';

  @override
  String get selectBirthday => 'မွေးနေ့ကို ရွေးပါ';

  @override
  String get select => 'ရွေးရန်';

  @override
  String get close => 'ပိတ်ရန်';

  @override
  String get dobMonthHint => 'လ';

  @override
  String get dobDayHint => 'ရက်';

  @override
  String get dobYearHint => 'နှစ်';

  @override
  String get dobIncomplete => 'မွေးသက္ကရာဇ် အပြည့်အစုံကို ထည့်ပါ။';

  @override
  String get dobFuture => 'မွေးသက္ကရာဇ်သည် ယနေ့ထက် နောက်ကျ၍ မရပါ။';

  @override
  String dobTooYoung(int minAge) {
    return 'အသက် $minAge နှစ် ပြည့်ပြီးသူ ဖြစ်ရပါမည်။';
  }

  @override
  String get alreadyRegisteredMessage =>
      'ဤဖုန်းနံပါတ်ဖြင့် အကောင့်ရှိပြီးသားဖြစ်သည်။';

  @override
  String get userNotFound =>
      'အကောင့်မတွေ့ပါ။ စတင်အသုံးပြုရန် အကောင့်အသစ်ဖွင့်ပါ။';

  @override
  String get networkFailure => 'ချိတ်ဆက်၍ မရပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get storageFailure => 'သင့်အကောင့်ကို သိမ်းဆည်း၍ မရပါ။ ထပ်ကြိုးစားပါ။';

  @override
  String get unknownFailure => 'တစ်ခုခု မှားယွင်းသွားပါသည်။ ထပ်ကြိုးစားပါ။';

  @override
  String get welcomeTitle => 'J’donuts\nလောကမှ ကြိုဆိုပါသည်';

  @override
  String get welcomeMessage =>
      'သင့်အကောင့် အဆင်သင့်ဖြစ်ပါပြီ။ စူးစမ်းကြည့်လိုက်ပါ။';

  @override
  String get letsExplore => 'စူးစမ်းကြည့်ရန်';

  @override
  String get logout => 'အကောင့်မှ ထွက်ရန်';

  @override
  String get settingsTitle => 'ဆက်တင်များ';

  @override
  String get languageLabel => 'မြန်မာဘာသာ အသုံးပြုရန်';

  @override
  String get englishLanguage => 'အင်္ဂလိပ်';

  @override
  String get burmeseLanguage => 'မြန်မာ';

  @override
  String get homeTitle => 'ပင်မစာမျက်နှာ';

  @override
  String get progressReady => 'အဆင်သင့်';

  @override
  String get progressGettingStarted => 'စတင်အသုံးပြုနေပါသည်';

  @override
  String get rewardsTitle => 'J’ Donuts ဆုလာဘ်များ';

  @override
  String get rewardsBadge => 'ဆုလာဘ်များ';

  @override
  String get rewardTabLabel => 'ဆုလာဘ်';

  @override
  String get orderTabLabel => 'မှာယူရန်';

  @override
  String get walletTabLabel => 'ပိုက်ဆံအိတ်';

  @override
  String get profileTabLabel => 'ကိုယ်ရေးအချက်အလက်';

  @override
  String get rewardsTotalPoints => 'စုစုပေါင်း အမှတ်များ';

  @override
  String get rewardsHereNow => 'သင်ရောက်ရှိနေသော အဆင့်';

  @override
  String rewardsPointsRemaining(String points, Object tier) {
    return '$tier အဆင့်သို့ ရောက်ရန် $points မှတ် လိုအပ်ပါသည်';
  }

  @override
  String get rewardsYoullBeHereSoon => 'မကြာမီ ဤနေရာသို့ ရောက်ရှိပါမည်';

  @override
  String get rewardsTopTier => 'အမြင့်ဆုံးအဆင့်သို့ ရောက်ရှိပါပြီ';

  @override
  String get rewardsRetry => 'ထပ်ကြိုးစားရန်';

  @override
  String get rewardsEarnTab => 'များများစားပြီး အမှတ်များများရယူပါ';

  @override
  String get rewardsGiftTab => 'လက်ဆောင်';

  @override
  String get rewardsEarnButton => 'ရယူရန်';

  @override
  String rewardsPointUnit(String points) {
    return '$points မှတ်';
  }

  @override
  String rewardsChallengeProgress(int progress, int target) {
    return '$progress/$target';
  }

  @override
  String get rewardsLoadError => 'ဆုလာဘ်များကို ဖွင့်၍မရပါ။';

  @override
  String get rewardsEmptyTitle => 'လောလောဆယ် ဆုလာဘ်များ မရှိသေးပါ';

  @override
  String get rewardsEmptyMessage =>
      'စိန်ခေါ်မှုအသစ်များအတွက် နောက်မှ ပြန်စစ်ဆေးပါ။';
}
