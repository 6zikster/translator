// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:translator/widgets/home/home.dart';
import 'package:translator/widgets/saved/saved.dart';
import 'package:translator/widgets/settings/settings.dart';
import 'var.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(scaffoldBackgroundColor: Color.fromARGB(221, 31, 29, 29)),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final screens = [HomePage(), SavedPage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.black,
            indicatorColor: Colors.blue,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: Duration(milliseconds: 500),
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            height: heightPerCentage(context, 0.11),
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                label: "Home",
                selectedIcon: Icon(Icons.home_rounded),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bookmark_outline,
                  color: Colors.white,
                ),
                label: "Saved",
                selectedIcon: Icon(Icons.bookmark_rounded),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                label: "Settings",
                selectedIcon: Icon(Icons.settings_rounded),
              )
            ],
          ),
        ));
  }
}
