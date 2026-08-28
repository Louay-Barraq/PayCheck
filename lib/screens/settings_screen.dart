import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
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

  // ---------------------------------------------------------------------------
  // PRIVACY POLICY
  // ---------------------------------------------------------------------------

  Future<void> _launchPrivacyPolicy() async {
    final uri = Uri.parse(
      'https://louay-barraq.github.io/PayCheck/',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPORT
  // ---------------------------------------------------------------------------
  //
  // Replace this with your actual support email / support URL.
  //
  Future<void> _contactSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'louaybarraq@gmail.com',
    );
  
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ---------------------------------------------------------------------------
  // SIGN OUT
  // ---------------------------------------------------------------------------

  void _confirmSignOut() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
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
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE ACCOUNT
  // ---------------------------------------------------------------------------

  void _confirmDeleteAccount() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(
            l10n.deleteAccountTitle,
            style: const TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            l10n.deleteAccountConfirmation,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () async {
                Navigator.pop(dialogCtx);

                setState(() {
                  _deleting = true;
                });

                final messenger = ScaffoldMessenger.of(context);

                try {
                  // 1. Delete all Firestore data for this user.
                  final firestoreService =
                      ref.read(firestoreServiceProvider);

                  await firestoreService.deleteAllUserData();

                  // 2. Delete Firebase Auth account.
                  final authService = ref.read(authServiceProvider);

                  await authService.deleteAccount();
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;

                  setState(() {
                    _deleting = false;
                  });

                  if (e.code == 'requires-recent-login') {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.requiresRecentLogin,
                        ),
                      ),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          '${l10n.error}: ${e.message}',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;

                  setState(() {
                    _deleting = false;
                  });

                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        '${l10n.error}: $e',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                l10n.deleteAccount,
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    final user = FirebaseAuth.instance.currentUser;

    final email = user?.email ?? 'User';
    final displayName = user?.displayName;

    final firstLetter = displayName?.isNotEmpty == true
        ? displayName![0]
        : email.isNotEmpty
            ? email[0]
            : 'U';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: _deleting
          ? _DeletingAccountView(
              message: l10n.deletingAccount,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                32,
              ),
              children: [
                // =============================================================
                // PROFILE
                // =============================================================

                _ProfileCard(
                  initial: firstLetter.toUpperCase(),
                  displayName: displayName,
                  email: email,
                ),

                const SizedBox(height: 28),

                // =============================================================
                // PREFERENCES
                // =============================================================

                _SectionTitle(
                  title: l10n.preferences,
                ),

                const SizedBox(height: 9),

                _SettingsCard(
                  child: _SettingsRow(
                    icon: Icons.language_rounded,
                    iconColor: AppColors.primary,
                    title: l10n.language,
                    subtitle: l10n.chooseAppLanguage,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _localizedLanguageName(
                            context,
                            currentLocale.languageCode,
                            l10n,
                          ),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 25,
                        ),
                      ],
                    ),
                    onTap: () {
                      _showLanguagePicker(
                        context,
                        currentLocale.languageCode,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // =============================================================
                // INFORMATION & LEGAL
                // =============================================================

                _SectionTitle(
                  title: l10n.infoAndLegal,
                ),

                const SizedBox(height: 9),

                _SettingsCard(
                  child: Column(
                    children: [
                      _SettingsRow(
                        icon: Icons.privacy_tip_outlined,
                        iconColor: AppColors.primary,
                        title: l10n.privacyPolicy,
                        subtitle: l10n.readPrivacyPolicy,
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 21,
                          color: AppColors.textSecondary,
                        ),
                        onTap: _launchPrivacyPolicy,
                      ),
                      const _SettingsDivider(),
                      _SettingsRow(
                        icon: Icons.info_outline_rounded,
                        iconColor: AppColors.primary,
                        title: l10n.version,
                        subtitle: l10n.currentAppVersion,
                        trailing: const Text(
                          '1.0.0',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =============================================================
                // ACCOUNT
                // =============================================================

                if (user != null) ...[
                  _SectionTitle(
                    title: l10n.account,
                  ),

                  const SizedBox(height: 9),

                  _SettingsCard(
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.logout_rounded,
                          iconColor: AppColors.textPrimary,
                          title: l10n.logout,
                          subtitle: l10n.signOutDescription,
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textSecondary,
                            size: 25,
                          ),
                          onTap: _confirmSignOut,
                        ),
                        const _SettingsDivider(),
                        _SettingsRow(
                          icon: Icons.delete_outline_rounded,
                          iconColor: AppColors.danger,
                          title: l10n.deleteAccount,
                          titleColor: AppColors.danger,
                          subtitle: l10n.deleteAccountDescription,
                          subtitleColor: AppColors.textSecondary,
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.danger,
                            size: 25,
                          ),
                          onTap: _confirmDeleteAccount,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                ],

                // =============================================================
                // HELP / SUPPORT
                // =============================================================

                _SupportCard(
                  title: l10n.needHelp,
                  description: l10n.supportDescription,
                  buttonText: l10n.contactSupport,
                  onPressed: _contactSupport,
                ),

                const SizedBox(height: 22),

                // =============================================================
                // SECURITY MESSAGE
                // =============================================================

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        l10n.dataSecurePrivate,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // LANGUAGE PICKER
  // ---------------------------------------------------------------------------

  void _showLanguagePicker(
    BuildContext context,
    String currentLanguage,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                _LanguageOption(
                  title: l10n.english,
                  languageCode: 'en',
                  selected: currentLanguage == 'en',
                  onTap: () {
                    ref
                        .read(localeProvider.notifier)
                        .changeLanguage('en');

                    Navigator.pop(sheetContext);
                  },
                ),

                _LanguageOption(
                  title: l10n.french,
                  languageCode: 'fr',
                  selected: currentLanguage == 'fr',
                  onTap: () {
                    ref
                        .read(localeProvider.notifier)
                        .changeLanguage('fr');

                    Navigator.pop(sheetContext);
                  },
                ),

                _LanguageOption(
                  title: l10n.arabic,
                  languageCode: 'ar',
                  selected: currentLanguage == 'ar',
                  onTap: () {
                    ref
                        .read(localeProvider.notifier)
                        .changeLanguage('ar');

                    Navigator.pop(sheetContext);
                  },
                ),

                _LanguageOption(
                  title: l10n.spanish,
                  languageCode: 'es',
                  selected: currentLanguage == 'es',
                  onTap: () {
                    ref
                        .read(localeProvider.notifier)
                        .changeLanguage('es');

                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _localizedLanguageName(
    BuildContext context,
    String languageCode,
    AppLocalizations l10n,
  ) {
    switch (languageCode) {
      case 'fr':
        return l10n.french;
      case 'ar':
        return l10n.arabic;
      case 'es':
        return l10n.spanish;
      case 'en':
      default:
        return l10n.english;
    }
  }
}

// =============================================================================
// PROFILE CARD
// =============================================================================

class _ProfileCard extends StatelessWidget {
  final String initial;
  final String? displayName;
  final String email;

  const _ProfileCard({
    required this.initial,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEEF0F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayName != null && displayName!.isNotEmpty)
                  Text(
                    displayName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                if (displayName != null && displayName!.isNotEmpty)
                  const SizedBox(height: 4),

                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 25,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// =============================================================================
// SETTINGS CARD
// =============================================================================

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEEF0F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.018),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: child,
      ),
    );
  }
}

// =============================================================================
// SETTINGS ROW
// =============================================================================

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final Color? subtitleColor;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      child: Row(
        children: [
          // Icon
          SizedBox(
            width: 42,
            child: Icon(
              icon,
              color: iconColor,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          subtitleColor ?? AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: content,
      ),
    );
  }
}

// =============================================================================
// DIVIDER
// =============================================================================

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 74,
      endIndent: 18,
      color: Color(0xFFE8EBED),
    );
  }
}

// =============================================================================
// SUPPORT CARD
// =============================================================================

class _SupportCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const _SupportCard({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFEEF0F2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.018),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.headset_mic_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// LANGUAGE OPTION
// =============================================================================

class _LanguageOption extends StatelessWidget {
  final String title;
  final String languageCode;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.languageCode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 13,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryLight
                      : const Color(0xFFF5F6F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  languageCode.toUpperCase(),
                  style: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),

              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DELETE ACCOUNT LOADING VIEW
// =============================================================================

class _DeletingAccountView extends StatelessWidget {
  final String message;

  const _DeletingAccountView({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(
                color: AppColors.danger,
                strokeWidth: 3,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}