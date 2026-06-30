import '../core/utils/formatters.dart';

// le solde du portefeuille
class Balance {
  final String phoneNumber;
  final double balance;
  final String currency;

  Balance({
    required this.phoneNumber,
    required this.balance,
    required this.currency,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      balance: toDoubleSafe(json['balance']),
      currency: json['currency']?.toString() ?? 'XOF',
    );
  }
}
