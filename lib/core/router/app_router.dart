import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/pin_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/bills/presentation/bill_detail_screen.dart';
import '../../features/bills/presentation/bills_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/main_shell/main_shell.dart';
import '../../features/transfers/presentation/transfer_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String pinSetup = '/pin-setup';
  static const String pinLock = '/pin-lock';
  static const String home = '/home';
  static const String transfer = '/transfer';
  static const String bills = '/bills';
  static const String billDetail = '/bill-detail';
  static const String history = '/history';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _route(const SplashScreen(), settings);
      case login:
        return _route(const LoginScreen(), settings);
      case pinSetup:
        return _route(const PinScreen(setup: true), settings);
      case pinLock:
        return _route(const PinScreen(setup: false), settings);
      case home:
        return _route(const MainShell(), settings);
      case transfer:
        return _route(const TransferScreen(), settings);
      case bills:
        return _route(const BillsScreen(), settings);
      case history:
        return _route(const HistoryScreen(), settings);
      case billDetail:
        final provider = settings.arguments as BillProvider;
        return _route(BillDetailScreen(provider: provider), settings);
      default:
        return _route(const SplashScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _route(Widget page, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
