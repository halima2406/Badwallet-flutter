import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/state/view_status.dart';
import '../../../models/facture.dart';
import '../../../models/payment_receipt.dart';
import '../../dashboard/data/wallet_service.dart';
import '../data/bills_service.dart';

/// Provider des factures : chargement, sélection multiple, paiement en lot.
class BillsProvider extends ChangeNotifier {
  final BillsService _billsService;
  final WalletService _walletService;
  BillsProvider(this._billsService, this._walletService);

  ViewStatus status = ViewStatus.idle;
  String? error;

  String? _walletCode;
  List<Facture> _all = [];

  /// Références sélectionnées (checkboxes).
  final Set<String> _selected = {};

  ViewStatus payStatus = ViewStatus.idle;
  String? payError;
  PaymentReceipt? lastReceipt;

  /// Factures impayées d'un fournisseur donné.
  List<Facture> facturesFor(String serviceName) =>
      _all.where((f) => f.serviceName == serviceName && f.isUnpaid).toList();

  /// Nombre total de factures impayées d'un fournisseur.
  int countFor(String serviceName) => facturesFor(serviceName).length;

  bool isSelected(String reference) => _selected.contains(reference);

  int get selectedCount => _selected.length;

  double get selectedTotal => _all
      .where((f) => _selected.contains(f.reference))
      .fold(0.0, (sum, f) => sum + f.montant);

  /// Charge toutes les factures impayées du mois (via le code portefeuille).
  Future<void> load(String phone) async {
    status = ViewStatus.loading;
    error = null;
    _selected.clear();
    notifyListeners();
    try {
      final w = await _walletService.getWallet(phone);
      _walletCode = w.code;
      _all = await _billsService.getCurrentFactures(w.code);
      status = ViewStatus.loaded;
    } on ApiException catch (e) {
      error = e.message;
      status = ViewStatus.error;
    } catch (e) {
      error = e.toString();
      status = ViewStatus.error;
    }
    notifyListeners();
  }

  void toggle(String reference) {
    if (_selected.contains(reference)) {
      _selected.remove(reference);
    } else {
      _selected.add(reference);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  /// Paie les factures sélectionnées du fournisseur [serviceName].
  Future<bool> paySelected(String phone, String serviceName) async {
    final refs = _all
        .where((f) =>
            _selected.contains(f.reference) && f.serviceName == serviceName)
        .map((f) => f.reference)
        .toList();
    if (refs.isEmpty) return false;

    payStatus = ViewStatus.loading;
    payError = null;
    notifyListeners();
    try {
      lastReceipt = await _billsService.payFactures(
        phoneNumber: phone,
        serviceName: serviceName,
        references: refs,
      );
      // Recharge les factures restantes.
      if (_walletCode != null) {
        _all = await _billsService.getCurrentFactures(_walletCode!);
      }
      _selected.clear();
      payStatus = ViewStatus.loaded;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      payError = e.message;
      payStatus = ViewStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      payError = e.toString();
      payStatus = ViewStatus.error;
      notifyListeners();
      return false;
    }
  }

  void resetPay() {
    payStatus = ViewStatus.idle;
    payError = null;
    lastReceipt = null;
  }
}
