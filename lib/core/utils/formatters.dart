import 'package:intl/intl.dart';

double toDoubleSafe(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

DateTime? parseDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

final NumberFormat _moneyFormat = NumberFormat.decimalPattern('fr_FR')
  ..maximumFractionDigits = 0;

String formatMoney(num amount, {String currency = 'XOF'}) {
  return '${formatAmount(amount)} $currency';
}

String formatAmount(num amount) => _moneyFormat
    .format(amount)
    .replaceAll(' ', ' ')
    .replaceAll(' ', ' ');

String formatDate(DateTime? date) {
  if (date == null) return '-';
  return DateFormat('d MMM yyyy', 'fr_FR').format(date);
}

String formatDateTime(DateTime? date) {
  if (date == null) return '-';
  return DateFormat("d MMM yyyy • HH:mm", 'fr_FR').format(date);
}
