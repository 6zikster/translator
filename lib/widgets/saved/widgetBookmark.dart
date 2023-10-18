import 'package:flutter/material.dart';
import 'package:translator/var.dart';
import 'package:translator/db/db.dart';

class WidgetBookmark extends StatefulWidget {
  WidgetBookmark({Key? key, required this.index}) : super(key: key);

  final int index;
  @override
  State<WidgetBookmark> createState() => _WidgetBookmarkState(index);
}

class _WidgetBookmarkState extends State<WidgetBookmark> {
  int index = -1;
  _WidgetBookmarkState(int i) {
    index = i;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
            margin: const EdgeInsets.only(top: 10, left: 20),
            color: const Color.fromARGB(255, 41, 41, 41),
            // ignore: sized_box_for_whitespace
            child: Container(
              width: widthPerCentage(context, 0.8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 10),
                          child: Text(
                            bookmarkedWords[index]['flagSource']
                                .substring(0, 4),
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            bookmarkedWords[index]['strSource'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: heightPerCentage(context, 0.001),
                    indent: 20,
                    endIndent: 20,
                    color: Colors.blueAccent,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 10),
                          child: Text(
                            bookmarkedWords[index]['flagDestanation']
                                .substring(0, 4),
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            bookmarkedWords[index]['strDestanation'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: InkWell(
            child: Icon(Icons.delete_outline,
                size: widthPerCentage(context, 0.078), color: Colors.redAccent),
            onTap: () {
              _deleteItem(bookmarkedWords[index]['id'], index);
            },
          ),
        )
      ],
    );
  }

  Future<void> _deleteItem(int id, int index) async {
    String strSource = bookmarkedWords[index]['strSource'];
    String strDestanation = bookmarkedWords[index]['strDestanation'];
    String flagSource = bookmarkedWords[index]['flagSource'];
    String flagDestanation = bookmarkedWords[index]['flagDestanation'];

    await SQLHelper.deleteItem(id);
    _refreshJournals();

    keyToWords.currentState!.removeItem(
      index,
      (_, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Card(
              margin: const EdgeInsets.only(top: 10, left: 20),
              color: const Color.fromARGB(255, 129, 38, 32),
              // ignore: sized_box_for_whitespace
              child: Container(
                width: widthPerCentage(context, 0.8),
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              flagSource.substring(0, 4),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              strSource,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: heightPerCentage(context, 0.001),
                      indent: 20,
                      endIndent: 20,
                      color: Colors.blueAccent,
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              flagDestanation.substring(0, 4),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              strDestanation,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        );
      },
      duration: const Duration(milliseconds: 400),
    );
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      bookmarkedWords = data;
    });
  }
}
