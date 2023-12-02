import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/var.dart';
import 'package:translator/widgets/themes/dark_theme.dart';
import 'package:translator/widgets/themes/light_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = prefTheme;

  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  Future<void> setTheme(String theme) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("theme", theme);
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
      setTheme("dark");
    } else {
      themeData = lightTheme;
      setTheme("light");
    }
  }
}
