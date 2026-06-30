import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ===========================================================================
///  CONFIGURATION DU BACKEND (BadWallet API & Payment Service - port 8080)
/// ===========================================================================
///
///  Le backend Spring Boot expose l'API sur http://localhost:8080.
///  Selon l'endroit où tourne l'application, "localhost" ne pointe PAS au
///  même endroit :
///
///   * Navigateur web (flutter run -d chrome) ......... http://localhost:8080
///   * Émulateur Android .............................. http://10.0.2.2:8080
///   * Téléphone Android physique ..................... http://IP-DU-PC:8080
///                                                       (PC et tél sur le même WiFi)
///
///  👉 Pour changer de cible, modifie simplement les deux constantes ci-dessous.
/// ---------------------------------------------------------------------------

/// IP du PC sur le réseau local (WiFi). À adapter si elle change.
/// (détectée automatiquement à la génération : `ipconfig getifaddr en0`)
const String kPcLanIp = '192.168.1.9';

/// Mets `true` si tu testes sur un ÉMULATEUR Android (utilise 10.0.2.2).
/// Laisse `false` pour un TÉLÉPHONE physique (utilise l'IP du PC ci-dessus).
const bool kUseAndroidEmulator = false;

/// URL de base calculée automatiquement selon la plateforme.
String get apiBaseUrl {
  if (kIsWeb) return 'http://localhost:8080';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return kUseAndroidEmulator ? 'http://10.0.2.2:8080' : 'http://$kPcLanIp:8080';
  }
  // iOS simulateur / desktop
  return 'http://localhost:8080';
}

/// Numéro pré-rempli pour la démo (existe dans le seeder du backend).
const String kDemoPhone = '+221770000003';

/// ===========================================================================
///  Catalogue des fournisseurs de factures (écran "Payer").
///  Le backend seede réellement ISM et WOYAFAL ; les autres sont affichés
///  pour l'UI (ils renverront "aucune facture impayée").
/// ===========================================================================
class BillProvider {
  final String serviceName;
  final String label;
  final IconData icon;
  final Color color;

  const BillProvider(this.serviceName, this.label, this.icon, this.color);
}

const List<BillProvider> kBillProviders = [
  BillProvider('ISM', 'ISM', Icons.school_rounded, Color(0xFF5B3CC4)),
  BillProvider('WOYAFAL', 'Woyafal', Icons.bolt_rounded, Color(0xFFF59E0B)),
  BillProvider('SENELEC', 'Senelec', Icons.lightbulb_rounded, Color(0xFF0EA5E9)),
  BillProvider('RAPIDO', 'Rapido', Icons.directions_bus_rounded, Color(0xFF10B981)),
];
