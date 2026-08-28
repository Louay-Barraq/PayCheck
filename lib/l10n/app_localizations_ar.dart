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
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

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
  String get amountPaid => 'المبلغ المدفوع';

  @override
  String get paymentDate => 'تاريخ الدفع';

  @override
  String get periodStart => 'بداية الفترة';

  @override
  String get periodEnd => 'نهاية الفترة';

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
  String get quittanceDate => 'تاريخ الوصل';

  @override
  String get paymentAdded => 'تم تسجيل الدفعة بنجاح!';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get activeClients => 'العملاء النشطون';

  @override
  String get overdueClients => 'المدفوعات المتأخرة';

  @override
  String get pendingQuittances => 'إيصالات قيد الانتظار';

  @override
  String get viewAllOverdue => 'عرض كافة المتأخرات';

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
  String get error => 'خطأ';
}
