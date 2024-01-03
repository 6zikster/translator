// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/var.dart';
import 'package:translator/db/db.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isSnackbarActive = false;

  _TextFieldsWidgetState() {
    _initLanguages();
    controllerEnterText.text = "";
    //if (controllerEnterText.text != "") {
    //translate(controllerEnterText.text, context);
    //}
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

  void translate(String textToTranslate, BuildContext context) async {
    if (textToTranslate.isNotEmpty) {
      if (textToTranslate[textToTranslate.length - 1] != "." ||
          textToTranslate[textToTranslate.length - 1] != "!" ||
          textToTranslate[textToTranslate.length - 1] != "?") {
        textToTranslate += ".";
      }
    }

    Map data = {
      "inputText": textToTranslate,
      "source": languageSource.substring(4),
      "destanation": languageDestanation.substring(4),
      "requestData": DateTime.now().toString()
    };

    var jsonData = jsonEncode(data);

    var url = 'http://185.119.196.48:8001';

    String textFromRequest = controllerOutText.text;
    String outData = lastRequest;
    try {
      await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      )
          .then((response) {
        try {
          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
          var outputText = jsonResponse['outputText'];
          textFromRequest = "$outputText";
          var outputData = jsonResponse['requestData'];
          outData = outputData;
        } catch (e) {
          print("translate: Error parsing JSON: " + "$e");
        }
      });
    } catch (e) {
      print("translate: Error: " + "$e");
      if ("$e" !=
              "ClientException: Connection reset by peer, uri=http://185.119.196.48:8001" &&
          !_isSnackbarActive) {
        _isSnackbarActive = true;
        const snack = SnackBar(
          content: Text('No connection to the server. '),
          backgroundColor: Colors.red,
          elevation: 20,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(snack)
            .closed
            .then((SnackBarClosedReason reason) {
          // snackbar is now closed.
          _isSnackbarActive = false;
        });
      }
    }

    if (timeCmp(lastRequest, outData)) {
      textFromRequest = textFromRequest.replaceAll(" ,", ",");
      textFromRequest = textFromRequest.replaceAll(" .", ".");
      textFromRequest = textFromRequest.replaceAll(" !", "!");
      textFromRequest = textFromRequest.replaceAll(" ?", "?");

      while (textFromRequest[textFromRequest.length - 1] == ' ') {
        if (textFromRequest.isNotEmpty) {
          textFromRequest =
              textFromRequest.substring(0, textFromRequest.length - 1);
        }
      }

      controllerOutText.text = textFromRequest;
      lastRequest = outData;
    }

    if (textToTranslate.isEmpty) {
      controllerOutText.text = "";
    }
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
                color: Theme.of(context).colorScheme.primary),
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
                          /*decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                width: 2,
                              ),
                              left: BorderSide(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                width: 2,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                            ),
                          ),*/
                          margin: EdgeInsets.only(left: 10.0),
                          width: widthPerCentage(context, 0.3),
                          child: TextButton(
                              child: Text(
                                languageSource,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme
                                        ?.primary),
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

                                    translate(
                                        controllerEnterText.text, context);
                                    setLanguageSource(languageSource);
                                    setLanguageDestanation(languageDestanation);
                                  });
                                  isBookmarked();
                                },
                                icon: Icon(
                                  Icons.swap_horiz_outlined,
                                  size: heightPerCentage(context, 0.045),
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          /*decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                width: 2,
                              ),
                              left: BorderSide(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme!
                                    .primary,
                                width: 2,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                              
                            ),
                          ),*/
                          width: widthPerCentage(context, 0.3),
                          margin: EdgeInsets.only(right: 10.0),
                          child: TextButton(
                            child: Text(
                              languageDestanation,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary),
                            ),
                            onPressed: () => {chooseDestanationLanguage()},
                          ),
                        ),
                      ],
                    )),
                columnDivider(),
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
                      hintStyle: Theme.of(context).textTheme.labelMedium,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20),
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        int temp = value.length;
                        print("translate: len: $temp");
                        translate(value, context);
                        isBookmarked();
                      });
                    },
                  ),
                ),
                columnDivider(),
                //out Text
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 5),
                  constraints: BoxConstraints(
                    minHeight: heightPerCentage(context, 0.15),
                  ),
                  child: outTextHintOrText(context),
                ),
                columnDivider(),
                //buttons
                Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15.0,
                    ),
                    height: heightPerCentage(context, 0.07),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //BTN bookmark ↓
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primary,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    onTap: () {
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
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              bookmarkBtnIcon,
                                              size: heightPerCentage(
                                                  context, 0.025),
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                            ),
                                            Text(
                                              " Bookmark ",
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
                            //Icon Paste
                            // ignore: avoid_unnecessary_containers
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primary,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    onTap: () {
                                      _getClipboardText();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.paste,
                                              
                                              size: heightPerCentage(
                                                  context, 0.025),
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                            ),
                                            Text(
                                              " Paste ",
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
                            //BTN Clear
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme!
                                          .primary,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    onTap: () {
                                      controllerEnterText.text = "";
                                      translate(
                                          controllerEnterText.text, context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.cleaning_services_outlined,
                                              size: heightPerCentage(
                                                  context, 0.025),
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary,
                                            ),
                                            Text(
                                              " Erase all ",
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
                          ]),
                    )),
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

  Widget columnDivider() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: heightPerCentage(context, 0.001),
      color: Theme.of(context).colorScheme.secondary,
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
            hintStyle: Theme.of(context).textTheme.labelMedium,
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 20,
          ),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              shadowColor: Colors.transparent,
              // ignore: avoid_unnecessary_containers
              content: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    RadioListTile(
                      fillColor: MaterialStateProperty.all(
                          Theme.of(context).buttonTheme.colorScheme?.primary),
                      title: Text(
                        languages[0],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      fillColor: MaterialStateProperty.all(
                          Theme.of(context).buttonTheme.colorScheme?.primary),
                      title: Text(
                        languages[1],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      fillColor: MaterialStateProperty.all(
                          Theme.of(context).buttonTheme.colorScheme?.primary),
                      title: Text(
                        languages[2],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      fillColor: MaterialStateProperty.all(
                          Theme.of(context).buttonTheme.colorScheme?.primary),
                      title: Text(
                        languages[3],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
          translate(controllerEnterText.text, context);
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              shadowColor: Colors.transparent,
              // ignore: sized_box_for_whitespace
              content: Container(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  RadioListTile(
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).buttonTheme.colorScheme?.primary),
                    title: Text(
                      languages[0],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).buttonTheme.colorScheme?.primary),
                    title: Text(
                      languages[1],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).buttonTheme.colorScheme?.primary),
                    title: Text(
                      languages[2],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    fillColor: MaterialStateProperty.all(
                        Theme.of(context).buttonTheme.colorScheme?.primary),
                    title: Text(
                      languages[3],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          translate(controllerEnterText.text, context);
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
      translate(controllerEnterText.text, context);
    });
    isBookmarked();
  }

  Future<void> _addItem(
      String src, String dst, String flagSrc, String flagDst) async {
    await SQLHelper.createItem(src, dst, flagSrc, flagDst);
    final data = await SQLHelper.getItems();
    bookmarkedWords = data;
  }

  bool timeCmp(String cmp1, String cmp2) {
    DateTime a = DateTime.parse(cmp1);
    DateTime b = DateTime.parse(cmp2);
    final Duration duration = a.difference(b);
    if (duration.isNegative) {
      return true;
    } else {
      return false;
    }
  }
}
