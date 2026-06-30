import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../auth/providers/auth_provider.dart';
import '../bills/presentation/bills_screen.dart';
import '../dashboard/presentation/dashboard_screen.dart';
import '../dashboard/providers/wallet_provider.dart';
import '../history/presentation/history_screen.dart';
import '../profile/presentation/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [
    DashboardScreen(key: PageStorageKey('tab_dashboard')),
    HistoryScreen(key: PageStorageKey('tab_history')),
    BillsScreen(key: PageStorageKey('tab_bills')),
    ProfileScreen(key: PageStorageKey('tab_profile')),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final phone = context.read<AuthProvider>().phone;
      if (phone != null) {
        context.read<WalletProvider>().load(phone);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon:
                Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon:
                Icon(Icons.payments_rounded, color: AppColors.primary),
            label: 'Payer',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
