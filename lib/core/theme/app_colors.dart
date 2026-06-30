import 'package:flutter/material.dart';

/// Palette de couleurs de l'application BadWallet.
/// Reprend la charte du tableau de bord Angular (thème « emerald »).
class AppColors {
  AppColors._();

  // Couleur principale (vert émeraude — identité BadWallet).
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFF34D399);

  /// Texte foncé posé sur les surfaces vives (dégradé, boutons).
  static const Color onAccent = Color(0xFF04261F);

  // Dégradé de la carte solde / du logo (identique à --bw-gradient).
  static const List<Color> balanceGradient = [
    Color(0xFF34D399),
    Color(0xFF10B981),
  ];

  // Sémantique financière.
  static const Color credit = Color(0xFF059669); // entrées (vert)
  static const Color debit = Color(0xFFF43F5E); // sorties (rouge/rose)

  // Neutres.
  static const Color background = Color(0xFFF4F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F1A17);
  static const Color textSecondary = Color(0xFF6B7A75);
  static const Color border = Color(0xFFE3E9E6);
}
