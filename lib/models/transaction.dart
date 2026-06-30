import '../core/utils/formatters.dart';

class TransactionModel {
  final String reference;
  final String type;
  final double montant;
  final double frais;
  final String? paymentMethod;
  final String statut;
  final String? contrepartie;
  final String? description;
  final DateTime? createdAt;

  TransactionModel({
    required this.reference,
    required this.type,
    required this.montant,
    required this.frais,
    this.paymentMethod,
    required this.statut,
    this.contrepartie,
    this.description,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      reference: json['reference']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      montant: toDoubleSafe(json['montant']),
      frais: toDoubleSafe(json['frais']),
      paymentMethod: json['paymentMethod']?.toString(),
      statut: json['statut']?.toString() ?? '',
      contrepartie: json['contrepartie']?.toString(),
      description: json['description']?.toString(),
      createdAt: parseDate(json['createdAt']),
    );
  }

  bool get isCredit => type == 'DEPOT' || type == 'TRANSFERT_RECU';

  bool get isFailed => statut == 'ECHOUEE';

  String get typeLabel {
    switch (type) {
      case 'DEPOT':
        return 'Dépôt';
      case 'RETRAIT':
        return 'Retrait';
      case 'TRANSFERT_ENVOYE':
        return 'Transfert envoyé';
      case 'TRANSFERT_RECU':
        return 'Transfert reçu';
      case 'PAIEMENT_FACTURE':
        return 'Paiement facture';
      default:
        return type;
    }
  }
}
