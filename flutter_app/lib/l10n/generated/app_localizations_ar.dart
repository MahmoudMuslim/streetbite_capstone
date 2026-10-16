// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'StreetBite';

  @override
  String get onboardingTitle => 'طعام وتوصيل\nإلى بابك';

  @override
  String get onboardingBody =>
      'أكل الشارع المحلي من البائعين الذين تمر أمامهم يومياً.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get signUpTitle => 'أنشئ حسابك';

  @override
  String get signUpSubtitle => 'انضم إلى StreetBite في أقل من دقيقة.';

  @override
  String get loginTitle => 'أهلاً بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول لمتابعة تصفح أفضل أكل الشارع.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameHint => 'ياسمين عادل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => '٦ أحرف على الأقل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get noAccountYet => 'ليس لديك حساب؟';

  @override
  String get signUpSuccessTitle => 'تم إنشاء الحساب';

  @override
  String signUpSuccessMessage(String name) {
    return 'أهلاً بك في StreetBite يا $name!';
  }

  @override
  String get continueAction => 'متابعة';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get browseTitle => 'تصفح';

  @override
  String get ordersTitle => 'طلباتي';

  @override
  String get profileTitle => 'حسابي';

  @override
  String get searchHint => 'طعام، بقالة، وغيرها';

  @override
  String get deliveryAddress => 'بارك واي ١٤٥';

  @override
  String get recommended => 'مقترح لك';

  @override
  String get hotOffers => 'عروض حارة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get nearYou => 'بالقرب منك';

  @override
  String get categoriesAll => 'الكل';

  @override
  String get categoriesChicken => 'دجاج';

  @override
  String get categoriesPizza => 'بيتزا';

  @override
  String get categoriesRamen => 'رامون';

  @override
  String get categoriesBurgers => 'برجر';

  @override
  String get categoriesDesserts => 'حلويات';

  @override
  String get categoriesSeafood => 'مأكولات بحرية';

  @override
  String get categoriesVegetarian => 'نباتي';

  @override
  String get addToCart => 'أضف إلى السلة';

  @override
  String inCartCount(int count) {
    return '$count في السلة';
  }

  @override
  String get increaseQuantity => 'أضف قطعة أخرى';

  @override
  String get decreaseQuantity => 'احذف قطعة';

  @override
  String addedToCart(String name) {
    return 'تمت إضافة $name إلى السلة';
  }

  @override
  String removedFromCart(String name) {
    return 'تم حذف $name من السلة';
  }

  @override
  String get saveToFavourites => 'أضف إلى المفضلة';

  @override
  String get removeFromFavourites => 'احذف من المفضلة';

  @override
  String get savedToFavourites => 'تم الحفظ في المفضلة';

  @override
  String get removedFromFavouritesMessage => 'تم الحذف من المفضلة';

  @override
  String get favourites => 'المفضلة';

  @override
  String get favouritesEmpty => 'لا توجد مفضلات بعد';

  @override
  String get favouritesEmptyBody => 'اضغط على القلب في أي طبق لحفظه هنا.';

  @override
  String get mealDetails => 'تفاصيل الطبق';

  @override
  String get category => 'التصنيف';

  @override
  String get instructions => 'طريقة التحضير';

  @override
  String get noInstructions => 'لم يضِف البائع بعد ملاحظات تحضير لهذا الطبق.';

  @override
  String get price => 'السعر';

  @override
  String get mealNotFound => 'هذا الطبق لم يعد متاحاً';

  @override
  String get cart => 'السلة';

  @override
  String get cartEmpty => 'سلتك فارغة';

  @override
  String get cartEmptyBody => 'أضف طبقاً من الصفحة الرئيسية للبدء.';

  @override
  String get browseMenu => 'تصفح القائمة';

  @override
  String get yourCartCleared => 'أصبحت سلتك فارغة';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get deliveryFee => 'رسوم التوصيل';

  @override
  String get serviceFee => 'رسوم الخدمة';

  @override
  String get total => 'الإجمالي';

  @override
  String get free => 'مجاني';

  @override
  String placeOrderFor(String amount) {
    return 'تأكيد الطلب · $amount';
  }

  @override
  String get orderPlacedTitle => 'تم تأكيد الطلب!';

  @override
  String get orderPlacedMessage =>
      'طلبك في الطريق إليك. الوصول المتوقع خلال ٢٥–٣٠ دقيقة.';

  @override
  String get viewMyOrders => 'عرض طلباتي';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get payCash => 'نقداً';

  @override
  String get payCard => 'بطاقة';

  @override
  String get cashOnDeliveryHint => 'ادفع للبائع نقداً عند وصول الطلب.';

  @override
  String get cardPaymentHint => 'فيزا / ماستركارد تنتهي بـ ٤٢٤٢.';

  @override
  String get vendorMap => 'البائعون القريبون';

  @override
  String vendorDistance(String distance) {
    return 'على بُعد $distance كم';
  }

  @override
  String get directions => 'الاتجاهات';

  @override
  String get vendorList => 'قائمة البائعين';

  @override
  String get profile => 'حسابي';

  @override
  String get pickFromGallery => 'اختر من المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get photoUpdated => 'تم تحديث صورة الحساب';

  @override
  String get photoUpdateFailed => 'تعذّر تحديث الصورة';

  @override
  String get deviceInformation => 'معلومات الجهاز';

  @override
  String get deviceModel => 'الموديل';

  @override
  String get deviceOs => 'إصدار النظام';

  @override
  String get deviceName => 'اسم الجهاز';

  @override
  String get orderHistory => 'سجل الطلبات';

  @override
  String get orderHistoryEmpty => 'لا توجد طلبات بعد';

  @override
  String get orderHistoryEmptyBody => 'ستظهر الطلبات التي أكدتها هنا.';

  @override
  String orderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتجات',
      one: 'منتج واحد',
    );
    return '$_temp0';
  }

  @override
  String paidWith(String method) {
    return 'الدفع بـ $method';
  }

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String orderNumber(String id) {
    return 'طلب رقم $id';
  }

  @override
  String get orderPreparing => 'جارٍ التحضير';

  @override
  String get orderDelivered => 'تم التسليم';

  @override
  String placedOn(String date) {
    return 'أُنشئ في $date';
  }

  @override
  String get orderItemsTitle => 'الأصناف';

  @override
  String orderLineQuantity(int count) {
    return '× $count';
  }

  @override
  String get reorder => 'إعادة الطلب';

  @override
  String get reorderDone => 'أُضيف هذا الطلب إلى سلتك مرة أخرى';

  @override
  String get current => 'حالي';

  @override
  String get past => 'سابق';

  @override
  String get biometricPromptTitle => 'افتح حسابك';

  @override
  String get biometricReason => 'أكّد هويتك لفتح StreetBite';

  @override
  String get biometricSubtitle => 'أكّد هويتك لعرض حسابك في StreetBite.';

  @override
  String get biometricFailed => 'فشل التحقق البيومتري. حاول مرة أخرى.';

  @override
  String get biometricNotEnrolled =>
      'لا يوجد بصمة إصبع أو وجه مسجل على هذا الجهاز.';

  @override
  String get biometricNotSupported =>
      'المصادقة البيومترية غير مدعومة على هذا الجهاز.';

  @override
  String get biometricCancelled => 'تم إلغاء التحقق البيومتري.';

  @override
  String get biometricLockedOut => 'محاولات كثيرة فاشلة. البصمة مقفلة مؤقتًا.';

  @override
  String get useInstead => 'المتابعة بدون البصمة';

  @override
  String get skip => 'تخطي';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get lightMode => 'الوضع النهاري';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get failureNetwork =>
      'تعذّر الوصول إلى StreetBite. تأكد من اتصالك وحاول مرة أخرى.';

  @override
  String get failureCache => 'لا توجد نسخة محفوظة من هذه البيانات بعد.';

  @override
  String get failureCancelled => 'تم إلغاء العملية.';

  @override
  String get failureGeneric => 'خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get validationNameRequired => 'يرجى إدخال اسمك الكامل.';

  @override
  String get validationNameTwoWords => 'يرجى إدخال الاسم الأول واسم العائلة.';

  @override
  String get validationNameCapital => 'يجب أن يبدأ الاسم بحرف كبير.';

  @override
  String get validationEmailRequired => 'يرجى إدخال بريدك الإلكتروني.';

  @override
  String get validationEmailInvalid => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get validationPasswordRequired => 'يرجى إدخال كلمة المرور.';

  @override
  String get validationPasswordShort =>
      'كلمة المرور يجب أن تكون ٦ أحرف على الأقل.';

  @override
  String get validationConfirmRequired => 'يرجى تأكيد كلمة المرور.';

  @override
  String get validationPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get authErrorInvalidEmail => 'البريد الإلكتروني غير صالح.';

  @override
  String get authErrorEmailInUse => 'يوجد حساب مسجّل بهذا البريد بالفعل.';

  @override
  String get authErrorWeakPassword => 'يرجى اختيار كلمة مرور أقوى.';

  @override
  String get authErrorUserNotFound => 'لا يوجد حساب بهذا البريد الإلكتروني.';

  @override
  String get authErrorWrongPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authErrorTooManyRequests => 'محاولات كثيرة. يرجى المحاولة لاحقاً.';

  @override
  String get authErrorNetwork => 'تعذّر التحقق من حسابك. تأكد من اتصالك.';

  @override
  String get authErrorUnknown => 'تعذّر تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get authLoggedOut => 'تم تسجيل خروجك.';

  @override
  String get authSessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceHint => 'يتم تطبيق السمة واللغة فورًا في كل التطبيق.';

  @override
  String get themeMode => 'السمة';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLiquidGlass => 'زجاجي';

  @override
  String get themeLiquidGlassHint =>
      'أسطح مصقولة تنكس الضوء. تحتاج معالج رسومات، وتعود تلقائيًا للأداء الأخف.';

  @override
  String get themeSheetTitle => 'اختر المظهر';

  @override
  String get themeOptionLightHint => 'أسطح صلبة مناسبة للنهار';

  @override
  String get themeOptionDarkHint => 'أسطح صلبة مريحة لليل';

  @override
  String get themeOptionGlassLightHint => 'زجاج مصقول فوق تدرج فاتح';

  @override
  String get themeOptionGlassDarkHint => 'زجاج مصقول فوق تدرج داكن';

  @override
  String get viewAllThemes => 'عرض كل المظاهر';

  @override
  String get security => 'الأمان';

  @override
  String get biometricUnlock => 'الفتح بالبصمة';

  @override
  String get biometricUnlockHint =>
      'اطلب البصمة أو الوجه قبل فتح الملف الشخصي.';

  @override
  String get biometricStatusAvailable => 'متاحة على هذا الجهاز';

  @override
  String get biometricStatusUnavailable => 'غير متاحة على هذا الجهاز';

  @override
  String get general => 'عام';

  @override
  String get vendorMapHint => 'شاهد خمسة من بائعي StreetBite القريبين منك.';
}
