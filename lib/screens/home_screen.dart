import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment.dart';
import '../providers/client_providers.dart';
import '../providers/payment_providers.dart';
import '../theme/app_theme.dart';
import '../utils/payment_utils.dart';
import '../widgets/client_list_tile.dart';
import '../widgets/empty_state.dart';
import '../widgets/sync_status_icon.dart';
import 'add_client_screen.dart';
import 'client_detail_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsProvider);
    final allPaymentsAsync = ref.watch(allPaymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PayCheck'),
        actions: const [
          SyncStatusIcon(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un client...',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _query = v.toLowerCase()),
              ),
            ),
          ),
          Expanded(
            child: clientsAsync.when(
              data: (clients) {
                final filtered = _query.isEmpty
                    ? clients
                    : clients
                          .where(
                            (c) =>
                                c.fullName.toLowerCase().contains(_query) ||
                                c.contractNumber.toLowerCase().contains(_query),
                          )
                          .toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.people_outline,
                    message: 'Aucun client trouvé',
                  );
                }

                final paymentsByClient = <String, List<Payment>>{};
                for (final p in allPaymentsAsync.value ?? []) {
                  paymentsByClient.putIfAbsent(p.clientId, () => []).add(p);
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final client = filtered[i];
                    final clientPayments = paymentsByClient[client.id] ?? [];
                    final hasPendingQuittance = clientPayments.any((p) => !p.quittanceGiven);

                    return ClientListTile(
                      client: client,
                      isOverdue: isOverdue(
                        client,
                        clientPayments,
                      ),
                      hasPendingQuittance: hasPendingQuittance,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClientDetailScreen(client: client),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddClientScreen()),
        ),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
