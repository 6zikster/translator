import 'package:flutter/material.dart';

double widthPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width *
      percentage; // set width to percentage% of the screen width
}

double heightPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height *
      percentage; // set width to percentage% of the screen width
}

class Bookmarks {
  String strSource = "";
  String strDestanation = "";
  String FlagSource = "";
  String FlagDestanation = "";
}

List<Bookmarks> bookmarkedWords = [];
final GlobalKey<AnimatedListState> keyToWords = GlobalKey();

List<String> languages = ["🇺🇸Eng", "🇷🇺Rus", "🇪🇸Spa", "🇫🇷Fr"];
String languageSource = languages[0];
String languageDestanation = languages[1];
TextEditingController controllerTranslatedField = TextEditingController();
