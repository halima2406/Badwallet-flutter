import '../core/utils/formatters.dart';

/// Reçu de paiement (POST /api/wallets/pay-factures et /pay).
class PaymentReceipt {
  final String phoneNumber;
  final String serviceName;
  final double montantPaye;
  final double soldeRestant;
  final int nombreFactures;
  final List<String> referencesPayees;
  final String? referenceTransaction;
  final DateTime? datePaiement;

  PaymentReceipt({
    required this.phoneNumber,
    required this.serviceName,
    required this.montantPaye,
    required this.soldeRestant,
    required this.nombreFactures,
    required this.referencesPayees,
    this.referenceTransaction,
    this.datePaiement,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    return PaymentReceipt(
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      montantPaye: toDoubleSafe(json['montantPaye']),
      soldeRestant: toDoubleSafe(json['soldeRestant']),
      nombreFactures: json['nombreFactures'] is int
          ? json['nombreFactures'] as int
          : int.tryParse('${json['nombreFactures']}') ?? 0,
      referencesPayees: (json['referencesPayees'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      referenceTransaction: json['referenceTransaction']?.toString(),
      datePaiement: parseDate(json['datePaiement']),
    );
  }
}
