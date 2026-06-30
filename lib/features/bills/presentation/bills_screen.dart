import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/view_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/bills_provider.dart';
import 'bill_detail_screen.dart';

// ecran Payer : la liste des fournisseurs
class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final phone = context.read<AuthProvider>().phone;
    if (phone != null) context.read<BillsProvider>().load(phone);
  }

  @override
  Widget build(BuildContext context) {
    final bills = context.watch<BillsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Payer une facture')),
      body: _build(context, bills),
    );
  }

  Widget _build(BuildContext context, BillsProvider bills) {
    switch (bills.status) {
      case ViewStatus.idle:
      case ViewStatus.loading:
        return const LoadingView(message: 'Chargement des factures…');
      case ViewStatus.error:
        return ErrorView(message: bills.error ?? 'Erreur.', onRetry: _load);
      case ViewStatus.loaded:
        return RefreshIndicator(
          onRefresh: () async {
            final phone = context.read<AuthProvider>().phone;
            if (phone != null) await bills.load(phone);
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Choisis un fournisseur',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sélectionne ensuite les factures impayées à régler.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: kBillProviders.map((p) {
                  final count = bills.countFor(p.serviceName);
                  return _ProviderCard(
                    provider: p,
                    count: count,
                    onTap: () {
                      bills.clearSelection();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BillDetailScreen(provider: p),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
    }
  }
}

class _ProviderCard extends StatelessWidget {
  final BillProvider provider;
  final int count;
  final VoidCallback onTap;

  const _ProviderCard({
    required this.provider,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: provider.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(provider.icon, color: provider.color, size: 26),
                ),
                const Spacer(),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.debit,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              provider.label,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              count > 0 ? '$count facture(s) impayée(s)' : 'À jour',
              style: TextStyle(
                color: count > 0 ? AppColors.debit : AppColors.credit,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
