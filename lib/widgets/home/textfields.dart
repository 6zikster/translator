// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/var.dart';
import 'package:translator/db/db.dart';

class TextFieldsWidget extends StatefulWidget {
  const TextFieldsWidget({Key? key}) : super(key: key);

  @override
  State<TextFieldsWidget> createState() => _TextFieldsWidgetState();
}

class _TextFieldsWidgetState extends State<TextFieldsWidget> {
  TextEditingController controllerOutText = TextEditingController();
  final translationController = TextEditingController();
  int selectedOption = 1;
  IconData? bookmarkBtnIcon = Icons.bookmark;

  bool isLoading = true;

  _TextFieldsWidgetState() {
    _initLanguages();
    if (controllerEnterText.text != "") {
      controllerOutText.text = translate(controllerEnterText.text);
    }
    isBookmarked();
  }

  void _initLanguages() async {
    await initLanguageSource();
    await initLanguageDestanation();
    final data = await SQLHelper.getItems();
    bookmarkedWords = data;
    setState(() {
      isLoading = false;
    });
  }

  String translate(String textToTranslate) {
    String res = "";
    if (textToTranslate == "legendary") {
      res = "легендарноо";
    } else if (textToTranslate == "легендарно") {
      res = "legendary";
    } else {
      res = textToTranslate;
    }
    print("res " + res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: widthPerCentage(context, 0.9),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 41, 41, 41)),
            child: Column(
              children: [
                //language pick

                // ignore: sized_box_for_whitespace
                Container(
                    width: widthPerCentage(context, 1),
                    height: heightPerCentage(context, 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          width: widthPerCentage(context, 0.3),
                          child: TextButton(
                              child: Text(
                                languageSource,
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () {
                                //Choose source language
                                chooseSourceLanguage();
                              }),
                        ),
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  setState(() {
                                    String temp = languageDestanation;
                                    languageDestanation = languageSource;
                                    languageSource = temp;
                                    controllerEnterText.text =
                                        controllerOutText.text;
                                    controllerOutText.text =
                                        translate(controllerEnterText.text);
                                    setLanguageSource(languageSource);
                                    setLanguageDestanation(languageDestanation);
                                  });
                                  isBookmarked();
                                },
                                icon: Icon(
                                  Icons.swap_horiz_outlined,
                                  size: heightPerCentage(context, 0.045),
                                ),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: widthPerCentage(context, 0.3),
                          margin: EdgeInsets.only(right: 10.0),
                          child: TextButton(
                            child: Text(
                              languageDestanation,
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: () => {chooseDestanationLanguage()},
                          ),
                        ),
                      ],
                    )),
                rowDivider(),
                //Enter text
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                  constraints: BoxConstraints(
                    minHeight: heightPerCentage(context, 0.15),
                  ),
                  child: TextField(
                    controller: controllerEnterText,
                    decoration: InputDecoration(
                      hintText: 'Enter text...',
                      hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        controllerOutText.text = translate(value);
                        print("res2 " + controllerOutText.text);
                        isBookmarked();
                      });
                    },
                  ),
                ),
                rowDivider(),
                //out Text
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                  constraints: BoxConstraints(
                    minHeight: heightPerCentage(context, 0.15),
                  ),
                  child: outTextHintOrText(context),
                ),
                rowDivider(),
                //buttons
                Container(
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15.0,
                  ),
                  height: heightPerCentage(context, 0.07),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Icon Bookmark
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (controllerEnterText.text != "" &&
                                      bookmarkBtnIcon != Icons.bookmark) {
                                    setState(() {
                                      bookmarkBtnIcon = Icons.bookmark;
                                    });

                                    //add item
                                    _addItem(
                                        controllerEnterText.text,
                                        controllerOutText.text,
                                        languageSource,
                                        languageDestanation);
                                  }
                                },
                                icon: Icon(bookmarkBtnIcon,
                                    size: heightPerCentage(context, 0.035)),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        //Icon Paste
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  _getClipboardText();
                                },
                                icon: Icon(
                                  Icons.paste_outlined,
                                  size: heightPerCentage(context, 0.035),
                                ),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    translationController.dispose();
    super.dispose();
  }

  Widget rowDivider() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: heightPerCentage(context, 0.001),
      color: Colors.blueAccent,
      margin: EdgeInsets.only(left: 15, right: 15),
    );
  }

  Widget outTextHintOrText(BuildContext context) {
    Widget res;

    res = Container(
        alignment: Alignment.topLeft,
        child: TextField(
          readOnly: true,
          maxLines: null,
          controller: controllerOutText,
          decoration: InputDecoration(
            hintText: "You'll see the translation here",
            hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));

    return res;
  }

  //function returns dialog in which we choose source language
  Future<Null> chooseSourceLanguage() {
    String prev = languageSource;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              )),
              title: Text(
                "Choose language",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color.fromARGB(255, 48, 46, 49),
              shadowColor: Colors.transparent,
              // ignore: avoid_unnecessary_containers
              content: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    RadioListTile(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      title: Text(
                        languages[0],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      value: languages[0],
                      groupValue: languageSource,
                      onChanged: (value) {
                        setState(() {
                          setLanguageSource(value.toString());
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      title: Text(
                        languages[1],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      value: languages[1],
                      groupValue: languageSource,
                      onChanged: (value) {
                        setState(() {
                          setLanguageSource(value.toString());
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      title: Text(
                        languages[2],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      value: languages[2],
                      groupValue: languageSource,
                      onChanged: (value) {
                        setState(() {
                          setLanguageSource(value.toString());
                        });
                      },
                    ),
                    RadioListTile(
                      fillColor: MaterialStateProperty.all(Colors.blue),
                      title: Text(
                        languages[3],
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      value: languages[3],
                      groupValue: languageSource,
                      onChanged: (value) {
                        setState(() {
                          setLanguageSource(value.toString());
                        });
                      },
                    )
                  ],
                ),
              )),
            );
          });
        }).then((val) {
      setState(() {
        if (languageSource == languageDestanation) {
          setLanguageDestanation(prev);
          controllerEnterText.text = controllerOutText.text;
          controllerOutText.text = translate(controllerEnterText.text);
        }
        isBookmarked();
      });
    });
  }

  //function returns dialog in which we choose destanation language
  Future<Null> chooseDestanationLanguage() {
    String prev = languageDestanation;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              )),
              title: Text(
                "Choose language",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color.fromARGB(255, 48, 46, 49),
              shadowColor: Colors.transparent,
              // ignore: sized_box_for_whitespace
              content: Container(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  RadioListTile(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    title: Text(
                      languages[0],
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    value: languages[0],
                    groupValue: languageDestanation,
                    onChanged: (value) {
                      setState(() {
                        setLanguageDestanation(value.toString());
                      });
                    },
                  ),
                  RadioListTile(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    title: Text(
                      languages[1],
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    value: languages[1],
                    groupValue: languageDestanation,
                    onChanged: (value) {
                      setState(() {
                        setLanguageDestanation(value.toString());
                      });
                    },
                  ),
                  RadioListTile(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    title: Text(
                      languages[2],
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    value: languages[2],
                    groupValue: languageDestanation,
                    onChanged: (value) {
                      setState(() {
                        setLanguageDestanation(value.toString());
                      });
                    },
                  ),
                  RadioListTile(
                    fillColor: MaterialStateProperty.all(Colors.blue),
                    title: Text(
                      languages[3],
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    value: languages[3],
                    groupValue: languageDestanation,
                    onChanged: (value) {
                      setState(() {
                        setLanguageDestanation(value.toString());
                      });
                    },
                  )
                ],
              ))),
            );
          });
        }).then((val) {
      setState(() {
        if (languageDestanation == languageSource) {
          setLanguageSource(prev);
          controllerEnterText.text = controllerOutText.text;
          controllerOutText.text = translate(controllerEnterText.text);
        }

        isBookmarked();
      });
    });
  }

  //sets bookmark icon. being called after text changed
  void isBookmarked() {
    bool flagBookmarkBtnIcon = false;

    String strSrc = "";
    String flgSrc = "";
    String flgDst = "";
    for (int i = 0; i < bookmarkedWords.length; i++) {
      strSrc = bookmarkedWords[i]['strSource'];
      flgSrc = bookmarkedWords[i]['flagSource'];
      flgDst = bookmarkedWords[i]['flagDestanation'];

      if (strSrc == controllerEnterText.text &&
          flgSrc == languageSource &&
          flgDst == languageDestanation) {
        flagBookmarkBtnIcon = true;
        break;
      }
    }
    if (flagBookmarkBtnIcon) {
      bookmarkBtnIcon = Icons.bookmark;
    } else {
      bookmarkBtnIcon = Icons.bookmark_add_outlined;
    }
  }

  void _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    controllerEnterText.text = clipboardText!;
    setState(() {
      controllerOutText.text = translate(controllerEnterText.text);
    });
    isBookmarked();
  }

  Future<void> _addItem(
      String src, String dst, String flagSrc, String flagDst) async {
    await SQLHelper.createItem(src, dst, flagSrc, flagDst);
    final data = await SQLHelper.getItems();
    bookmarkedWords = data;
  }
}
