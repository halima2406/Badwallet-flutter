import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Config du backend (API sur le port 8080).

// IP de mon PC sur le wifi (pour tester sur le téléphone). A changer si besoin.
const String kPcLanIp = '192.168.1.9';

// true = emulateur Android, false = vrai telephone
const bool kUseAndroidEmulator = false;

// localhost ne pointe pas au meme endroit selon la plateforme
String get apiBaseUrl {
  if (kIsWeb) return 'http://localhost:8080';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return kUseAndroidEmulator ? 'http://10.0.2.2:8080' : 'http://$kPcLanIp:8080';
  }
  return 'http://localhost:8080';
}

// numero deja rempli pour tester
const String kDemoPhone = '+221770000003';

// liste des fournisseurs de factures
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
