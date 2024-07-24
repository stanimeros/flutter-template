library flutter_template;
import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData getThemeData(TextStyle textStyle) {
    return ThemeData(
      brightness: Brightness.dark,
      textTheme: TextTheme(
        titleSmall: textStyle,
        titleMedium: textStyle,
        titleLarge: textStyle,
        bodySmall: textStyle,
        bodyMedium: textStyle,
        bodyLarge: textStyle,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // selectedItemColor: const Color.fromARGB(255, 35, 35, 35),
        selectedLabelStyle: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
        unselectedLabelStyle: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(90, 40)
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textStyle: WidgetStatePropertyAll(textStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16
          )),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
          // backgroundColor: const WidgetStatePropertyAll(Color.fromARGB(255, 230, 230, 230)),
          // foregroundColor:const WidgetStatePropertyAll(Colors.black),
          // overlayColor: const WidgetStatePropertyAll(Color.fromARGB(255, 220, 220, 220))
        )
      ),
    );
  }
}
