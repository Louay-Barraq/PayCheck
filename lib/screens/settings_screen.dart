import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/auth_providers.dart';
import '../providers/client_providers.dart';
import '../providers/locale_provider.dart';
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.error)),
        );
      }
    }
  }

  void _confirmSignOut() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final auth = ref.read(authServiceProvider);
              await auth.signOut();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(
          l10n.deleteAccountTitle,
          style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
        ),
        content: Text(l10n.deleteAccountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel),
          ),
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
                      SnackBar(content: Text(l10n.requiresRecentLogin)),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text('${l10n.error}: ${e.message}')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _deleting = false);
                  messenger.showSnackBar(
                    SnackBar(content: Text('${l10n.error}: $e')),
                  );
                }
              }
            },
            child: Text(l10n.deleteAccount),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'User';
    final displayName = user?.displayName;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: _deleting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.danger),
                  const SizedBox(height: 16),
                  Text(l10n.deletingAccount),
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
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    l10n.language,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.language_rounded, color: AppColors.primary),
                            const SizedBox(width: 16),
                            Text(
                              l10n.language,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: currentLocale.languageCode,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newLanguage) {
                            if (newLanguage != null) {
                              ref.read(localeProvider.notifier).changeLanguage(newLanguage);
                            }
                          },
                          items: [
                            DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                            DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
                            DropdownMenuItem(value: 'ar', child: Text(l10n.arabic)),
                            DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    'Info & Legal',
                    style: const TextStyle(
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
                        leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                        title: Text(l10n.privacyPolicy),
                        trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textSecondary),
                        onTap: _launchPrivacyPolicy,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: AppColors.primary),
                        title: Text(l10n.version),
                        trailing: const Text(
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
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    user != null ? 'Account' : '',
                    style: const TextStyle(
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
                        leading: const Icon(Icons.logout, color: AppColors.textPrimary),
                        title: Text(l10n.logout),
                        onTap: _confirmSignOut,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.delete_forever_outlined, color: AppColors.danger),
                        title: Text(
                          l10n.deleteAccount,
                          style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
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
