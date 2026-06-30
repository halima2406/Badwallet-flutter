import 'package:flutter/material.dart';

// les couleurs de l'appli (les memes que mon projet Angular, vert emeraude)
class AppColors {
  AppColors._();

  // couleur principale
  static const Color primary = Color(0xFF10B981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFF34D399);

  // texte fonce posé sur le vert
  static const Color onAccent = Color(0xFF04261F);

  // degrade de la carte du solde et du logo
  static const List<Color> balanceGradient = [
    Color(0xFF34D399),
    Color(0xFF10B981),
  ];

  static const Color credit = Color(0xFF059669); // entrees (vert)
  static const Color debit = Color(0xFFF43F5E); // sorties (rouge)

  // couleurs neutres
  static const Color background = Color(0xFFF4F7F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F1A17);
  static const Color textSecondary = Color(0xFF6B7A75);
  static const Color border = Color(0xFFE3E9E6);
}
