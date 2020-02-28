import 'package:flutter/material.dart';

final ThemeData currentTheme = buildDefaultTheme();

ThemeData buildDefaultTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    // Colours of the app
      brightness: Brightness.dark,
      primaryColor: const Color(0xff1FCCB7),
      accentColor: const Color(0xff272727),
      scaffoldBackgroundColor: const Color(0xff1C1C1C),
      primaryColorDark:const Color(0xff171717),
      backgroundColor: const Color(0xff1C1C1C),

      // Themes for text
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 46.0, fontWeight: FontWeight.bold, color: Colors.white),
        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
        headline3: TextStyle(fontSize: 18.0, color: Colors.white),
        bodyText1: TextStyle(fontSize: 14.0, color: Colors.white),
        bodyText2: TextStyle(fontSize: 14.0, color: Color(0xff1C1C1C)),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        color: const Color(0xff1C1C1C),
        elevation: 0,
      ),

      // icon themes
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 50.0,
      )
  );
}
