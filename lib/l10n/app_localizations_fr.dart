// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'PayCheck';

  @override
  String get appSubtitle => 'Gestion des contrats & quittances';

  @override
  String get clients => 'Clients';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get settings => 'Paramètres';

  @override
  String get email => 'Adresse Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get orContinueWith => 'OU CONTINUER AVEC';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get enterEmailToReset =>
      'Entrez votre adresse email pour recevoir un lien de réinitialisation.';

  @override
  String get send => 'Envoyer';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get emailSentSuccess => 'Un email de réinitialisation a été envoyé !';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirmation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteAccountTitle => 'Supprimer définitivement le compte';

  @override
  String get deleteAccountConfirmation =>
      'Attention : Cette action est irréversible.\nToutes vos données (clients, contrats, historique des paiements) seront définitivement effacées.';

  @override
  String get deletingAccount => 'Suppression du compte en cours...';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get version => 'Version';

  @override
  String get language => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get arabic => 'Arabe';

  @override
  String get spanish => 'Espagnol';

  @override
  String get search => 'Rechercher...';

  @override
  String get addClient => 'Ajouter un client';

  @override
  String get editClient => 'Modifier le client';

  @override
  String get clientDetails => 'Détails du client';

  @override
  String get fullName => 'Nom Complet';

  @override
  String get phone => 'Numéro de téléphone';

  @override
  String get address => 'Adresse';

  @override
  String get contractNumber => 'Numéro de contrat';

  @override
  String get paymentPeriod => 'Périodicité';

  @override
  String get monthly => 'Mensuel';

  @override
  String get quarterly => 'Trimestriel';

  @override
  String get semester => 'Semestriel';

  @override
  String get annual => 'Annuel';

  @override
  String get amountDue => 'Montant dû';

  @override
  String get contractStartDate => 'Date début contrat';

  @override
  String get nextPaymentDue => 'Prochaine échéance';

  @override
  String get active => 'Actif';

  @override
  String get inactive => 'Inactif';

  @override
  String get archive => 'Archiver';

  @override
  String get activate => 'Activer';

  @override
  String get save => 'Enregistrer';

  @override
  String get clientAdded => 'Client ajouté avec succès !';

  @override
  String get clientUpdated => 'Client mis à jour avec succès !';

  @override
  String get addPayment => 'Ajouter un paiement';

  @override
  String get recordPayment => 'Enregistrer un paiement';

  @override
  String get paymentHistory => 'Historique des paiements';

  @override
  String get viewHistory => 'Voir l\'historique';

  @override
  String get amountPaid => 'Montant payé (DT)';

  @override
  String get paymentDate => 'Date de paiement';

  @override
  String get periodStart => 'Début période';

  @override
  String get periodCoveredFrom => 'Début de la période couverte';

  @override
  String get periodEnd => 'Fin période';

  @override
  String periodUntil(String date) {
    return 'Jusqu\'au $date';
  }

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get cash => 'Espèces';

  @override
  String get card => 'Carte Bancaire';

  @override
  String get check => 'Chèque';

  @override
  String get postal => 'Virement Postal';

  @override
  String get quittanceGiven => 'Quittance donnée';

  @override
  String get quittanceRemote =>
      'Paiement à distance — pensez à faire parvenir la quittance';

  @override
  String get quittanceDate => 'Date quittance';

  @override
  String get paymentAdded => 'Paiement enregistré avec succès !';

  @override
  String get savingPayment => 'Enregistrement...';

  @override
  String get savePayment => 'Enregistrer le paiement';

  @override
  String get invalidAmount => 'Montant invalide';

  @override
  String get enterValidAmount => 'Entrez un montant valide (> 0)';

  @override
  String get totalRevenue => 'Revenu total';

  @override
  String get activeClients => 'Clients actifs';

  @override
  String get overdueClients => 'Retards de paiement';

  @override
  String get pendingQuittances => 'Quittances en attente';

  @override
  String allOverdueClients(int count) {
    return 'Clients en retard ($count)';
  }

  @override
  String get contract => 'Contrat';

  @override
  String viewAllOverdue(int count) {
    return 'Voir tous les retards (+$count)';
  }

  @override
  String get noClients =>
      'Aucun client pour le moment. Ajoutez votre premier client !';

  @override
  String get noPayments => 'Aucun paiement enregistré pour le moment.';

  @override
  String get overdue => 'En retard';

  @override
  String get upToDate => 'À jour';

  @override
  String get quittancePending => 'Quittance en attente';

  @override
  String get syncOnline => 'En ligne — Synchronisé';

  @override
  String get syncOffline => 'Hors-ligne — Sauvegardé localement';

  @override
  String get requiresRecentLogin =>
      'Pour des raisons de sécurité, veuillez vous reconnecter avant de supprimer votre compte.';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get minPasswordLength => 'Min 6 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get infoAndLegal => 'Informations & Confidentialité';

  @override
  String get account => 'Compte';

  @override
  String get loginFailed => 'Échec de connexion';

  @override
  String get googleSignInFailed => 'Échec Google Sign-In';

  @override
  String get error => 'Erreur';

  @override
  String get collectedThisMonth => 'Encaissé ce mois';

  @override
  String vsLastMonth(String pct) {
    return '$pct% vs mois dernier';
  }

  @override
  String paymentsCount(int count) {
    return '$count paiements';
  }

  @override
  String get overdueTitle => 'Clients en retard';

  @override
  String get distributionByMethod => 'Répartition par méthode';

  @override
  String get dueSoon => 'Échéances (7j)';

  @override
  String get historyTitle => 'Historique des paiements';

  @override
  String get history => 'Historique';

  @override
  String get noPaymentsHistory => 'Aucun paiement enregistré';

  @override
  String get onbNext => 'Suivant';

  @override
  String get onbSkip => 'Passer';

  @override
  String get onbGetStarted => 'Commencer';

  @override
  String get onbFinish => 'C\'est parti ! 🎉';

  @override
  String get feat1Title => 'Gérez vos clients';

  @override
  String get feat1Desc =>
      'Ajoutez vos clients avec leurs contrats, échéances et coordonnées — tout organisé en un seul endroit.';

  @override
  String get feat2Title => 'Suivez chaque paiement';

  @override
  String get feat2Desc =>
      'Enregistrez les paiements en espèces, carte, chèque ou virement et générez des quittances en quelques secondes.';

  @override
  String get feat3Title => 'Tableau de bord instantané';

  @override
  String get feat3Desc =>
      'Visualisez vos encaissements du mois, vos clients en retard et vos prochaines échéances d\'un coup d\'œil.';

  @override
  String get onbProfessionTitle => 'Quelle est votre profession ?';

  @override
  String get onbProfessionSubtitle =>
      'Nous adapterons l\'application à votre activité';

  @override
  String get profRealEstate => 'Agent Immobilier';

  @override
  String get profPropertyManager => 'Gestionnaire de biens';

  @override
  String get profAccountant => 'Comptable';

  @override
  String get profContractor => 'Entrepreneur';

  @override
  String get profFreelancer => 'Freelance';

  @override
  String get profBusinessOwner => 'Chef d\'entreprise';

  @override
  String get profOther => 'Autre';

  @override
  String get onbAgeTitle => 'Quel âge avez-vous ?';

  @override
  String get onbAgeSubtitle => 'Aidez-nous à mieux comprendre nos utilisateurs';

  @override
  String get ageUnder25 => 'Moins de 25 ans';

  @override
  String get age25_34 => '25 – 34 ans';

  @override
  String get age35_44 => '35 – 44 ans';

  @override
  String get age45_54 => '45 – 54 ans';

  @override
  String get age55Plus => '55 ans et +';

  @override
  String get onbCountryTitle => 'Où êtes-vous basé ?';

  @override
  String get onbCountrySubtitle =>
      'Nous définirons automatiquement la bonne devise pour vous';

  @override
  String get onbCountrySearch => 'Rechercher un pays...';

  @override
  String get onbNotifTitle => 'Ne ratez aucun paiement';

  @override
  String get onbNotifSubtitle =>
      'Recevez des rappels avant les dates d\'échéance pour ne jamais manquer un encaissement.';

  @override
  String get onbNotifEnable => 'Activer les notifications';

  @override
  String get onbNotifSkip => 'Peut-être plus tard';

  @override
  String get onbNotifGranted => 'Notifications activées ✓';

  @override
  String get notifEnabledTitle => 'Notifications activées ✓';

  @override
  String get notifEnabledBody =>
      'PayCheck vous alertera lorsque les paiements de vos clients seront dus ou en retard.';

  @override
  String get notifOverdueTitle => '⚠️ Alerte paiement en retard';

  @override
  String notifOverdueBody(
    String clientName,
    String amount,
    String currency,
    String contractNumber,
  ) {
    return '$clientName doit $amount $currency (Contrat N° $contractNumber)';
  }

  @override
  String get notifDueSoonTitle => '📅 Paiement bientôt dû';

  @override
  String get notifDueTodayMsg => 'Paiement dû aujourd\'hui !';

  @override
  String notifDueInDaysMsg(int days) {
    return 'Paiement dû dans $days jour(s)';
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
  String get contractDetails => 'Détails du contrat';

  @override
  String get contractSummary => 'Résumé du contrat';

  @override
  String get contractStart => 'Début du contrat';

  @override
  String get receiptIssued => 'Reçu délivré';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String inDays(int count) {
    return 'Dans $count jours';
  }

  @override
  String contractWithNumber(String number) {
    return 'Contrat $number';
  }

  @override
  String paymentDateWithLabel(String date) {
    return 'Date de paiement : $date';
  }

  @override
  String get preferences => 'Préférences';

  @override
  String get chooseAppLanguage => 'Choisissez la langue de l\'application';

  @override
  String get readPrivacyPolicy =>
      'Consultez notre politique de confidentialité';

  @override
  String get currentAppVersion => 'Version actuelle de l\'application';

  @override
  String get signOutDescription => 'Se déconnecter de votre compte';

  @override
  String get deleteAccountDescription =>
      'Supprimer définitivement votre compte et toutes vos données';

  @override
  String get needHelp => 'Besoin d\'aide ?';

  @override
  String get supportDescription =>
      'Si vous avez des questions ou des commentaires, nous sommes là pour vous aider.';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get supportNotConfigured =>
      'Le contact du support n\'est pas encore configuré.';

  @override
  String get dataSecurePrivate => 'Vos données sont sécurisées et privées.';
}
