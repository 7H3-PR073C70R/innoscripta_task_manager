// ignore_for_file: deprecated_member_use, document_ignores

import 'package:flutter/material.dart';

extension MaterialColorExtension on Color {
  
    MaterialColor get toMaterialColor {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = red;
    final g = green;
    final b = blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
  
}
