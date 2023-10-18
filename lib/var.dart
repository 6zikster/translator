import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

double widthPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width *
      percentage; // set width to percentage% of the screen width
}

double heightPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height *
      percentage; // set width to percentage% of the screen width
}

List<Map<String, dynamic>> bookmarkedWords = [];
final GlobalKey<AnimatedListState> keyToWords = GlobalKey();

List<String> languages = ["🇺🇸Eng", "🇷🇺Rus", "🇪🇸Spa", "🇫🇷Fr"];
String languageSource = languages[0];
String languageDestanation = languages[1];
TextEditingController controllerTranslatedField = TextEditingController();

Future<void> setLanguageSource(String language) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("languageSource", language);
  languageSource = language;
}

Future<String> getLanguageSource() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString("languageSource") ?? languages[0];
}

Future initLanguageSource() async {
  languageSource = await getLanguageSource();
}

Future<void> setLanguageDestanation(String language) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("languageDestanation", language);
  languageDestanation = language;
}

Future<String> getLanguageDestanation() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString("languageDestanation") ?? languages[1];
}

Future initLanguageDestanation() async {
  languageDestanation = await getLanguageDestanation();
}
