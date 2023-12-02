// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromARGB(255, 28, 28, 28),
    primary: Color.fromARGB(255, 43, 43, 43),
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
    color: Color.fromARGB(221, 31, 29, 29),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    shadowColor: Colors.grey.shade900,
  ),
);
