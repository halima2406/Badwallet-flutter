import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/view_status.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../core/widgets/transaction_tile.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bills/presentation/bills_screen.dart';
import '../../history/presentation/history_screen.dart';
import '../../transfers/presentation/transfer_screen.dart';
import '../providers/wallet_provider.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_actions.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 18,
              child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Bonjour 👋',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text(
                  auth.phone ?? '',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildBody(context, wallet),
    );
  }

  Widget _buildBody(BuildContext context, WalletProvider wallet) {
    switch (wallet.status) {
      case ViewStatus.loading:
      case ViewStatus.idle:
        return const LoadingView(message: 'Chargement de votre portefeuille…');
      case ViewStatus.error:
        return ErrorView(
          message: wallet.error ?? 'Une erreur est survenue.',
          onRetry: wallet.refresh,
        );
      case ViewStatus.loaded:
        return RefreshIndicator(
          onRefresh: wallet.refresh,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              BalanceCard(
                balance: wallet.balance?.balance ?? 0,
                currency: wallet.currency,
                phone: wallet.balance?.phoneNumber ?? '',
                hidden: wallet.hideBalance,
                onToggle: wallet.toggleHideBalance,
              ),
              const SizedBox(height: 20),
              QuickActions(
                onTransfer: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const TransferScreen()),
                  );
                  await wallet.refresh();
                },
                onPay: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BillsScreen()),
                ),
                onHistory: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  const Text(
                    'Transactions récentes',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HistoryScreen()),
                    ),
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (wallet.recentTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: EmptyView(
                    icon: Icons.inbox_rounded,
                    message: 'Aucune transaction pour le moment.',
                  ),
                )
              else
                ...wallet.recentTransactions
                    .map((tx) => TransactionTile(tx: tx)),
            ],
          ),
        );
    }
  }
}
