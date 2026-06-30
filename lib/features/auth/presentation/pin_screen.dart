import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../transfers/presentation/widgets/numeric_keypad.dart';
import '../providers/auth_provider.dart';

class PinScreen extends StatefulWidget {
  final bool setup;
  const PinScreen({super.key, required this.setup});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  static const int _length = 4;

  String _entered = '';
  String? _firstPin;
  String? _error;

  bool get _confirming => _firstPin != null;

  String get _title {
    if (!widget.setup) return 'Entre ton code PIN';
    return _confirming ? 'Confirme ton code PIN' : 'Crée ton code PIN';
  }

  String get _subtitle {
    if (!widget.setup) return 'Pour accéder à ton portefeuille';
    return _confirming
        ? 'Saisis à nouveau les 4 chiffres'
        : 'Choisis un code à 4 chiffres';
  }

  void _onDigit(String d) {
    if (_entered.length >= _length) return;
    setState(() {
      _error = null;
      _entered += d;
    });
    if (_entered.length == _length) {
      Future.delayed(const Duration(milliseconds: 120), _validate);
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() {
      _error = null;
      _entered = _entered.substring(0, _entered.length - 1);
    });
  }

  Future<void> _validate() async {
    final auth = context.read<AuthProvider>();

    if (widget.setup) {
      if (!_confirming) {
        setState(() {
          _firstPin = _entered;
          _entered = '';
        });
        return;
      }
      if (_entered == _firstPin) {
        await auth.setPin(_entered);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRouter.home);
      } else {
        setState(() {
          _error = 'Les codes ne correspondent pas';
          _entered = '';
          _firstPin = null;
        });
      }
    } else {
      if (auth.checkPin(_entered)) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(AppRouter.home);
      } else {
        setState(() {
          _error = 'Code incorrect';
          _entered = '';
        });
      }
    }
  }

  Future<void> _logout() async {
    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    await auth.logout();
    navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_rounded,
                    color: AppColors.primaryBright, size: 32),
              ),
              const SizedBox(height: 24),
              Text(
                _title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                _subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_length, (i) {
                  final filled = i < _entered.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: _error != null
                            ? AppColors.danger
                            : (filled
                                ? AppColors.primary
                                : AppColors.inputBorder),
                        width: 1.6,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 20,
                child: Text(
                  _error ?? '',
                  style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              NumericKeypad(onDigit: _onDigit, onBackspace: _onBackspace),
              const SizedBox(height: 8),
              if (!widget.setup)
                TextButton(
                  onPressed: _logout,
                  child: const Text('Changer de compte'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
