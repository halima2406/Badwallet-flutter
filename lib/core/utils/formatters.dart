import 'package:intl/intl.dart';

// transforme une valeur du json en double sans planter
double toDoubleSafe(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

// lit une date envoyee par le backend
DateTime? parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

final NumberFormat _moneyFormat = NumberFormat.decimalPattern('fr_FR')
  ..maximumFractionDigits = 0;

// 50000 -> "50 000 XOF"
String formatMoney(num amount, {String currency = 'XOF'}) {
  return '${formatAmount(amount)} $currency';
}

// 50000 -> "50 000" (je remplace les espaces speciaux par des espaces normaux)
String formatAmount(num amount) => _moneyFormat
    .format(amount)
    .replaceAll(' ', ' ')
    .replaceAll(' ', ' ');

// ex: 30 juin 2026
String formatDate(DateTime? date) {
  if (date == null) return '-';
  return DateFormat('d MMM yyyy', 'fr_FR').format(date);
}

// ex: 30 juin 2026 • 14:30
String formatDateTime(DateTime? date) {
  if (date == null) return '-';
  return DateFormat("d MMM yyyy • HH:mm", 'fr_FR').format(date);
}
