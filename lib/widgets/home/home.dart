// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:translator/var.dart';
import 'textfields.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: heightPerCentage(context, 0.1),
            ),
            TextFieldsWidget(),
            SizedBox(
              height: heightPerCentage(context, 0.1),
            ),
          ],
        ),
      ),
    ));
  }
}
