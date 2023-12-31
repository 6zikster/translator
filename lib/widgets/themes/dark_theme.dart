// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 28, 28, 28),
    primary: Color.fromARGB(255, 43, 43, 43),
    secondary: Color.fromARGB(255, 160, 196, 238),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.grey, fontSize: 20),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 24),
  ),
  buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 34, 155, 253),
  )),
  scaffoldBackgroundColor: Color.fromARGB(255, 28, 28, 28),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(221, 15, 15, 15),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    shadowColor: Colors.grey.shade900,
  ),
  textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.blue),
);
