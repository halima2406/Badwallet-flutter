import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Boutons d'actions rapides du dashboard : Transférer, Payer, Historique.
class QuickActions extends StatelessWidget {
  final VoidCallback onTransfer;
  final VoidCallback onPay;
  final VoidCallback onHistory;

  const QuickActions({
    super.key,
    required this.onTransfer,
    required this.onPay,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.send_rounded,
          label: 'Transférer',
          onTap: onTransfer,
        ),
        _ActionButton(
          icon: Icons.receipt_long_rounded,
          label: 'Payer',
          onTap: onPay,
        ),
        _ActionButton(
          icon: Icons.history_rounded,
          label: 'Historique',
          onTap: onHistory,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
