// screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/countries.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

// ─── Total page count ────────────────────────────────────────────
const _kPageCount = 7;

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  // User choices
  String? _profession;
  String? _ageRange;
  CountryData _country = kCountries.first; // defaults to Tunisia
  String _countrySearch = '';
  bool _notifGranted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _kPageCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goBack() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    // Save global onboarding flag so it doesn't show again
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
    } catch (_) {}

    // Invalidate provider so AuthGate updates state
    ref.invalidate(onboardingCompleteProvider);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen(key: ValueKey('login'))),
        (_) => false,
      );
    }
  }

  Future<void> _requestNotifications() async {
    final l10n = AppLocalizations.of(context)!;
    final texts = NotificationTexts(
      enabledTitle: l10n.notifEnabledTitle,
      enabledBody: l10n.notifEnabledBody,
      overdueTitle: l10n.notifOverdueTitle,
      overdueBody: (clientName, amount, currency, contractNumber) =>
          l10n.notifOverdueBody(clientName, amount, currency, contractNumber),
      dueSoonTitle: l10n.notifDueSoonTitle,
      dueTodayMsg: l10n.notifDueTodayMsg,
      dueInDaysMsg: (days) => l10n.notifDueInDaysMsg(days),
      dueSoonBody: (clientName, dueMsg, amount, currency) =>
          l10n.notifDueSoonBody(clientName, dueMsg, amount, currency),
    );
    final granted = await ref.read(notificationServiceProvider).requestPermissions(texts: texts);
    if (!mounted) return;
    setState(() => _notifGranted = granted);
  }

  // ─── Progress indicator ─────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: List.generate(_kPageCount, (i) {
          final isActive = i <= _currentPage;
          final isCurrent = i == _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: isCurrent ? 6 : 4,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar with progress + language/back + skip ─────
            Row(
              children: [
                if (_currentPage > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                    onPressed: _goBack,
                  )
                else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.language_rounded, size: 22, color: AppColors.primary),
                    tooltip: l10n.language,
                    onSelected: (code) {
                      ref.read(localeProvider.notifier).changeLanguage(code);
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(value: 'en', child: Text('${l10n.english} ${currentLocale.languageCode == 'en' ? '✓' : ''}')),
                      PopupMenuItem(value: 'fr', child: Text('${l10n.french} ${currentLocale.languageCode == 'fr' ? '✓' : ''}')),
                      PopupMenuItem(value: 'ar', child: Text('${l10n.arabic} ${currentLocale.languageCode == 'ar' ? '✓' : ''}')),
                      PopupMenuItem(value: 'es', child: Text('${l10n.spanish} ${currentLocale.languageCode == 'es' ? '✓' : ''}')),
                    ],
                  ),
                Expanded(child: _buildProgressBar()),
                if (_currentPage < 3) // only on feature pages
                  TextButton(
                    onPressed: _finish,
                    child: Text(
                      l10n.onbSkip,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  const SizedBox(width: 48),
              ],
            ),

            // ── Pages ─────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _FeaturePage(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A6B5C), Color(0xFF2BA68C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.people_rounded,
                    title: l10n.feat1Title,
                    desc: l10n.feat1Desc,
                    onNext: _goNext,
                    nextLabel: l10n.onbNext,
                  ),
                  _FeaturePage(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2356C8), Color(0xFF5B8CFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.payments_rounded,
                    title: l10n.feat2Title,
                    desc: l10n.feat2Desc,
                    onNext: _goNext,
                    nextLabel: l10n.onbNext,
                  ),
                  _FeaturePage(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB85A00), Color(0xFFE88B34)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    icon: Icons.dashboard_rounded,
                    title: l10n.feat3Title,
                    desc: l10n.feat3Desc,
                    onNext: _goNext,
                    nextLabel: l10n.onbGetStarted,
                  ),
                  // ── Profession ────────────────────────────────
                  _SelectionPage(
                    icon: Icons.work_outline_rounded,
                    title: l10n.onbProfessionTitle,
                    subtitle: l10n.onbProfessionSubtitle,
                    options: [
                      l10n.profRealEstate,
                      l10n.profPropertyManager,
                      l10n.profAccountant,
                      l10n.profContractor,
                      l10n.profFreelancer,
                      l10n.profBusinessOwner,
                      l10n.profOther,
                    ],
                    selected: _profession,
                    onSelect: (v) => setState(() => _profession = v),
                    onNext: _profession != null ? _goNext : null,
                    nextLabel: l10n.onbNext,
                  ),
                  // ── Age ───────────────────────────────────────
                  _SelectionPage(
                    icon: Icons.cake_outlined,
                    title: l10n.onbAgeTitle,
                    subtitle: l10n.onbAgeSubtitle,
                    options: [
                      l10n.ageUnder25,
                      l10n.age25_34,
                      l10n.age35_44,
                      l10n.age45_54,
                      l10n.age55Plus,
                    ],
                    selected: _ageRange,
                    onSelect: (v) => setState(() => _ageRange = v),
                    onNext: _ageRange != null ? _goNext : null,
                    nextLabel: l10n.onbNext,
                  ),
                  // ── Country ───────────────────────────────────
                  _CountryPage(
                    selected: _country,
                    search: _countrySearch,
                    onSearch: (v) => setState(() => _countrySearch = v),
                    onSelect: (c) => setState(() => _country = c),
                    onNext: _goNext,
                    nextLabel: l10n.onbNext,
                    searchHint: l10n.onbCountrySearch,
                    title: l10n.onbCountryTitle,
                    subtitle: l10n.onbCountrySubtitle,
                  ),
                  // ── Notifications ─────────────────────────────
                  _NotifPage(
                    granted: _notifGranted,
                    onRequest: _requestNotifications,
                    onFinish: _finish,
                    title: l10n.onbNotifTitle,
                    subtitle: l10n.onbNotifSubtitle,
                    enableLabel: l10n.onbNotifEnable,
                    skipLabel: l10n.onbNotifSkip,
                    grantedLabel: l10n.onbNotifGranted,
                    finishLabel: l10n.onbFinish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Feature Page
// ─────────────────────────────────────────────────────────────────

class _FeaturePage extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String title;
  final String desc;
  final VoidCallback onNext;
  final String nextLabel;

  const _FeaturePage({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Illustration area ──────────────────────────────────
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 52, color: Colors.white),
                ),
                const SizedBox(height: 24),
                // Decorative dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: i == 1 ? 12 : 8,
                      height: i == 1 ? 12 : 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: i == 1 ? 0.9 : 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Text + CTA ────────────────────────────────────────
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onNext,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      nextLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Selection Page (profession / age)
// ─────────────────────────────────────────────────────────────────

class _SelectionPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;
  final String nextLabel;

  const _SelectionPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Options grid
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final opt = options[i];
                final isSelected = opt == selected;
                return GestureDetector(
                  onTap: () => onSelect(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          opt,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                nextLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Country Page
// ─────────────────────────────────────────────────────────────────

class _CountryPage extends StatelessWidget {
  final CountryData selected;
  final String search;
  final ValueChanged<String> onSearch;
  final ValueChanged<CountryData> onSelect;
  final VoidCallback onNext;
  final String nextLabel;
  final String searchHint;
  final String title;
  final String subtitle;

  const _CountryPage({
    required this.selected,
    required this.search,
    required this.onSearch,
    required this.onSelect,
    required this.onNext,
    required this.nextLabel,
    required this.searchHint,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = kCountries
        .where((c) =>
            c.name.toLowerCase().contains(search.toLowerCase()) ||
            c.currencyCode.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.public_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Selected currency chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selected.flag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    Text(
                      '${selected.currencyCode}  ·  ${selected.currencySymbol}  —  ${selected.currencyName}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Search field
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: searchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 10),

          // Country list
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final c = filtered[i];
                final isSelected = c.code == selected.code;
                return ListTile(
                  onTap: () => onSelect(c),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  leading: Text(c.flag, style: const TextStyle(fontSize: 28)),
                  title: Text(
                    c.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    '${c.currencyCode}  ·  ${c.currencySymbol}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: isSelected ? AppColors.primaryLight : null,
                );
              },
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                nextLabel,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Notification Permission Page
// ─────────────────────────────────────────────────────────────────

class _NotifPage extends StatelessWidget {
  final bool granted;
  final VoidCallback onRequest;
  final VoidCallback onFinish;
  final String title;
  final String subtitle;
  final String enableLabel;
  final String skipLabel;
  final String grantedLabel;
  final String finishLabel;

  const _NotifPage({
    required this.granted,
    required this.onRequest,
    required this.onFinish,
    required this.title,
    required this.subtitle,
    required this.enableLabel,
    required this.skipLabel,
    required this.grantedLabel,
    required this.finishLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bell illustration
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A6B5C), Color(0xFF2BA68C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 14),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                ),
                if (granted) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2EF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          grantedLabel,
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // CTA buttons
          Column(
            children: [
              if (!granted)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onRequest,
                    icon: const Icon(Icons.notifications_outlined),
                    label: Text(
                      enableLabel,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: granted
                    ? FilledButton(
                        onPressed: onFinish,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          finishLabel,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      )
                    : TextButton(
                        onPressed: onFinish,
                        child: Text(
                          skipLabel,
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
