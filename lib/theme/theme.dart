import 'package:flutter/material.dart';

final baseTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xffffffff),
  secondaryHeaderColor: const Color(0xffd3d3d3),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  primarySwatch: primarySwatch,
  disabledColor: Colors.grey[400],
);

final lightTheme = baseTheme.copyWith();
final darkTheme = baseTheme.copyWith();

/// アクセントカラーのスウォッチ
/// 生成元：http://mcg.mbitson.com/#!?mcgpalette0=%2306c755
const primarySwatch = MaterialColor(0xFF06c755, <int, Color>{
  50: Color(0xFFe1f8eb),
  100: Color(0xFFb4eecc),
  200: Color(0xFF83e3aa),
  300: Color(0xFF51d888),
  400: Color(0xFF2bcf6f),
  500: Color(0xFF06c755),
  600: Color(0xFF05c14e),
  700: Color(0xFF04ba44),
  800: Color(0xFF03b33b),
  900: Color(0xFF02a62a),
});
