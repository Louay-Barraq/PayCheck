import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PayCheck'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contract & Receipt Management'**
  String get appSubtitle;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'OR CONTINUE WITH'**
  String get orContinueWith;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a password reset link.'**
  String get enterEmailToReset;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @emailSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'A reset link has been sent to your email!'**
  String get emailSentSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Warning: This action is irreversible.\nAll your data (clients, contracts, payment history) will be permanently deleted.'**
  String get deleteAccountConfirmation;

  /// No description provided for @deletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// No description provided for @clientDetails.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @contractNumber.
  ///
  /// In en, this message translates to:
  /// **'Contract Number'**
  String get contractNumber;

  /// No description provided for @paymentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Payment Period'**
  String get paymentPeriod;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @quarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get quarterly;

  /// No description provided for @semester.
  ///
  /// In en, this message translates to:
  /// **'Semi-Annual'**
  String get semester;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @contractStartDate.
  ///
  /// In en, this message translates to:
  /// **'Contract Start Date'**
  String get contractStartDate;

  /// No description provided for @nextPaymentDue.
  ///
  /// In en, this message translates to:
  /// **'Next Payment Due'**
  String get nextPaymentDue;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @clientAdded.
  ///
  /// In en, this message translates to:
  /// **'Client added successfully!'**
  String get clientAdded;

  /// No description provided for @clientUpdated.
  ///
  /// In en, this message translates to:
  /// **'Client updated successfully!'**
  String get clientUpdated;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid (DT)'**
  String get amountPaid;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDate;

  /// No description provided for @periodStart.
  ///
  /// In en, this message translates to:
  /// **'Period Start'**
  String get periodStart;

  /// No description provided for @periodCoveredFrom.
  ///
  /// In en, this message translates to:
  /// **'Period covered start'**
  String get periodCoveredFrom;

  /// No description provided for @periodEnd.
  ///
  /// In en, this message translates to:
  /// **'Period End'**
  String get periodEnd;

  /// No description provided for @periodUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String periodUntil(String date);

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Bank Card'**
  String get card;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @postal.
  ///
  /// In en, this message translates to:
  /// **'Postal Transfer'**
  String get postal;

  /// No description provided for @quittanceGiven.
  ///
  /// In en, this message translates to:
  /// **'Receipt (Quittance) Given'**
  String get quittanceGiven;

  /// No description provided for @quittanceRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote payment — remember to send the receipt'**
  String get quittanceRemote;

  /// No description provided for @quittanceDate.
  ///
  /// In en, this message translates to:
  /// **'Receipt Date'**
  String get quittanceDate;

  /// No description provided for @paymentAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully!'**
  String get paymentAdded;

  /// No description provided for @savingPayment.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingPayment;

  /// No description provided for @savePayment.
  ///
  /// In en, this message translates to:
  /// **'Save Payment'**
  String get savePayment;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount (> 0)'**
  String get enterValidAmount;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @activeClients.
  ///
  /// In en, this message translates to:
  /// **'Active Clients'**
  String get activeClients;

  /// No description provided for @overdueClients.
  ///
  /// In en, this message translates to:
  /// **'Overdue Clients'**
  String get overdueClients;

  /// No description provided for @pendingQuittances.
  ///
  /// In en, this message translates to:
  /// **'Pending Receipts'**
  String get pendingQuittances;

  /// No description provided for @allOverdueClients.
  ///
  /// In en, this message translates to:
  /// **'All Overdue Clients ({count})'**
  String allOverdueClients(int count);

  /// No description provided for @contract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get contract;

  /// No description provided for @viewAllOverdue.
  ///
  /// In en, this message translates to:
  /// **'See all overdue (+{count})'**
  String viewAllOverdue(int count);

  /// No description provided for @noClients.
  ///
  /// In en, this message translates to:
  /// **'No clients yet. Add your first client!'**
  String get noClients;

  /// No description provided for @noPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded yet.'**
  String get noPayments;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to Date'**
  String get upToDate;

  /// No description provided for @quittancePending.
  ///
  /// In en, this message translates to:
  /// **'Receipt Pending'**
  String get quittancePending;

  /// No description provided for @syncOnline.
  ///
  /// In en, this message translates to:
  /// **'Online — Synced'**
  String get syncOnline;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline — Saved Locally'**
  String get syncOffline;

  /// No description provided for @requiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, please log in again before deleting your account.'**
  String get requiresRecentLogin;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalidEmail;

  /// No description provided for @minPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get minPasswordLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @infoAndLegal.
  ///
  /// In en, this message translates to:
  /// **'Information & Legal'**
  String get infoAndLegal;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get loginFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed'**
  String get googleSignInFailed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @collectedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Collected this month'**
  String get collectedThisMonth;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{pct}% vs last month'**
  String vsLastMonth(String pct);

  /// No description provided for @paymentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} payments'**
  String paymentsCount(int count);

  /// No description provided for @overdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Overdue Clients'**
  String get overdueTitle;

  /// No description provided for @distributionByMethod.
  ///
  /// In en, this message translates to:
  /// **'Distribution by Payment Method'**
  String get distributionByMethod;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon (7d)'**
  String get dueSoon;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get historyTitle;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noPaymentsHistory.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get noPaymentsHistory;

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onbGetStarted;

  /// No description provided for @onbFinish.
  ///
  /// In en, this message translates to:
  /// **'All Set! 🎉'**
  String get onbFinish;

  /// No description provided for @feat1Title.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Clients'**
  String get feat1Title;

  /// No description provided for @feat1Desc.
  ///
  /// In en, this message translates to:
  /// **'Add clients with their contracts, schedules, and contact info — all organized in one place.'**
  String get feat1Desc;

  /// No description provided for @feat2Title.
  ///
  /// In en, this message translates to:
  /// **'Track Every Payment'**
  String get feat2Title;

  /// No description provided for @feat2Desc.
  ///
  /// In en, this message translates to:
  /// **'Record payments by cash, card, check, or transfer and generate receipts in seconds.'**
  String get feat2Desc;

  /// No description provided for @feat3Title.
  ///
  /// In en, this message translates to:
  /// **'Instant Insights'**
  String get feat3Title;

  /// No description provided for @feat3Desc.
  ///
  /// In en, this message translates to:
  /// **'See your monthly revenue, overdue clients, and upcoming payments at a glance.'**
  String get feat3Desc;

  /// No description provided for @onbProfessionTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your profession?'**
  String get onbProfessionTitle;

  /// No description provided for @onbProfessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor the experience to fit your work'**
  String get onbProfessionSubtitle;

  /// No description provided for @profRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate Agent'**
  String get profRealEstate;

  /// No description provided for @profPropertyManager.
  ///
  /// In en, this message translates to:
  /// **'Property Manager'**
  String get profPropertyManager;

  /// No description provided for @profAccountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get profAccountant;

  /// No description provided for @profContractor.
  ///
  /// In en, this message translates to:
  /// **'Contractor'**
  String get profContractor;

  /// No description provided for @profFreelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get profFreelancer;

  /// No description provided for @profBusinessOwner.
  ///
  /// In en, this message translates to:
  /// **'Business Owner'**
  String get profBusinessOwner;

  /// No description provided for @profOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profOther;

  /// No description provided for @onbAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get onbAgeTitle;

  /// No description provided for @onbAgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us understand our users better'**
  String get onbAgeSubtitle;

  /// No description provided for @ageUnder25.
  ///
  /// In en, this message translates to:
  /// **'Under 25'**
  String get ageUnder25;

  /// No description provided for @age25_34.
  ///
  /// In en, this message translates to:
  /// **'25 – 34'**
  String get age25_34;

  /// No description provided for @age35_44.
  ///
  /// In en, this message translates to:
  /// **'35 – 44'**
  String get age35_44;

  /// No description provided for @age45_54.
  ///
  /// In en, this message translates to:
  /// **'45 – 54'**
  String get age45_54;

  /// No description provided for @age55Plus.
  ///
  /// In en, this message translates to:
  /// **'55 +'**
  String get age55Plus;

  /// No description provided for @onbCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you based?'**
  String get onbCountryTitle;

  /// No description provided for @onbCountrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll set the right currency for you automatically'**
  String get onbCountrySubtitle;

  /// No description provided for @onbCountrySearch.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get onbCountrySearch;

  /// No description provided for @onbNotifTitle.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Payment'**
  String get onbNotifTitle;

  /// No description provided for @onbNotifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get reminders before payment due dates so you always stay on top of your revenue.'**
  String get onbNotifSubtitle;

  /// No description provided for @onbNotifEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get onbNotifEnable;

  /// No description provided for @onbNotifSkip.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get onbNotifSkip;

  /// No description provided for @onbNotifGranted.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled ✓'**
  String get onbNotifGranted;

  /// No description provided for @notifEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled ✓'**
  String get notifEnabledTitle;

  /// No description provided for @notifEnabledBody.
  ///
  /// In en, this message translates to:
  /// **'PayCheck will alert you when client payments are due or overdue.'**
  String get notifEnabledBody;

  /// No description provided for @notifOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Overdue Payment Alert'**
  String get notifOverdueTitle;

  /// No description provided for @notifOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'{clientName} owes {amount} {currency} (Contract N° {contractNumber})'**
  String notifOverdueBody(
    String clientName,
    String amount,
    String currency,
    String contractNumber,
  );

  /// No description provided for @notifDueSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'📅 Payment Due Soon'**
  String get notifDueSoonTitle;

  /// No description provided for @notifDueTodayMsg.
  ///
  /// In en, this message translates to:
  /// **'Payment due today!'**
  String get notifDueTodayMsg;

  /// No description provided for @notifDueInDaysMsg.
  ///
  /// In en, this message translates to:
  /// **'Payment due in {days} day(s)'**
  String notifDueInDaysMsg(int days);

  /// No description provided for @notifDueSoonBody.
  ///
  /// In en, this message translates to:
  /// **'{clientName} — {dueMsg} ({amount} {currency})'**
  String notifDueSoonBody(
    String clientName,
    String dueMsg,
    String amount,
    String currency,
  );

  /// No description provided for @contractDetails.
  ///
  /// In en, this message translates to:
  /// **'Contract Details'**
  String get contractDetails;

  /// No description provided for @contractSummary.
  ///
  /// In en, this message translates to:
  /// **'Contract Summary'**
  String get contractSummary;

  /// No description provided for @contractStart.
  ///
  /// In en, this message translates to:
  /// **'Contract Start'**
  String get contractStart;

  /// No description provided for @receiptIssued.
  ///
  /// In en, this message translates to:
  /// **'Receipt Issued'**
  String get receiptIssued;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String inDays(int count);

  /// No description provided for @contractWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Contract {number}'**
  String contractWithNumber(String number);

  /// No description provided for @paymentDateWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date: {date}'**
  String paymentDateWithLabel(String date);

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @chooseAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your app language'**
  String get chooseAppLanguage;

  /// No description provided for @readPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get readPrivacyPolicy;

  /// No description provided for @currentAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Current app version'**
  String get currentAppVersion;

  /// No description provided for @signOutDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign out from your account'**
  String get signOutDescription;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountDescription;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or feedback, we\'re here to help.'**
  String get supportDescription;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @supportNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Support contact is not configured yet.'**
  String get supportNotConfigured;

  /// No description provided for @dataSecurePrivate.
  ///
  /// In en, this message translates to:
  /// **'Your data is secure and private.'**
  String get dataSecurePrivate;
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
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

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
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
