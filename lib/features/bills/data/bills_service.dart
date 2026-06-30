import '../../../core/network/api_client.dart';
import '../../../models/facture.dart';
import '../../../models/payment_receipt.dart';

/// Service de paiement de factures (proxy vers le Payment Service).
class BillsService {
  final ApiClient _api;
  BillsService(this._api);

  /// GET /api/external/factures/{code}/current?unite=...
  /// Factures impayées du mois en cours pour un code portefeuille.
  Future<List<Facture>> getCurrentFactures(String walletCode,
      {String? unite}) async {
    final data = await _api.get(
      '/api/external/factures/$walletCode/current',
      query: unite != null ? {'unite': unite} : null,
    );
    final list = (data as List?) ?? const [];
    return list.map((e) => Facture.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// POST /api/wallets/pay-factures
  /// body: { phoneNumber, serviceName, factureReferences }
  Future<PaymentReceipt> payFactures({
    required String phoneNumber,
    required String serviceName,
    required List<String> references,
  }) async {
    final data = await _api.post('/api/wallets/pay-factures', body: {
      'phoneNumber': phoneNumber,
      'serviceName': serviceName,
      'factureReferences': references,
    });
    return PaymentReceipt.fromJson(data as Map<String, dynamic>);
  }
}
