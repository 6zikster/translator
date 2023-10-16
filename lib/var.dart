import 'package:flutter/material.dart';

double widthPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width *
      percentage; // set width to percentage% of the screen width
}

double heightPerCentage(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.height *
      percentage; // set width to percentage% of the screen width
}
