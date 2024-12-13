import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData tema = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(250, 26, 35, 126),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // cor de fundo
        foregroundColor: Colors.white, // cor do texto e icone
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        textStyle: TextStyle(fontSize: 17),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    useMaterial3: true,
  );
}
