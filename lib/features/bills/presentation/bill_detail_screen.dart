import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/state/view_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/state_views.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/wallet_provider.dart';
import '../../../models/facture.dart';
import '../../../models/payment_receipt.dart';
import '../providers/bills_provider.dart';

class BillDetailScreen extends StatelessWidget {
  final BillProvider provider;
  const BillDetailScreen({super.key, required this.provider});

  Future<void> _pay(BuildContext context) async {
    final bills = context.read<BillsProvider>();
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Payer ${provider.label}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Factures sélectionnées',
                    style: TextStyle(color: AppColors.textSecondary)),
                Text('${bills.selectedCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total à payer',
                    style: TextStyle(color: AppColors.textSecondary)),
                Text(formatMoney(bills.selectedTotal),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Confirmer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final success = await bills.paySelected(auth.phone!, provider.serviceName);
    if (!context.mounted) return;

    if (success && bills.lastReceipt != null) {
      await context.read<WalletProvider>().refresh();
      if (!context.mounted) return;
      await _showReceipt(context, bills.lastReceipt!);
    } else {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.debit,
          content: Text(bills.payError ?? 'Échec du paiement.'),
        ),
      );
    }
  }

  Future<void> _showReceipt(BuildContext context, PaymentReceipt receipt) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.credit.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.credit, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Paiement réussi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _row('Montant payé', formatMoney(receipt.montantPaye)),
            _row('Factures réglées', '${receipt.nombreFactures}'),
            _row('Nouveau solde', formatMoney(receipt.soldeRestant)),
            if (receipt.referenceTransaction != null)
              _row('Référence', receipt.referenceTransaction!),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Terminer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bills = context.watch<BillsProvider>();
    final factures = bills.facturesFor(provider.serviceName);
    final paying = bills.payStatus.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(provider.label)),
      body: factures.isEmpty
          ? const EmptyView(
              icon: Icons.check_circle_outline_rounded,
              message: 'Aucune facture impayée pour ce fournisseur.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: factures.length,
              itemBuilder: (_, i) {
                final f = factures[i];
                return _FactureTile(
                  facture: f,
                  selected: bills.isSelected(f.reference),
                  onChanged: () => bills.toggle(f.reference),
                );
              },
            ),
      bottomNavigationBar: (factures.isNotEmpty && bills.selectedCount > 0)
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        Text(formatMoney(bills.selectedTotal),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: paying ? null : () => _pay(context),
                        child: paying
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text('Payer (${bills.selectedCount})'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _FactureTile extends StatelessWidget {
  final Facture facture;
  final bool selected;
  final VoidCallback onChanged;

  const _FactureTile({
    required this.facture,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: selected,
              onChanged: (_) => onChanged(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facture.libelle ?? facture.reference,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${facture.reference} • échéance ${formatDate(facture.dateEcheance)}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatMoney(facture.montant),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
