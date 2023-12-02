// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/widgets/home/home.dart';
import 'package:translator/widgets/saved/saved.dart';
import 'package:translator/widgets/settings/settings.dart';
import 'package:translator/widgets/themes/dark_theme.dart';
import 'package:translator/widgets/themes/light_theme.dart';

import 'package:translator/widgets/themes/theme_provider.dart';
import 'var.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  var prefs = await SharedPreferences.getInstance();
  String prefThemeStr = prefs.getString("theme") ?? "dark";
  if (prefThemeStr == "dark") {
    prefTheme = darkTheme;
  } else {
    prefTheme = lightTheme;
  }
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
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
      theme: Provider.of<ThemeProvider>(context).themeData,
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
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            indicatorColor: Colors.blue,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            backgroundColor:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: Duration(milliseconds: 500),
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            height: heightPerCentage(context, 0.11),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedItemColor),
                label: "Home",
                selectedIcon: Icon(Icons.home_rounded,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.bookmark_outline,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                ),
                label: "Saved",
                selectedIcon: Icon(
                  Icons.bookmark_rounded,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor,
                ),
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                ),
                label: "Settings",
                selectedIcon: Icon(Icons.settings_rounded,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor),
              )
            ],
          ),
        ));
  }
}
