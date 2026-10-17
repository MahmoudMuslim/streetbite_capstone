// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StreetBite';

  @override
  String get onboardingTitle => 'Food and groceries\ndelivered to you';

  @override
  String get onboardingBody =>
      'Hyperlocal street food from the vendors you actually walk past.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get signUpTitle => 'Create your account';

  @override
  String get signUpSubtitle => 'Join StreetBite in less than a minute.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to keep browsing the best street food.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'Yasmine Adel';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'At least 6 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get signUp => 'Sign Up';

  @override
  String get login => 'Log In';

  @override
  String get logout => 'Log Out';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get noAccountYet => 'Don\'t have an account?';

  @override
  String get signUpSuccessTitle => 'Account created';

  @override
  String signUpSuccessMessage(String name) {
    return 'Welcome to StreetBite, $name!';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get homeTitle => 'Home';

  @override
  String get browseTitle => 'Browse';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get profileTitle => 'Profile';

  @override
  String get searchHint => 'Food, groceries, etc.';

  @override
  String get deliveryAddress => 'Park Way 145';

  @override
  String get recommended => 'Recommended';

  @override
  String get hotOffers => 'Hot Offers';

  @override
  String get seeAll => 'See all';

  @override
  String get nearYou => 'Near you';

  @override
  String get categoriesAll => 'All';

  @override
  String get categoriesChicken => 'Chicken';

  @override
  String get categoriesPizza => 'Pizza';

  @override
  String get categoriesRamen => 'Ramen';

  @override
  String get categoriesBurgers => 'Burgers';

  @override
  String get categoriesDesserts => 'Desserts';

  @override
  String get categoriesSeafood => 'Seafood';

  @override
  String get categoriesVegetarian => 'Vegetarian';

  @override
  String get addToCart => 'Add to cart';

  @override
  String inCartCount(int count) {
    return '$count in cart';
  }

  @override
  String get increaseQuantity => 'Add one more';

  @override
  String get decreaseQuantity => 'Remove one';

  @override
  String addedToCart(String name) {
    return '$name added to your cart';
  }

  @override
  String removedFromCart(String name) {
    return '$name removed from your cart';
  }

  @override
  String get saveToFavourites => 'Save to favourites';

  @override
  String get removeFromFavourites => 'Remove from favourites';

  @override
  String get savedToFavourites => 'Saved to your favourites';

  @override
  String get removedFromFavouritesMessage => 'Removed from your favourites';

  @override
  String get favourites => 'Favourites';

  @override
  String get favouritesEmpty => 'No favourites yet';

  @override
  String get favouritesEmptyBody =>
      'Tap the heart on any meal to save it here.';

  @override
  String get mealDetails => 'Meal details';

  @override
  String get category => 'Category';

  @override
  String get instructions => 'Instructions';

  @override
  String get noInstructions =>
      'The vendor has not added preparation notes for this dish yet.';

  @override
  String get price => 'Price';

  @override
  String get mealNotFound => 'This meal is no longer available';

  @override
  String get cart => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartEmptyBody => 'Add a meal from the home feed to get started.';

  @override
  String get browseMenu => 'Browse menu';

  @override
  String get yourCartCleared => 'Your cart is now empty';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery fee';

  @override
  String get serviceFee => 'Service fee';

  @override
  String get total => 'Total';

  @override
  String get free => 'Free';

  @override
  String placeOrderFor(String amount) {
    return 'Place order · $amount';
  }

  @override
  String get orderPlacedTitle => 'Order placed!';

  @override
  String get orderPlacedMessage =>
      'Your order is on its way. Estimated arrival in 25–30 minutes.';

  @override
  String get viewMyOrders => 'View my orders';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get payCash => 'Cash';

  @override
  String get payCard => 'Card';

  @override
  String get cashOnDeliveryHint =>
      'Pay the vendor in cash when your order arrives.';

  @override
  String get cardPaymentHint => 'Visa / Mastercard ending in 4242.';

  @override
  String get vendorMap => 'Nearby Vendors';

  @override
  String vendorDistance(String distance) {
    return '$distance km away';
  }

  @override
  String get directions => 'Directions';

  @override
  String get vendorList => 'Vendor list';

  @override
  String get profile => 'Profile';

  @override
  String get pickFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get photoUpdated => 'Profile photo updated';

  @override
  String get photoUpdateFailed => 'Could not update the photo';

  @override
  String get deviceInformation => 'Device information';

  @override
  String get deviceModel => 'Model';

  @override
  String get deviceOs => 'OS version';

  @override
  String get deviceName => 'Device name';

  @override
  String get orderHistory => 'Order history';

  @override
  String get orderHistoryEmpty => 'No orders yet';

  @override
  String get orderHistoryEmptyBody => 'Your placed orders will appear here.';

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String paidWith(String method) {
    return 'Paid with $method';
  }

  @override
  String get orderDetails => 'Order details';

  @override
  String orderNumber(String id) {
    return 'Order $id';
  }

  @override
  String get orderPreparing => 'Being prepared';

  @override
  String get orderDelivered => 'Delivered';

  @override
  String placedOn(String date) {
    return 'Placed on $date';
  }

  @override
  String get orderItemsTitle => 'Items';

  @override
  String orderLineQuantity(int count) {
    return '× $count';
  }

  @override
  String get reorder => 'Reorder';

  @override
  String get reorderDone => 'This order is back in your cart';

  @override
  String get current => 'Current';

  @override
  String get past => 'Past';

  @override
  String get biometricPromptTitle => 'Unlock your profile';

  @override
  String get biometricReason => 'Verify your identity to open StreetBite';

  @override
  String get biometricSubtitle =>
      'Confirm it is you to view your StreetBite profile.';

  @override
  String get biometricFailed => 'Biometric check failed. Try again.';

  @override
  String get biometricNotEnrolled =>
      'No fingerprint or face is enrolled on this device.';

  @override
  String get biometricNotSupported =>
      'Biometric authentication is not supported on this device.';

  @override
  String get biometricCancelled => 'Biometric check cancelled.';

  @override
  String get biometricLockedOut =>
      'Too many failed attempts. Biometric unlock is locked for now.';

  @override
  String get useInstead => 'Continue without biometrics';

  @override
  String get skip => 'Skip';

  @override
  String get biometricSignIn => 'Biometric sign-in';

  @override
  String get biometricSignInHint =>
      'Use a fingerprint or face scan instead of retyping your password each time you open StreetBite.';

  @override
  String get biometricSignInReason =>
      'Verify your identity to sign in to StreetBite';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get scanToSignIn => 'Scan to sign in';

  @override
  String get usePasswordInstead => 'Use password instead';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get loading => 'Loading';

  @override
  String get failureNetwork =>
      'We couldn\'t reach StreetBite. Check your connection and try again.';

  @override
  String get failureCache => 'No saved copy of this data is available yet.';

  @override
  String get failureCancelled => 'Action cancelled.';

  @override
  String get failureGeneric => 'Unexpected error. Please try again.';

  @override
  String get validationNameRequired => 'Please enter your full name.';

  @override
  String get validationNameTwoWords => 'Please enter your first and last name.';

  @override
  String get validationNameCapital => 'Names must start with a capital letter.';

  @override
  String get validationEmailRequired => 'Please enter your email address.';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Please enter a password.';

  @override
  String get validationPasswordShort =>
      'Password must be at least 6 characters.';

  @override
  String get validationConfirmRequired => 'Please confirm your password.';

  @override
  String get validationPasswordMismatch => 'Passwords do not match.';

  @override
  String get authErrorInvalidEmail => 'That email address is not valid.';

  @override
  String get authErrorEmailInUse =>
      'An account already exists with this email.';

  @override
  String get authErrorWeakPassword => 'Please choose a stronger password.';

  @override
  String get authErrorUserNotFound => 'No account found for this email.';

  @override
  String get authErrorWrongPassword => 'Incorrect email or password.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get authErrorNetwork =>
      'We couldn\'t verify your account. Check your connection.';

  @override
  String get authErrorUnknown => 'We couldn\'t sign you in. Please try again.';

  @override
  String get authLoggedOut => 'You have been signed out.';

  @override
  String get authSessionExpired =>
      'Your session expired. Please sign in again.';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceHint =>
      'Theme and language apply instantly across the app.';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLiquidGlass => 'Liquid Glass';

  @override
  String get themeLiquidGlassHint =>
      'Frosted, refractive surfaces. Needs a GPU; falls back gracefully on older devices.';

  @override
  String get themeSheetTitle => 'Choose an appearance';

  @override
  String get themeOptionLightHint => 'Solid surfaces, tuned for daylight';

  @override
  String get themeOptionDarkHint => 'Solid surfaces that are easy at night';

  @override
  String get themeOptionGlassLightHint => 'Frosted glass over a light aurora';

  @override
  String get themeOptionGlassDarkHint => 'Frosted glass over a deep aurora';

  @override
  String get viewAllThemes => 'See all appearances';

  @override
  String get security => 'Security';

  @override
  String get biometricUnlock => 'Biometric unlock';

  @override
  String get biometricUnlockHint =>
      'Ask for a fingerprint or face scan before opening the profile.';

  @override
  String get biometricStatusAvailable => 'Available on this device';

  @override
  String get biometricStatusUnavailable => 'Not available on this device';

  @override
  String get general => 'General';

  @override
  String get vendorMapHint => 'See the five StreetBite vendors near you.';
}
