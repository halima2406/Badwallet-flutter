import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/state/view_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/wallet_provider.dart';
import '../providers/transfer_provider.dart';
import 'widgets/numeric_keypad.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _receiverController = TextEditingController(text: '+221770000002');
  String _amount = '';

  @override
  void dispose() {
    _receiverController.dispose();
    super.dispose();
  }

  void _onDigit(String d) {
    setState(() {
      if (_amount == '0') _amount = '';
      if ((_amount + d).length <= 12) _amount += d;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  double get _amountValue => double.tryParse(_amount) ?? 0;

  Future<void> _confirm() async {
    final receiver = _receiverController.text.trim();
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);

    if (receiver.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Saisis le numéro du destinataire.')),
      );
      return;
    }
    if (_amountValue <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Saisis un montant valide.')),
      );
      return;
    }

    final ok = await _showConfirmSheet(receiver);
    if (ok != true) return;
    if (!mounted) return;

    final transfer = context.read<TransferProvider>();
    final success = await transfer.transfer(
      senderPhone: auth.phone!,
      receiverPhone: receiver,
      amount: _amountValue,
    );

    if (!mounted) return;
    if (success) {
      await context.read<WalletProvider>().refresh();
      if (!mounted) return;
      await _showSuccessSheet(receiver);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } else {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.debit,
          content: Text(transfer.error ?? 'Échec du transfert.'),
        ),
      );
    }
  }

  Future<bool?> _showConfirmSheet(String receiver) {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirmer le transfert',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            _confirmRow('Destinataire', receiver),
            const SizedBox(height: 10),
            _confirmRow('Montant', formatMoney(_amountValue)),
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
  }

  Widget _confirmRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Future<void> _showSuccessSheet(String receiver) {
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
            const Text('Transfert réussi',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              '${formatMoney(_amountValue)} envoyés à $receiver',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
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

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<TransferProvider>().status.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Transférer')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _receiverController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Numéro du destinataire',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Montant',
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _amount.isEmpty ? '0' : formatAmount(_amountValue),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('XOF',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const Spacer(),
              NumericKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loading ? null : _confirm,
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Valider le transfert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
