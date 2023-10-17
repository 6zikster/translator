import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/var.dart';

class WidgetBookmark extends StatefulWidget {
  WidgetBookmark({Key? key, required this.index}) : super(key: key);

  final int index;
  @override
  State<WidgetBookmark> createState() => _WidgetBookmarkState(index);
}

class _WidgetBookmarkState extends State<WidgetBookmark> {
  int index = -1;
  _WidgetBookmarkState(int i) {
    this.index = i;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Card(
            margin: EdgeInsets.all(10),
            color: Color.fromARGB(255, 41, 41, 41),
            child: Container(
              width: widthPerCentage(context, 0.8),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 10),
                          child: Text(
                            bookmarkedWords[index].FlagSource.substring(0, 4),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            bookmarkedWords[index].strSource,
                            style: TextStyle(color: Colors.white, fontSize: 24),
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
                    margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 10),
                          child: Text(
                            bookmarkedWords[index]
                                .FlagDestanation
                                .substring(0, 4),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            bookmarkedWords[index].strDestanation,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        InkWell(
          child: Icon(Icons.delete_outline,
              size: widthPerCentage(context, 0.078), color: Colors.redAccent),
          onTap: () {
            _removeItem(index);
          },
        ),
      ],
    );
  }

  void _removeItem(int index) {
    String strSource = bookmarkedWords[index].strSource;
    String strDestanation = bookmarkedWords[index].strDestanation;
    String FlagSource = bookmarkedWords[index].FlagSource;
    String FlagDestanation = bookmarkedWords[index].FlagDestanation;

    bookmarkedWords.removeAt(index);
    keyToWords.currentState!.removeItem(
      index,
      (_, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: Card(
              margin: EdgeInsets.all(10),
              color: const Color.fromARGB(255, 129, 38, 32),
              child: Container(
                width: widthPerCentage(context, 0.8),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              FlagSource.substring(0, 4),
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              strSource,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
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
                      margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 10),
                            child: Text(
                              FlagDestanation.substring(0, 4),
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              strDestanation,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
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
      duration: Duration(milliseconds: 400),
    );
  }
}
