// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PayCheck';

  @override
  String get appSubtitle => 'Contract & Receipt Management';

  @override
  String get clients => 'Clients';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get settings => 'Settings';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get orContinueWith => 'OR CONTINUE WITH';

  @override
  String get signInWithGoogle => 'Sign In with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmailToReset =>
      'Enter your email address to receive a password reset link.';

  @override
  String get send => 'Send';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get emailSentSuccess => 'A reset link has been sent to your email!';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get deleteAccount => 'Delete My Account';

  @override
  String get deleteAccountTitle => 'Permanently Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'Warning: This action is irreversible.\nAll your data (clients, contracts, payment history) will be permanently deleted.';

  @override
  String get deletingAccount => 'Deleting account...';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get version => 'Version';

  @override
  String get language => 'Language';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get spanish => 'Spanish';

  @override
  String get search => 'Search...';

  @override
  String get addClient => 'Add Client';

  @override
  String get editClient => 'Edit Client';

  @override
  String get clientDetails => 'Client Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get contractNumber => 'Contract Number';

  @override
  String get paymentPeriod => 'Payment Period';

  @override
  String get monthly => 'Monthly';

  @override
  String get quarterly => 'Quarterly';

  @override
  String get semester => 'Semi-Annual';

  @override
  String get annual => 'Annual';

  @override
  String get amountDue => 'Amount Due';

  @override
  String get contractStartDate => 'Contract Start Date';

  @override
  String get nextPaymentDue => 'Next Payment Due';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get archive => 'Archive';

  @override
  String get activate => 'Activate';

  @override
  String get save => 'Save';

  @override
  String get clientAdded => 'Client added successfully!';

  @override
  String get clientUpdated => 'Client updated successfully!';

  @override
  String get addPayment => 'Add Payment';

  @override
  String get recordPayment => 'Record Payment';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get viewHistory => 'View History';

  @override
  String get amountPaid => 'Amount Paid (DT)';

  @override
  String get paymentDate => 'Payment Date';

  @override
  String get periodStart => 'Period Start';

  @override
  String get periodCoveredFrom => 'Period covered start';

  @override
  String get periodEnd => 'Period End';

  @override
  String periodUntil(String date) {
    return 'Until $date';
  }

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Bank Card';

  @override
  String get check => 'Check';

  @override
  String get postal => 'Postal Transfer';

  @override
  String get quittanceGiven => 'Receipt (Quittance) Given';

  @override
  String get quittanceRemote => 'Remote payment — remember to send the receipt';

  @override
  String get quittanceDate => 'Receipt Date';

  @override
  String get paymentAdded => 'Payment recorded successfully!';

  @override
  String get savingPayment => 'Saving...';

  @override
  String get savePayment => 'Save Payment';

  @override
  String get invalidAmount => 'Invalid amount';

  @override
  String get enterValidAmount => 'Enter a valid amount (> 0)';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get activeClients => 'Active Clients';

  @override
  String get overdueClients => 'Overdue Clients';

  @override
  String get pendingQuittances => 'Pending Receipts';

  @override
  String allOverdueClients(int count) {
    return 'All Overdue Clients ($count)';
  }

  @override
  String get contract => 'Contract';

  @override
  String viewAllOverdue(int count) {
    return 'See all overdue (+$count)';
  }

  @override
  String get noClients => 'No clients yet. Add your first client!';

  @override
  String get noPayments => 'No payments recorded yet.';

  @override
  String get overdue => 'Overdue';

  @override
  String get upToDate => 'Up to Date';

  @override
  String get quittancePending => 'Receipt Pending';

  @override
  String get syncOnline => 'Online — Synced';

  @override
  String get syncOffline => 'Offline — Saved Locally';

  @override
  String get requiresRecentLogin =>
      'For security reasons, please log in again before deleting your account.';

  @override
  String get invalidEmail => 'Invalid Email';

  @override
  String get minPasswordLength => 'At least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get requiredField => 'Required field';

  @override
  String get infoAndLegal => 'Information & Legal';

  @override
  String get account => 'Account';

  @override
  String get loginFailed => 'Sign in failed';

  @override
  String get googleSignInFailed => 'Google Sign-In failed';

  @override
  String get error => 'Error';

  @override
  String get collectedThisMonth => 'Collected this month';

  @override
  String vsLastMonth(String pct) {
    return '$pct% vs last month';
  }

  @override
  String paymentsCount(int count) {
    return '$count payments';
  }

  @override
  String get overdueTitle => 'Overdue Clients';

  @override
  String get distributionByMethod => 'Distribution by Payment Method';

  @override
  String get dueSoon => 'Due Soon (7d)';

  @override
  String get historyTitle => 'Payment History';

  @override
  String get history => 'History';

  @override
  String get noPaymentsHistory => 'No payments recorded';

  @override
  String get onbNext => 'Next';

  @override
  String get onbSkip => 'Skip';

  @override
  String get onbGetStarted => 'Get Started';

  @override
  String get onbFinish => 'All Set! 🎉';

  @override
  String get feat1Title => 'Manage Your Clients';

  @override
  String get feat1Desc =>
      'Add clients with their contracts, schedules, and contact info — all organized in one place.';

  @override
  String get feat2Title => 'Track Every Payment';

  @override
  String get feat2Desc =>
      'Record payments by cash, card, check, or transfer and generate receipts in seconds.';

  @override
  String get feat3Title => 'Instant Insights';

  @override
  String get feat3Desc =>
      'See your monthly revenue, overdue clients, and upcoming payments at a glance.';

  @override
  String get onbProfessionTitle => 'What\'s your profession?';

  @override
  String get onbProfessionSubtitle =>
      'We\'ll tailor the experience to fit your work';

  @override
  String get profRealEstate => 'Real Estate Agent';

  @override
  String get profPropertyManager => 'Property Manager';

  @override
  String get profAccountant => 'Accountant';

  @override
  String get profContractor => 'Contractor';

  @override
  String get profFreelancer => 'Freelancer';

  @override
  String get profBusinessOwner => 'Business Owner';

  @override
  String get profOther => 'Other';

  @override
  String get onbAgeTitle => 'How old are you?';

  @override
  String get onbAgeSubtitle => 'Help us understand our users better';

  @override
  String get ageUnder25 => 'Under 25';

  @override
  String get age25_34 => '25 – 34';

  @override
  String get age35_44 => '35 – 44';

  @override
  String get age45_54 => '45 – 54';

  @override
  String get age55Plus => '55 +';

  @override
  String get onbCountryTitle => 'Where are you based?';

  @override
  String get onbCountrySubtitle =>
      'We\'ll set the right currency for you automatically';

  @override
  String get onbCountrySearch => 'Search country...';

  @override
  String get onbNotifTitle => 'Never Miss a Payment';

  @override
  String get onbNotifSubtitle =>
      'Get reminders before payment due dates so you always stay on top of your revenue.';

  @override
  String get onbNotifEnable => 'Enable Notifications';

  @override
  String get onbNotifSkip => 'Maybe Later';

  @override
  String get onbNotifGranted => 'Notifications enabled ✓';

  @override
  String get notifEnabledTitle => 'Notifications Enabled ✓';

  @override
  String get notifEnabledBody =>
      'PayCheck will alert you when client payments are due or overdue.';

  @override
  String get notifOverdueTitle => '⚠️ Overdue Payment Alert';

  @override
  String notifOverdueBody(
    String clientName,
    String amount,
    String currency,
    String contractNumber,
  ) {
    return '$clientName owes $amount $currency (Contract N° $contractNumber)';
  }

  @override
  String get notifDueSoonTitle => '📅 Payment Due Soon';

  @override
  String get notifDueTodayMsg => 'Payment due today!';

  @override
  String notifDueInDaysMsg(int days) {
    return 'Payment due in $days day(s)';
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

  @override
  String get contractDetails => 'Contract Details';

  @override
  String get contractSummary => 'Contract Summary';

  @override
  String get contractStart => 'Contract Start';

  @override
  String get receiptIssued => 'Receipt Issued';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String inDays(int count) {
    return 'In $count days';
  }

  @override
  String contractWithNumber(String number) {
    return 'Contract $number';
  }

  @override
  String paymentDateWithLabel(String date) {
    return 'Payment Date: $date';
  }
}
