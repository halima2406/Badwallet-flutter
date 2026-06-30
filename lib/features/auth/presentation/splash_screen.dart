import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();
    await Future.wait([
      auth.loadSession(),
      Future.delayed(const Duration(milliseconds: 1600)),
    ]);
    if (!mounted) return;
    final String target;
    if (!auth.isLoggedIn) {
      target = AppRouter.login;
    } else if (auth.hasPin) {
      target = AppRouter.pinLock;
    } else {
      target = AppRouter.pinSetup;
    }
    Navigator.of(context).pushReplacementNamed(target);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.buttonGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: AppColors.onAccent,
                size: 52,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'BadWallet',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'XOF · DAKAR',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
