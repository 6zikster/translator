// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: OutlinedButton(
      onPressed: () async {},
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
          side: MaterialStateProperty.all(BorderSide(
              color:
                  Theme.of(context).buttonTheme.colorScheme?.primary as Color,
              width: 1.0,
              style: BorderStyle.solid))),
      child: Text(
        "Change theme",
        style: TextStyle(
            color: Theme.of(context).buttonTheme.colorScheme?.primary),
      ),
    )));
  }
}
