import '../core/utils/formatters.dart';

class Wallet {
  final int? id;
  final String phoneNumber;
  final String? email;
  final String code;
  final double balance;
  final String currency;
  final DateTime? createdAt;

  Wallet({
    this.id,
    required this.phoneNumber,
    this.email,
    required this.code,
    required this.balance,
    required this.currency,
    this.createdAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString(),
      code: json['code']?.toString() ?? '',
      balance: toDoubleSafe(json['balance']),
      currency: json['currency']?.toString() ?? 'XOF',
      createdAt: parseDate(json['createdAt']),
    );
  }
}
