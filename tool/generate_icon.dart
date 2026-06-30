// Génère les icônes de l'application BadWallet (logo portefeuille violet).
//   dart run tool/generate_icon.dart
//
// Produit :
//   assets/icon/icon.png            -> icône complète (fond dégradé + portefeuille)
//   assets/icon/icon_foreground.png -> avant-plan transparent pour icône adaptative
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const int size = 1024;

void main() {
  _writeFull();
  _writeForeground();
}

void _writeFull() {
  final image = img.Image(width: size, height: size, numChannels: 4);
  const radius = 224;

  // Fond dégradé violet vertical, coins arrondis.
  for (var y = 0; y < size; y++) {
    final t = y / (size - 1);
    // Dégradé emerald (#34D399 -> #10B981), identique au dashboard Angular.
    final r = (0x34 + (0x10 - 0x34) * t).round();
    final g = (0xD3 + (0xB9 - 0xD3) * t).round();
    final b = (0x99 + (0x81 - 0x99) * t).round();
    for (var x = 0; x < size; x++) {
      if (_inRoundedRect(x, y, radius)) {
        image.setPixelRgba(x, y, r, g, b, 255);
      } else {
        image.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }

  _drawWallet(image, scale: 1.0);
  _save(image, 'assets/icon/icon.png');
}

void _writeForeground() {
  final image = img.Image(width: size, height: size, numChannels: 4);
  // Transparent : seul le portefeuille (un peu plus petit, zone de sécurité).
  _drawWallet(image, scale: 0.82);
  _save(image, 'assets/icon/icon_foreground.png');
}

void _drawWallet(img.Image image, {required double scale}) {
  final white = img.ColorRgba8(255, 255, 255, 255);
  final band = img.ColorRgba8(0x04, 0x26, 0x1F, 255);
  final clasp = img.ColorRgba8(0x05, 0x96, 0x69, 255);

  final cx = size / 2;
  final cy = size / 2;
  double sx(double v) => cx + (v - 512) * scale;
  double sy(double v) => cy + (v - 512) * scale;

  // Corps du portefeuille (carte blanche arrondie).
  img.fillRect(image,
      x1: sx(300).round(),
      y1: sy(404).round(),
      x2: sx(724).round(),
      y2: sy(700).round(),
      radius: (56 * scale).round(),
      color: white);

  // Bande supérieure (rabat).
  img.fillRect(image,
      x1: sx(300).round(),
      y1: sy(404).round(),
      x2: sx(724).round(),
      y2: sy(508).round(),
      radius: (56 * scale).round(),
      color: band);

  // Fermoir (cercle).
  img.fillCircle(image,
      x: sx(676).round(),
      y: sy(604).round(),
      radius: (38 * scale).round(),
      color: clasp);
}

bool _inRoundedRect(int x, int y, int radius) {
  final maxv = size - 1;
  if (x < radius && y < radius) return _dist(x, y, radius, radius) <= radius;
  if (x > maxv - radius && y < radius) {
    return _dist(x, y, maxv - radius, radius) <= radius;
  }
  if (x < radius && y > maxv - radius) {
    return _dist(x, y, radius, maxv - radius) <= radius;
  }
  if (x > maxv - radius && y > maxv - radius) {
    return _dist(x, y, maxv - radius, maxv - radius) <= radius;
  }
  return true;
}

double _dist(int x, int y, int cx, int cy) {
  final dx = (x - cx).toDouble();
  final dy = (y - cy).toDouble();
  return math.sqrt(dx * dx + dy * dy);
}

void _save(img.Image image, String path) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(image));
  stdout.writeln('✓ $path');
}
