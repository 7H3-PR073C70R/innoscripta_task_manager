// ignore_for_file: deprecated_member_use, document_ignores

import 'package:flutter/material.dart';

enum LabelColor {
  berryRed(30, 'berry_red', Color(0xFFB8255F)),
  red(31, 'red', Color(0xFFDC4C3E)),
  orange(32, 'orange', Color(0xFFC77100)),
  yellow(33, 'yellow', Color(0xFFB29104)),
  oliveGreen(34, 'olive_green', Color(0xFF949C31)),
  limeGreen(35, 'lime_green', Color(0xFF65A33A)),
  green(36, 'green', Color(0xFF369307)),
  mintGreen(37, 'mint_green', Color(0xFF42A393)),
  teal(38, 'teal', Color(0xFF148FAD)),
  skyBlue(39, 'sky_blue', Color(0xFF319DC0)),
  lightBlue(40, 'light_blue', Color(0xFF6988A4)),
  blue(41, 'blue', Color(0xFF4180FF)),
  grape(42, 'grape', Color(0xFF692EC2)),
  violet(43, 'violet', Color(0xFFCA3FEE)),
  lavender(44, 'lavender', Color(0xFFA4698C)),
  magenta(45, 'magenta', Color(0xFFE05095)),
  salmon(46, 'salmon', Color(0xFFC9766F)),
  charcoal(47, 'charcoal', Color(0xFF808080)),
  grey(48, 'grey', Color(0xFF999999)),
  taupe(49, 'taupe', Color(0xFF8F7A69));

  const LabelColor(this.id, this.name, this.color);

  final int id;
  final String name;
  final Color color;

  static LabelColor fromName(String name) {
    return LabelColor.values.firstWhere(
      (e) => e.name == name,
      orElse: () => LabelColor.charcoal,
    );
  }

  static LabelColor fromColor(Color color) {
    return LabelColor.values.firstWhere(
      (e) => e.color.value == color.value,
      orElse: () => LabelColor.charcoal,
    );
  }
}
