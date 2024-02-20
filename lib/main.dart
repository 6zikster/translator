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
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();
  String prefThemeStr = prefs.getString("theme") ?? "dark";
  if (prefThemeStr == "dark") {
    prefTheme = darkTheme;
  } else {
    prefTheme = lightTheme;
  }

  //DB
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
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
    return MediaQuery.of(context).size.height >
            MediaQuery.of(context).size.width
        ? Scaffold(
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
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
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
            ))
        : Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: (int index) {
                    setState(() {
                      this.index = index;
                    });
                  },
                  indicatorColor: Colors.blue,
                  labelType: NavigationRailLabelType.selected,
                  backgroundColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  destinations: <NavigationRailDestination>[
                    // navigation destinations
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined,
                          color: Theme.of(context)
                              .bottomNavigationBarTheme
                              .unselectedItemColor),
                      label: Text("Home"),
                      selectedIcon: Icon(Icons.home_rounded,
                          color: Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedItemColor),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.bookmark_outline,
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                      ),
                      label: Text("Saved"),
                      selectedIcon: Icon(
                        Icons.bookmark_rounded,
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .selectedItemColor,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                      ),
                      label: Text("Settings"),
                      selectedIcon: Icon(Icons.settings_rounded,
                          color: Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedItemColor),
                    ),
                  ],
                ),
                //const VerticalDivider(thickness: 1, width: 2),
                Expanded(
                  child: screens[index],
                ),
              ],
            ),
          );
  }
}
