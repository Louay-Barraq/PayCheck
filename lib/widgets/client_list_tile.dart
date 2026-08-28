// widgets/client_list_tile.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/client.dart';
import '../theme/app_theme.dart';
import 'status_badge.dart';

class ClientListTile extends StatelessWidget {
  final Client client;
  final bool isOverdue;
  final bool hasPendingQuittance;
  final VoidCallback onTap;

  const ClientListTile({
    super.key,
    required this.client,
    required this.isOverdue,
    this.hasPendingQuittance = false,
    required this.onTap,
  });

  String get _initials {
    final parts = client.fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return client.fullName.isNotEmpty ? client.fullName[0].toUpperCase() : '?';
  }

  Widget _buildStatusBadge(AppLocalizations l10n) {
    if (!client.isActive) return StatusBadge.inactive(l10n);
    if (isOverdue) return StatusBadge.overdue(l10n);
    if (hasPendingQuittance) return StatusBadge.quittancePending(l10n);
    return StatusBadge.upToDate(l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isOverdue ? AppColors.dangerLight : AppColors.primaryLight,
                  child: Text(
                    _initials,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isOverdue ? AppColors.danger : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.fullName, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 3),
                      Text('N° ${client.contractNumber} · ${client.paymentPeriod.localizedLabel(context)}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      _buildStatusBadge(l10n),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}