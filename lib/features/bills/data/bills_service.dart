import '../../../core/network/api_client.dart';
import '../../../models/facture.dart';
import '../../../models/payment_receipt.dart';

// appelle l'API pour les factures
class BillsService {
  final ApiClient _api;
  BillsService(this._api);

  // recupere les factures impayees du mois
  Future<List<Facture>> getCurrentFactures(String walletCode,
      {String? unite}) async {
    final data = await _api.get(
      '/api/external/factures/$walletCode/current',
      query: unite != null ? {'unite': unite} : null,
    );
    final list = (data as List?) ?? const [];
    return list.map((e) => Facture.fromJson(e as Map<String, dynamic>)).toList();
  }

  // paie une liste de factures
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
