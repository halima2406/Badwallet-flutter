import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/view_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/transaction_tile.dart';
import '../../../models/transaction.dart';
import '../../dashboard/providers/wallet_provider.dart';

enum _Filter { tout, entrees, sorties }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _Filter _filter = _Filter.tout;

  List<TransactionModel> _apply(List<TransactionModel> all) {
    switch (_filter) {
      case _Filter.tout:
        return all;
      case _Filter.entrees:
        return all.where((t) => t.isCredit).toList();
      case _Filter.sorties:
        return all.where((t) => !t.isCredit).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        automaticallyImplyLeading: Navigator.canPop(context),
      ),
      body: _build(context, wallet),
    );
  }

  Widget _build(BuildContext context, WalletProvider wallet) {
    switch (wallet.status) {
      case ViewStatus.idle:
      case ViewStatus.loading:
        return const LoadingView();
      case ViewStatus.error:
        return ErrorView(
          message: wallet.error ?? 'Erreur.',
          onRetry: wallet.refresh,
        );
      case ViewStatus.loaded:
        final list = _apply(wallet.transactions);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  _chip('Tout', _Filter.tout),
                  const SizedBox(width: 8),
                  _chip('Entrées', _Filter.entrees),
                  const SizedBox(width: 8),
                  _chip('Sorties', _Filter.sorties),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const EmptyView(
                      icon: Icons.inbox_rounded,
                      message: 'Aucune transaction.',
                    )
                  : RefreshIndicator(
                      onRefresh: wallet.refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: list.length,
                        itemBuilder: (_, i) =>
                            TransactionTile(tx: list[i]),
                      ),
                    ),
            ),
          ],
        );
    }
  }

  Widget _chip(String label, _Filter value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
