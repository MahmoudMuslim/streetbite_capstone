import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// Application name, never translated.
  ///
  /// In en, this message translates to:
  /// **'StreetBite'**
  String get appName;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Food and groceries\ndelivered to you'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Hyperlocal street food from the vendors you actually walk past.'**
  String get onboardingBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signUpTitle;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join StreetBite in less than a minute.'**
  String get signUpSubtitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to keep browsing the best street food.'**
  String get loginSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Yasmine Adel'**
  String get fullNameHint;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @signUpSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Account created'**
  String get signUpSuccessTitle;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to StreetBite, {name}!'**
  String signUpSuccessMessage(String name);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @browseTitle.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browseTitle;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Food, groceries, etc.'**
  String get searchHint;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Park Way 145'**
  String get deliveryAddress;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @hotOffers.
  ///
  /// In en, this message translates to:
  /// **'Hot Offers'**
  String get hotOffers;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @nearYou.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get nearYou;

  /// No description provided for @categoriesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoriesAll;

  /// No description provided for @categoriesChicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get categoriesChicken;

  /// No description provided for @categoriesPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get categoriesPizza;

  /// No description provided for @categoriesRamen.
  ///
  /// In en, this message translates to:
  /// **'Ramen'**
  String get categoriesRamen;

  /// No description provided for @categoriesBurgers.
  ///
  /// In en, this message translates to:
  /// **'Burgers'**
  String get categoriesBurgers;

  /// No description provided for @categoriesDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get categoriesDesserts;

  /// No description provided for @categoriesSeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get categoriesSeafood;

  /// No description provided for @categoriesVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get categoriesVegetarian;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @inCartCount.
  ///
  /// In en, this message translates to:
  /// **'{count} in cart'**
  String inCartCount(int count);

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Add one more'**
  String get increaseQuantity;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Remove one'**
  String get decreaseQuantity;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'{name} added to your cart'**
  String addedToCart(String name);

  /// No description provided for @removedFromCart.
  ///
  /// In en, this message translates to:
  /// **'{name} removed from your cart'**
  String removedFromCart(String name);

  /// No description provided for @saveToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Save to favourites'**
  String get saveToFavourites;

  /// No description provided for @removeFromFavourites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get removeFromFavourites;

  /// No description provided for @savedToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Saved to your favourites'**
  String get savedToFavourites;

  /// No description provided for @removedFromFavouritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Removed from your favourites'**
  String get removedFromFavouritesMessage;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @favouritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favourites yet'**
  String get favouritesEmpty;

  /// No description provided for @favouritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any meal to save it here.'**
  String get favouritesEmptyBody;

  /// No description provided for @mealDetails.
  ///
  /// In en, this message translates to:
  /// **'Meal details'**
  String get mealDetails;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @noInstructions.
  ///
  /// In en, this message translates to:
  /// **'The vendor has not added preparation notes for this dish yet.'**
  String get noInstructions;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @mealNotFound.
  ///
  /// In en, this message translates to:
  /// **'This meal is no longer available'**
  String get mealNotFound;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a meal from the home feed to get started.'**
  String get cartEmptyBody;

  /// No description provided for @browseMenu.
  ///
  /// In en, this message translates to:
  /// **'Browse menu'**
  String get browseMenu;

  /// No description provided for @yourCartCleared.
  ///
  /// In en, this message translates to:
  /// **'Your cart is now empty'**
  String get yourCartCleared;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get deliveryFee;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get serviceFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @placeOrderFor.
  ///
  /// In en, this message translates to:
  /// **'Place order · {amount}'**
  String placeOrderFor(String amount);

  /// No description provided for @orderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order placed!'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order is on its way. Estimated arrival in 25–30 minutes.'**
  String get orderPlacedMessage;

  /// No description provided for @viewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View my orders'**
  String get viewMyOrders;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @payCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get payCash;

  /// No description provided for @payCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get payCard;

  /// No description provided for @cashOnDeliveryHint.
  ///
  /// In en, this message translates to:
  /// **'Pay the vendor in cash when your order arrives.'**
  String get cashOnDeliveryHint;

  /// No description provided for @cardPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Visa / Mastercard ending in 4242.'**
  String get cardPaymentHint;

  /// No description provided for @vendorMap.
  ///
  /// In en, this message translates to:
  /// **'Nearby Vendors'**
  String get vendorMap;

  /// No description provided for @vendorDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String vendorDistance(String distance);

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @vendorList.
  ///
  /// In en, this message translates to:
  /// **'Vendor list'**
  String get vendorList;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get pickFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get photoUpdated;

  /// No description provided for @photoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the photo'**
  String get photoUpdateFailed;

  /// No description provided for @deviceInformation.
  ///
  /// In en, this message translates to:
  /// **'Device information'**
  String get deviceInformation;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get deviceModel;

  /// No description provided for @deviceOs.
  ///
  /// In en, this message translates to:
  /// **'OS version'**
  String get deviceOs;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceName;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get orderHistory;

  /// No description provided for @orderHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get orderHistoryEmpty;

  /// No description provided for @orderHistoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your placed orders will appear here.'**
  String get orderHistoryEmptyBody;

  /// No description provided for @orderItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String orderItemsCount(int count);

  /// No description provided for @paidWith.
  ///
  /// In en, this message translates to:
  /// **'Paid with {method}'**
  String paidWith(String method);

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetails;

  /// The short reference printed on the receipt header.
  ///
  /// In en, this message translates to:
  /// **'Order {id}'**
  String orderNumber(String id);

  /// No description provided for @orderPreparing.
  ///
  /// In en, this message translates to:
  /// **'Being prepared'**
  String get orderPreparing;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderDelivered;

  /// No description provided for @placedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String placedOn(String date);

  /// No description provided for @orderItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get orderItemsTitle;

  /// No description provided for @orderLineQuantity.
  ///
  /// In en, this message translates to:
  /// **'× {count}'**
  String orderLineQuantity(int count);

  /// No description provided for @reorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get reorder;

  /// No description provided for @reorderDone.
  ///
  /// In en, this message translates to:
  /// **'This order is back in your cart'**
  String get reorderDone;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @biometricPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock your profile'**
  String get biometricPromptTitle;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to open StreetBite'**
  String get biometricReason;

  /// No description provided for @biometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm it is you to view your StreetBite profile.'**
  String get biometricSubtitle;

  /// No description provided for @biometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric check failed. Try again.'**
  String get biometricFailed;

  /// No description provided for @biometricNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint or face is enrolled on this device.'**
  String get biometricNotEnrolled;

  /// No description provided for @biometricNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not supported on this device.'**
  String get biometricNotSupported;

  /// No description provided for @biometricCancelled.
  ///
  /// In en, this message translates to:
  /// **'Biometric check cancelled.'**
  String get biometricCancelled;

  /// No description provided for @biometricLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Biometric unlock is locked for now.'**
  String get biometricLockedOut;

  /// No description provided for @useInstead.
  ///
  /// In en, this message translates to:
  /// **'Continue without biometrics'**
  String get useInstead;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @biometricSignIn.
  ///
  /// In en, this message translates to:
  /// **'Biometric sign-in'**
  String get biometricSignIn;

  /// No description provided for @biometricSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Use a fingerprint or face scan instead of retyping your password each time you open StreetBite.'**
  String get biometricSignInHint;

  /// No description provided for @biometricSignInReason.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to sign in to StreetBite'**
  String get biometricSignInReason;

  /// Greeting on the biometric sign-in screen, naming the account whose session was restored.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeBack(String name);

  /// No description provided for @scanToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Scan to sign in'**
  String get scanToSignIn;

  /// No description provided for @usePasswordInstead.
  ///
  /// In en, this message translates to:
  /// **'Use password instead'**
  String get usePasswordInstead;

  /// Tooltip and screen-reader label for the round fingerprint button beside the Log In button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your fingerprint'**
  String get signInWithFingerprint;

  /// Shown when the fingerprint button on the password form finds no session to unlock.
  ///
  /// In en, this message translates to:
  /// **'A fingerprint only unlocks an account that is already signed in on this device. Use your password.'**
  String get biometricSignInUnavailable;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @failureNetwork.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'\'t reach StreetBite. Check your connection and try again.'**
  String get failureNetwork;

  /// No description provided for @failureCache.
  ///
  /// In en, this message translates to:
  /// **'No saved copy of this data is available yet.'**
  String get failureCache;

  /// No description provided for @failureCancelled.
  ///
  /// In en, this message translates to:
  /// **'Action cancelled.'**
  String get failureCancelled;

  /// No description provided for @failureGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error. Please try again.'**
  String get failureGeneric;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name.'**
  String get validationNameRequired;

  /// No description provided for @validationNameTwoWords.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first and last name.'**
  String get validationNameTwoWords;

  /// No description provided for @validationNameCapital.
  ///
  /// In en, this message translates to:
  /// **'Names must start with a capital letter.'**
  String get validationNameCapital;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get validationPasswordShort;

  /// No description provided for @validationConfirmRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get validationConfirmRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get validationPasswordMismatch;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That email address is not valid.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found for this email.'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'\'t verify your account. Check your connection.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'\'t sign you in. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @authLoggedOut.
  ///
  /// In en, this message translates to:
  /// **'You have been signed out.'**
  String get authLoggedOut;

  /// No description provided for @authSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get authSessionExpired;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceHint.
  ///
  /// In en, this message translates to:
  /// **'Theme and language apply instantly across the app.'**
  String get appearanceHint;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLiquidGlass.
  ///
  /// In en, this message translates to:
  /// **'Liquid Glass'**
  String get themeLiquidGlass;

  /// No description provided for @themeLiquidGlassHint.
  ///
  /// In en, this message translates to:
  /// **'Frosted, refractive surfaces. Needs a GPU; falls back gracefully on older devices.'**
  String get themeLiquidGlassHint;

  /// No description provided for @themeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an appearance'**
  String get themeSheetTitle;

  /// No description provided for @themeOptionLightHint.
  ///
  /// In en, this message translates to:
  /// **'Solid surfaces, tuned for daylight'**
  String get themeOptionLightHint;

  /// No description provided for @themeOptionDarkHint.
  ///
  /// In en, this message translates to:
  /// **'Solid surfaces that are easy at night'**
  String get themeOptionDarkHint;

  /// No description provided for @themeOptionGlassLightHint.
  ///
  /// In en, this message translates to:
  /// **'Frosted glass over a light aurora'**
  String get themeOptionGlassLightHint;

  /// No description provided for @themeOptionGlassDarkHint.
  ///
  /// In en, this message translates to:
  /// **'Frosted glass over a deep aurora'**
  String get themeOptionGlassDarkHint;

  /// No description provided for @viewAllThemes.
  ///
  /// In en, this message translates to:
  /// **'See all appearances'**
  String get viewAllThemes;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock'**
  String get biometricUnlock;

  /// No description provided for @biometricUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Ask for a fingerprint or face scan before opening the profile.'**
  String get biometricUnlockHint;

  /// No description provided for @biometricStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available on this device'**
  String get biometricStatusAvailable;

  /// No description provided for @biometricStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get biometricStatusUnavailable;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @vendorMapHint.
  ///
  /// In en, this message translates to:
  /// **'See the five StreetBite vendors near you.'**
  String get vendorMapHint;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
