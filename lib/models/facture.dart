import '../core/utils/formatters.dart';

class Facture {
  final String reference;
  final String walletCode;
  final String serviceName;
  final String? unite;
  final String? libelle;
  final double montant;
  final DateTime? periode;
  final DateTime? dateEcheance;
  final String statut;

  Facture({
    required this.reference,
    required this.walletCode,
    required this.serviceName,
    this.unite,
    this.libelle,
    required this.montant,
    this.periode,
    this.dateEcheance,
    required this.statut,
  });

  factory Facture.fromJson(Map<String, dynamic> json) {
    return Facture(
      reference: json['reference']?.toString() ?? '',
      walletCode: json['walletCode']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      unite: json['unite']?.toString(),
      libelle: json['libelle']?.toString(),
      montant: toDoubleSafe(json['montant']),
      periode: parseDate(json['periode']),
      dateEcheance: parseDate(json['dateEcheance']),
      statut: json['statut']?.toString() ?? 'IMPAYEE',
    );
  }

  bool get isUnpaid => statut == 'IMPAYEE';
}
