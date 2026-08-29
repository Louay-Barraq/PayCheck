import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
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

  Future<void> _handleRefresh() async {
    ref.invalidate(clientsProvider);
    ref.invalidate(allPaymentsProvider);

    // Wait for the fresh data to resolve before dismissing the indicator spinner
    await Future.wait([
      ref.read(clientsProvider.future),
      ref.read(allPaymentsProvider.future),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final clientsAsync = ref.watch(clientsProvider);
    final allPaymentsAsync = ref.watch(allPaymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [SyncStatusIcon()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.search,
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
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: clientsAsync.when(
                data: (clients) {
                  final filtered = _query.isEmpty
                      ? clients
                      : clients
                            .where(
                              (c) =>
                                  c.fullName.toLowerCase().contains(_query) ||
                                  c.contractNumber.toLowerCase().contains(
                                    _query,
                                  ),
                            )
                            .toList();

                  if (filtered.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: EmptyState(
                            icon: Icons.people_outline,
                            message: l10n.noClients,
                          ),
                        ),
                      ],
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
                      final hasPendingQuittance = clientPayments.any(
                        (p) => !p.quittanceGiven,
                      );

                      return ClientListTile(
                        client: client,
                        isOverdue: isOverdue(client, clientPayments),
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
                error: (e, _) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Text('${l10n.error}: $e'),
                  ),
                ),
              ),
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
