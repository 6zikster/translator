// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:translator/db/db.dart';
import 'package:translator/var.dart';
import 'widgetBookmark.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();

    setState(() {
      bookmarkedWords = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Words",
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AnimatedList(
              key: keyToWords,
              initialItemCount: bookmarkedWords.length,
              itemBuilder: ((context, index, animation) {
                return SizeTransition(
                    sizeFactor: animation,
                    key: UniqueKey(),
                    child: WidgetBookmark(index: index));
              })),
    );
  }
}
