// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:translator/var.dart';
import 'widgetBookmark.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  void _addItem() {
    Bookmarks temp = Bookmarks();
    temp.strSource = "Item ${bookmarkedWords.length + 1}";
    temp.strDestanation = "Item ${bookmarkedWords.length}";
    bookmarkedWords.insert(0, temp);
    keyToWords.currentState!.insertItem(0, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          shadowColor: Colors.grey.shade900, //shadow looks aweful
          foregroundColor: Colors.white,
          title: Text(
            "Saved Words",
            selectionColor: Colors.white,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: AnimatedList(
                key: keyToWords,
                initialItemCount: bookmarkedWords.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                      key: UniqueKey(),
                      sizeFactor: animation,
                      //Element of Bookmark!
                      child: WidgetBookmark(index: index));
                },
              ),
            )
          ],
        ));
  }
}
