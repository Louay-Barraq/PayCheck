// widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.fg,
    required this.bg,
    this.icon,
  });

  factory StatusBadge.overdue(AppLocalizations l10n) => StatusBadge(
      label: l10n.overdue, fg: AppColors.danger, bg: AppColors.dangerLight, icon: Icons.warning_rounded);
  factory StatusBadge.upToDate(AppLocalizations l10n) => StatusBadge(
      label: l10n.upToDate, fg: AppColors.success, bg: AppColors.successLight, icon: Icons.check_circle_rounded);
  factory StatusBadge.quittancePending(AppLocalizations l10n) => StatusBadge(
      label: l10n.quittancePending, fg: AppColors.warning, bg: AppColors.warningLight, icon: Icons.receipt_rounded);
  factory StatusBadge.inactive(AppLocalizations l10n) => StatusBadge(
      label: l10n.inactive, fg: Colors.grey, bg: Colors.grey.shade200);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 4)],
          Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}