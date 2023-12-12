// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/var.dart';
import 'package:translator/widgets/themes/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 15,
                left: widthPerCentage(context, 0.03),
                right: widthPerCentage(context, 0.03)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).buttonTheme.colorScheme!.primary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_paint_outlined,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary),
                          Text(
                            " Change theme ",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                fontSize: 18),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
          //BTN Git
          Container(
            padding: EdgeInsets.only(
                top: 15,
                left: widthPerCentage(context, 0.03),
                right: widthPerCentage(context, 0.03)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).buttonTheme.colorScheme!.primary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  onTap: () async {
                    const url = 'https://github.com/6zikster/translator';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_outlined,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary),
                          Text(
                            " Source code ",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                fontSize: 18),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
