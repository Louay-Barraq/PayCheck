// widgets/status_badge.dart
import 'package:flutter/material.dart';
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

  factory StatusBadge.overdue() => const StatusBadge(
      label: 'En retard', fg: AppColors.danger, bg: AppColors.dangerLight, icon: Icons.warning_rounded);
  factory StatusBadge.upToDate() => const StatusBadge(
      label: 'À jour', fg: AppColors.success, bg: AppColors.successLight, icon: Icons.check_circle_rounded);
  factory StatusBadge.quittancePending() => const StatusBadge(
      label: 'Quittance en attente', fg: AppColors.warning, bg: AppColors.warningLight, icon: Icons.receipt_rounded);

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