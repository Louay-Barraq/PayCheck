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
}
