// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'PayCheck';

  @override
  String get appSubtitle => 'إدارة العقود والإيصالات';

  @override
  String get clients => 'العملاء';

  @override
  String get dashboard => 'لوحة القيادة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب جديد';

  @override
  String get orContinueWith => 'أو المتابعة باستخدام';

  @override
  String get signInWithGoogle => 'الدخول بواسطة جوجل';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get enterEmailToReset =>
      'أدخل بريدك الإلكتروني لتلقي رابط إعادة التعيين.';

  @override
  String get send => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get emailSentSuccess =>
      'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني!';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteAccountTitle => 'حذف الحساب نهائياً';

  @override
  String get deleteAccountConfirmation =>
      'تحذير: هذا الإجراء لا يمكن التراجع عنه.\nسيتم حذف جميع بياناتك (العملاء، العقود، وسجل المدفوعات) نهائياً.';

  @override
  String get deletingAccount => 'جاري حذف الحساب...';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get version => 'النسخة';

  @override
  String get language => 'اللغة';

  @override
  String get french => 'الفرنسية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get search => 'بحث...';

  @override
  String get addClient => 'إضافة عميل';

  @override
  String get editClient => 'تعديل العميل';

  @override
  String get clientDetails => 'تفاصيل العميل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get contractNumber => 'رقم العقد';

  @override
  String get paymentPeriod => 'دورية الدفع';

  @override
  String get monthly => 'شهري';

  @override
  String get quarterly => 'ربع سنوي';

  @override
  String get semester => 'نصف سنوي';

  @override
  String get annual => 'سنوي';

  @override
  String get amountDue => 'المبلغ المطلوب';

  @override
  String get contractStartDate => 'تاريخ بدء العقد';

  @override
  String get nextPaymentDue => 'الموعد القادم للدفع';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get archive => 'أرشفة';

  @override
  String get activate => 'تفعيل';

  @override
  String get save => 'حفظ';

  @override
  String get clientAdded => 'تم إضافة العميل بنجاح!';

  @override
  String get clientUpdated => 'تم تحديث العميل بنجاح!';

  @override
  String get addPayment => 'إضافة دفعة';

  @override
  String get recordPayment => 'تسجيل دفعة';

  @override
  String get paymentHistory => 'سجل المدفوعات';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get amountPaid => 'المبلغ المدفوع (DT)';

  @override
  String get paymentDate => 'تاريخ الدفع';

  @override
  String get periodStart => 'بداية الفترة';

  @override
  String get periodCoveredFrom => 'بداية الفترة المشمولة';

  @override
  String get periodEnd => 'نهاية الفترة';

  @override
  String periodUntil(String date) {
    return 'حتى $date';
  }

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cash => 'نقداً';

  @override
  String get card => 'بطاقة بنكية';

  @override
  String get check => 'شيك';

  @override
  String get postal => 'حوالة بريدية';

  @override
  String get quittanceGiven => 'تم تسليم الوصل';

  @override
  String get quittanceRemote => 'دفع عن بُعد — تذكر إرسال الوصل';

  @override
  String get quittanceDate => 'تاريخ الوصل';

  @override
  String get paymentAdded => 'تم تسجيل الدفعة بنجاح!';

  @override
  String get savingPayment => 'جاري الحفظ...';

  @override
  String get savePayment => 'حفظ الدفعة';

  @override
  String get invalidAmount => 'مبلغ غير صالح';

  @override
  String get enterValidAmount => 'أدخل مبلغاً صالحاً (> 0)';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get activeClients => 'العملاء النشطون';

  @override
  String get overdueClients => 'المدفوعات المتأخرة';

  @override
  String get pendingQuittances => 'إيصالات قيد الانتظار';

  @override
  String allOverdueClients(int count) {
    return 'العملاء المتأخرون ($count)';
  }

  @override
  String get contract => 'عقد';

  @override
  String viewAllOverdue(int count) {
    return 'عرض كافة المتأخرات (+$count)';
  }

  @override
  String get noClients => 'لا يوجد عملاء حالياً. أضف عميلك الأول!';

  @override
  String get noPayments => 'لم يتم تسجيل أي مدفوعات بعد.';

  @override
  String get overdue => 'متأخر';

  @override
  String get upToDate => 'خالص';

  @override
  String get quittancePending => 'في انتظار الوصل';

  @override
  String get syncOnline => 'متصل — تم المزامنة';

  @override
  String get syncOffline => 'غير متصل — تم الحفظ محلياً';

  @override
  String get requiresRecentLogin =>
      'لدواعي أمنية، يرجى إعادة تسجيل الدخول قبل حذف الحساب.';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صالح';

  @override
  String get minPasswordLength => '6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get requiredField => 'حقل مطلوب';

  @override
  String get infoAndLegal => 'المعلومات والخصوصية';

  @override
  String get account => 'الحساب';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get googleSignInFailed => 'فشل الدخول بواسطة جوجل';

  @override
  String get error => 'خطأ';

  @override
  String get collectedThisMonth => 'المحصّل هذا الشهر';

  @override
  String vsLastMonth(String pct) {
    return '$pct% مقارنة بالشهر الماضي';
  }

  @override
  String paymentsCount(int count) {
    return '$count دفعة';
  }

  @override
  String get overdueTitle => 'العملاء المتأخرون';

  @override
  String get distributionByMethod => 'التوزيع حسب طريقة الدفع';

  @override
  String get dueSoon => 'استحقاقات (7 أيام)';

  @override
  String get historyTitle => 'سجل المدفوعات';

  @override
  String get history => 'السجل';

  @override
  String get noPaymentsHistory => 'لا توجد مدفوعات مسجلة';

  @override
  String get onbNext => 'التالي';

  @override
  String get onbSkip => 'تخطي';

  @override
  String get onbGetStarted => 'ابدأ الآن';

  @override
  String get onbFinish => 'انطلق! 🎉';

  @override
  String get feat1Title => 'أدِر عملاءك';

  @override
  String get feat1Desc =>
      'أضف العملاء مع عقودهم ومواعيدهم ومعلومات التواصل — كل شيء منظم في مكان واحد.';

  @override
  String get feat2Title => 'تتبّع كل دفعة';

  @override
  String get feat2Desc =>
      'سجّل المدفوعات نقداً أو ببطاقة أو بشيك أو بحوالة، وأصدر الوصولات في ثوانٍ.';

  @override
  String get feat3Title => 'إحصاءات فورية';

  @override
  String get feat3Desc =>
      'اطّلع على إيراداتك الشهرية والمدفوعات المتأخرة والاستحقاقات القادمة دفعة واحدة.';

  @override
  String get onbProfessionTitle => 'ما هي مهنتك؟';

  @override
  String get onbProfessionSubtitle => 'سنخصّص التطبيق ليناسب عملك';

  @override
  String get profRealEstate => 'وكيل عقاري';

  @override
  String get profPropertyManager => 'مدير عقارات';

  @override
  String get profAccountant => 'محاسب';

  @override
  String get profContractor => 'مقاول';

  @override
  String get profFreelancer => 'مستقل';

  @override
  String get profBusinessOwner => 'صاحب عمل';

  @override
  String get profOther => 'أخرى';

  @override
  String get onbAgeTitle => 'كم عمرك؟';

  @override
  String get onbAgeSubtitle => 'ساعدنا على فهم مستخدمينا بشكل أفضل';

  @override
  String get ageUnder25 => 'أقل من 25';

  @override
  String get age25_34 => '25 – 34';

  @override
  String get age35_44 => '35 – 44';

  @override
  String get age45_54 => '45 – 54';

  @override
  String get age55Plus => '55 فأكثر';

  @override
  String get onbCountryTitle => 'أين تقيم؟';

  @override
  String get onbCountrySubtitle => 'سنضبط العملة المناسبة لك تلقائياً';

  @override
  String get onbCountrySearch => 'ابحث عن دولة...';

  @override
  String get onbNotifTitle => 'لا تفوّت أي دفعة';

  @override
  String get onbNotifSubtitle =>
      'احصل على تذكيرات قبل مواعيد الاستحقاق لتبقى دائماً على اطلاع بإيراداتك.';

  @override
  String get onbNotifEnable => 'تفعيل الإشعارات';

  @override
  String get onbNotifSkip => 'ربما لاحقاً';

  @override
  String get onbNotifGranted => 'تم تفعيل الإشعارات ✓';

  @override
  String get notifEnabledTitle => 'تم تفعيل الإشعارات ✓';

  @override
  String get notifEnabledBody =>
      'سيقوم PayCheck بتنبيهك عند استحقاق أو تأخر دفعات عملائك.';

  @override
  String get notifOverdueTitle => '⚠️ تنبيه دفعة متأخرة';

  @override
  String notifOverdueBody(
    String clientName,
    String amount,
    String currency,
    String contractNumber,
  ) {
    return '$clientName مدين بمبلغ $amount $currency (عقد رقم $contractNumber)';
  }

  @override
  String get notifDueSoonTitle => '📅 دفعة مستحقة قريباً';

  @override
  String get notifDueTodayMsg => 'الدفعة مستحقة اليوم!';

  @override
  String notifDueInDaysMsg(int days) {
    return 'الدفعة مستحقة خلال $days يوم';
  }

  @override
  String notifDueSoonBody(
    String clientName,
    String dueMsg,
    String amount,
    String currency,
  ) {
    return '$clientName — $dueMsg ($amount $currency)';
  }
}
