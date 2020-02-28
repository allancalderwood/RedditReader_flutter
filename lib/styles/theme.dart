import 'package:flutter/material.dart';

ThemeData currentTheme = buildDefaultTheme();

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

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    // Colours of the app
      brightness: Brightness.light,
      primaryColor: const Color(0xff1FCCB7),
      accentColor: const Color(0xff272727),
      scaffoldBackgroundColor: const Color(0xffffffff),
      primaryColorDark:const Color(0xff1FCCB7),
      backgroundColor: const Color(0xffffffff),

      // Themes for text
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 46.0, fontWeight: FontWeight.bold, color: Colors.black12),
        headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black12),
        headline3: TextStyle(fontSize: 18.0, color: Colors.black12),
        bodyText1: TextStyle(fontSize: 14.0, color: Colors.black12),
        bodyText2: TextStyle(fontSize: 14.0, color: Color(0xffffffff)),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        color: const Color(0xffffffffff),
        elevation: 0,
      ),

      // icon themes
      iconTheme: IconThemeData(
        color: Colors.black12,
        size: 50.0,
      )
  );
}
