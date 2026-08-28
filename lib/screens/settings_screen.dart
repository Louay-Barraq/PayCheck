import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_providers.dart';
import '../providers/client_providers.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _deleting = false;

  Future<void> _launchPrivacyPolicy() async {
    final uri = Uri.parse('https://louay-barraq.github.io/PayCheck/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir la page.')),
        );
      }
    }
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(dialogCtx),
            child: Container(
              width: double.maxFinite,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(70),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final auth = ref.read(authServiceProvider);
              await auth.signOut();
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(
          'Supprimer définitivement le compte',
          style: TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Attention : Cette action est irréversible.\nToutes vos données (clients, contrats, historique des paiements) seront définitivement effacées.',
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.pop(dialogCtx),
            child: Container(
              width: double.maxFinite,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(70),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              setState(() => _deleting = true);
              final messenger = ScaffoldMessenger.of(context);

              try {
                // 1. Delete all Firestore data for this user
                final firestoreService = ref.read(firestoreServiceProvider);
                await firestoreService.deleteAllUserData();

                // 2. Delete Auth account
                final authService = ref.read(authServiceProvider);
                await authService.deleteAccount();
              } on FirebaseAuthException catch (e) {
                if (mounted) {
                  setState(() => _deleting = false);
                  if (e.code == 'requires-recent-login') {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pour des raisons de sécurité, veuillez vous reconnecter avant de supprimer votre compte.',
                        ),
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Erreur: ${e.message}')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _deleting = false);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la suppression: $e'),
                    ),
                  );
                }
              }
            },
            child: const Text('Supprimer mon compte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Compte utilisateur';
    final displayName = user?.displayName;

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: _deleting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.danger),
                  SizedBox(height: 16),
                  Text('Suppression du compte en cours...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            (displayName?.isNotEmpty == true
                                    ? displayName![0]
                                    : (email.isNotEmpty ? email[0] : 'U'))
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (displayName != null && displayName.isNotEmpty)
                                Text(
                                  displayName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Informations & Confidentialité',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.privacy_tip_outlined,
                          color: AppColors.primary,
                        ),
                        title: const Text('Politique de confidentialité'),
                        trailing: const Icon(
                          Icons.open_in_new,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        onTap: _launchPrivacyPolicy,
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                        ),
                        title: Text('Version'),
                        trailing: Text(
                          '1.0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Compte',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: AppColors.textPrimary,
                        ),
                        title: const Text('Se déconnecter'),
                        onTap: _confirmSignOut,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever_outlined,
                          color: AppColors.danger,
                        ),
                        title: const Text(
                          'Supprimer mon compte',
                          style: TextStyle(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Efface définitivement toutes vos données',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: _confirmDeleteAccount,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
