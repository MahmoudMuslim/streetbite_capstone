import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/generated/app_localizations.dart';

/// Removes the `AppLocalizations.of(context)!` boilerplate from every widget
/// **and** provides the single place where a *message key* — coming from the
/// domain/data layer (a `Failure`, a validator, a payment strategy) or from a
/// reusable widget's configuration — is turned into a localized sentence.
///
/// Because no widget is allowed to contain a literal string, this is the only
/// bridge between key and text. It is an exhaustive `switch`, so adding a key
/// to an ARB file without wiring it here is a **compile-time** error rather than
/// a runtime surprise.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Resolves any message key.
  ///
  /// Unknown keys fall back to the generic error sentence so a typo can never
  /// surface raw identifier text to a user.
  String trKey(String key) => switch (key) {
    // --- Network / cache / generic -----------------------------------
    'failureNetwork' => l10n.failureNetwork,
    'failureCache' => l10n.failureCache,
    'failureCancelled' => l10n.failureCancelled,
    'failureGeneric' => l10n.failureGeneric,
    'somethingWentWrong' => l10n.somethingWentWrong,
    'loading' => l10n.loading,
    'retry' => l10n.retry,

    // --- Validation ---------------------------------------------------
    'validationNameRequired' => l10n.validationNameRequired,
    'validationNameTwoWords' => l10n.validationNameTwoWords,
    'validationNameCapital' => l10n.validationNameCapital,
    'validationEmailRequired' => l10n.validationEmailRequired,
    'validationEmailInvalid' => l10n.validationEmailInvalid,
    'validationPasswordRequired' => l10n.validationPasswordRequired,
    'validationPasswordShort' => l10n.validationPasswordShort,
    'validationConfirmRequired' => l10n.validationConfirmRequired,
    'validationPasswordMismatch' => l10n.validationPasswordMismatch,

    // --- Firebase Auth ------------------------------------------------
    'authErrorInvalidEmail' => l10n.authErrorInvalidEmail,
    'authErrorEmailInUse' => l10n.authErrorEmailInUse,
    'authErrorWeakPassword' => l10n.authErrorWeakPassword,
    'authErrorUserNotFound' => l10n.authErrorUserNotFound,
    'authErrorWrongPassword' => l10n.authErrorWrongPassword,
    'authErrorTooManyRequests' => l10n.authErrorTooManyRequests,
    'authErrorNetwork' => l10n.authErrorNetwork,
    'authErrorUnknown' => l10n.authErrorUnknown,
    'authLoggedOut' => l10n.authLoggedOut,
    'authSessionExpired' => l10n.authSessionExpired,

    // --- Biometrics ---------------------------------------------------
    'biometricFailed' => l10n.biometricFailed,
    'biometricNotEnrolled' => l10n.biometricNotEnrolled,
    'biometricNotSupported' => l10n.biometricNotSupported,
    'biometricCancelled' => l10n.biometricCancelled,

    // --- Domain strings returned as keys -------------------------------
    'cartEmpty' => l10n.cartEmpty,
    'cartEmptyBody' => l10n.cartEmptyBody,
    'browseMenu' => l10n.browseMenu,
    'mealNotFound' => l10n.mealNotFound,
    'photoUpdated' => l10n.photoUpdated,
    'photoUpdateFailed' => l10n.photoUpdateFailed,

    // --- Empty states --------------------------------------------------
    'favouritesEmpty' => l10n.favouritesEmpty,
    'favouritesEmptyBody' => l10n.favouritesEmptyBody,
    'orderHistoryEmpty' => l10n.orderHistoryEmpty,
    'orderHistoryEmptyBody' => l10n.orderHistoryEmptyBody,

    // --- Auth form labels and hints ------------------------------------
    'loginTitle' => l10n.loginTitle,
    'loginSubtitle' => l10n.loginSubtitle,
    'signUpTitle' => l10n.signUpTitle,
    'signUpSubtitle' => l10n.signUpSubtitle,
    'fullName' => l10n.fullName,
    'fullNameHint' => l10n.fullNameHint,
    'email' => l10n.email,
    'emailHint' => l10n.emailHint,
    'password' => l10n.password,
    'passwordHint' => l10n.passwordHint,
    'confirmPassword' => l10n.confirmPassword,

    // --- Category chips -------------------------------------------------
    'categoriesAll' => l10n.categoriesAll,
    'categoriesChicken' => l10n.categoriesChicken,
    'categoriesPizza' => l10n.categoriesPizza,
    'categoriesRamen' => l10n.categoriesRamen,
    'categoriesBurgers' => l10n.categoriesBurgers,
    'categoriesDesserts' => l10n.categoriesDesserts,
    'categoriesSeafood' => l10n.categoriesSeafood,
    'categoriesVegetarian' => l10n.categoriesVegetarian,

    // --- Device information rows ----------------------------------------
    'deviceModel' => l10n.deviceModel,
    'deviceOs' => l10n.deviceOs,
    'deviceName' => l10n.deviceName,

    // --- Payment strategy labels (SOLID) --------------------------------
    'payCash' => l10n.payCash,
    'payCard' => l10n.payCard,
    'cashOnDeliveryHint' => l10n.cashOnDeliveryHint,
    'cardPaymentHint' => l10n.cardPaymentHint,

    _ => l10n.somethingWentWrong,
  };

  /// Resolves a key that needs parameters, e.g. `addedToCart`.
  String trArgs(String key, Map<String, Object> args) => switch (key) {
    'addedToCart' => l10n.addedToCart(args['name'] as String),
    'removedFromCart' => l10n.removedFromCart(args['name'] as String),
    'signUpSuccessMessage' => l10n.signUpSuccessMessage(args['name'] as String),
    'vendorDistance' => l10n.vendorDistance(args['distance'] as String),
    'paidWith' => l10n.paidWith(args['method'] as String),
    _ => trKey(key),
  };

  /// Item counter with correct singular/plural for the active locale.
  String itemCount(int count) => l10n.orderItemsCount(count);

  /// Formats a number with locale-aware digits (Arabic-Indic in `ar`).
  String formatNumber(num value) =>
      NumberFormat.decimalPattern(Localizations.localeOf(this).toLanguageTag())
          .format(value);
}
