// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Color.fromARGB(255, 255, 255, 255),
    primary: Color.fromARGB(255, 224, 224, 224),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(color: Colors.black),
    labelMedium:
        TextStyle(color: Color.fromARGB(255, 104, 104, 104), fontSize: 20),
    bodyMedium: TextStyle(color: Colors.black, fontSize: 24),
  ),
  buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(
    primary: Color.fromARGB(255, 71, 59, 128),
  )),
  scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color.fromARGB(255, 239, 239, 239),
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Color.fromARGB(255, 179, 179, 179),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    shadowColor: Colors.grey.shade900,
  ),
  textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.blue,
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.blue),
);
