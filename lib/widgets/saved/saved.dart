// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Icon(
      Icons.umbrella,
      color: Colors.yellowAccent,
    )));
  }
}
