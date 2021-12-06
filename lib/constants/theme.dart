import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/main.dart';

CustomTheme currentTheme = CustomTheme();

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = true;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.pink,
      accentColor: LicheeColors.accentColor,
      brightness: Brightness.dark,
      splashColor: LicheeColors.splashColor,
      primaryColor: LicheeColors.primary,
      backgroundColor: const Color(0xFF1A1A1A),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    );
  }
}
