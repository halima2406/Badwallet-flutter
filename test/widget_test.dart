// Tests unitaires basiques de BadWallet.

import 'package:flutter_test/flutter_test.dart';

import 'package:badwallet/core/utils/formatters.dart';
import 'package:badwallet/models/transaction.dart';

void main() {
  test('formatMoney formate un montant en XOF avec séparateur', () {
    expect(formatMoney(50000), '50 000 XOF');
    expect(formatMoney(1200), '1 200 XOF');
  });

  test('toDoubleSafe gère num, String et null', () {
    expect(toDoubleSafe(1500), 1500.0);
    expect(toDoubleSafe('2500.5'), 2500.5);
    expect(toDoubleSafe(null), 0.0);
  });

  test('TransactionModel détecte les entrées (crédit) et sorties', () {
    final depot = TransactionModel(
      reference: 'TX1',
      type: 'DEPOT',
      montant: 1000,
      frais: 0,
      statut: 'REUSSIE',
    );
    final retrait = TransactionModel(
      reference: 'TX2',
      type: 'RETRAIT',
      montant: 1000,
      frais: 50,
      statut: 'REUSSIE',
    );
    expect(depot.isCredit, true);
    expect(retrait.isCredit, false);
    expect(depot.typeLabel, 'Dépôt');
  });
}
