import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/session_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/bills/data/bills_service.dart';
import 'features/bills/providers/bills_provider.dart';
import 'features/dashboard/data/wallet_service.dart';
import 'features/dashboard/providers/wallet_provider.dart';
import 'features/transfers/data/transfer_service.dart';
import 'features/transfers/providers/transfer_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const BadWalletApp());
}

class BadWalletApp extends StatelessWidget {
  const BadWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient.instance;
    final walletService = WalletService(api);
    final transferService = TransferService(api);
    final billsService = BillsService(api);
    final sessionService = SessionService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(sessionService)),
        ChangeNotifierProvider(create: (_) => WalletProvider(walletService)),
        ChangeNotifierProvider(
            create: (_) => TransferProvider(transferService)),
        ChangeNotifierProvider(
            create: (_) => BillsProvider(billsService, walletService)),
      ],
      child: MaterialApp(
        title: 'BadWallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRouter.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
