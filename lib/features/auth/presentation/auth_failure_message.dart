import '../domain/result.dart';
import '../../../l10n/app_localizations.dart';

String authFailureMessage(AppLocalizations l10n, AuthFailure failure) =>
    switch (failure) {
      UserNotFound() => l10n.userNotFound,
      AlreadyRegistered() => l10n.alreadyRegisteredMessage,
      InvalidOtp() => l10n.otpIncorrect,
      NetworkFailure() => l10n.networkFailure,
      StorageFailure() => l10n.storageFailure,
      UnknownFailure() => l10n.unknownFailure,
    };
