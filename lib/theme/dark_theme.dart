import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade800,
    
  ),
);