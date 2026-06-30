import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';

// une ligne de transaction (vert = entree, rouge = sortie, gris = echouée)
class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const TransactionTile({super.key, required this.tx});

  IconData get _icon {
    switch (tx.type) {
      case 'DEPOT':
        return Icons.south_west_rounded;
      case 'RETRAIT':
        return Icons.north_east_rounded;
      case 'TRANSFERT_ENVOYE':
        return Icons.arrow_outward_rounded;
      case 'TRANSFERT_RECU':
        return Icons.call_received_rounded;
      case 'PAIEMENT_FACTURE':
        return Icons.receipt_long_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = tx.isFailed
        ? AppColors.textSecondary
        : (tx.isCredit ? AppColors.credit : AppColors.debit);
    final sign = tx.isCredit ? '+' : '-';

    final subtitleParts = <String>[];
    if (tx.contrepartie != null && tx.contrepartie!.isNotEmpty) {
      subtitleParts.add(tx.contrepartie!);
    }
    subtitleParts.add(formatDateTime(tx.createdAt));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.typeLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitleParts.join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign${formatAmount(tx.montant)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  decoration:
                      tx.isFailed ? TextDecoration.lineThrough : null,
                ),
              ),
              if (tx.isFailed)
                const Text('Échouée',
                    style: TextStyle(
                        color: AppColors.debit, fontSize: 11))
              else if (tx.frais > 0)
                Text('frais ${formatAmount(tx.frais)}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
