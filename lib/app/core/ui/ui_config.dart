import 'package:flutter/material.dart';
import './extensions/color_ex.dart';

class UiConfig {
  UiConfig._();

  static String get title => "Cuidapet";
  static ThemeData get theme => ThemeData(
      appBarTheme: const AppBarTheme(backgroundColor: ColorEx.primaryLight),
      scaffoldBackgroundColor: ColorEx.primaryBackgroundLight,
      colorScheme: ColorScheme.fromSwatch(
          primaryColorDark: ColorEx.primaryLight,
          primarySwatch: ColorEx.primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)))),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom()));
}
