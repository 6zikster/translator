// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/var.dart';

class TextFieldsWidget extends StatefulWidget {
  const TextFieldsWidget({Key? key}) : super(key: key);

  @override
  State<TextFieldsWidget> createState() => _TextFieldsWidgetState();
}

class _TextFieldsWidgetState extends State<TextFieldsWidget> {
  String translation = "";
  final translationController = TextEditingController();
  int selectedOption = 1;
  List<String> languages = ["🇺🇸Eng", "🇷🇺Rus", "🇪🇸Spa", "🇫🇷Fr"];
  String languageSource = "";
  String languageDestanation = "";
  TextEditingController controllerTranslatedField = TextEditingController();
  _TextFieldsWidgetState() {
    languageSource = languages[0];
    languageDestanation = languages[1];
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
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthPerCentage(context, 0.9),
      height: heightPerCentage(context, 0.48),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(255, 41, 41, 41)),
      child: Column(
        children: [
          //language pick
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
                              controllerTranslatedField.text = translation;
                              translation =
                                  translate(controllerTranslatedField.text);
                            });
                          },
                          icon: Icon(
                            Icons.switch_left,
                            size: heightPerCentage(context, 0.03),
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
              margin: EdgeInsets.only(
                left: 15,
              ),
              width: widthPerCentage(context, 1),
              height: heightPerCentage(context, 0.16),
              child: SingleChildScrollView(
                child: TextField(
                  controller: controllerTranslatedField,
                  decoration: InputDecoration(
                    hintText: 'Enter text...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      translation = translate(value);
                    });
                  },
                ),
              )),
          rowDivider(),
          //out Text
          outTextHintOrText(context),
          rowDivider(),
          //buttons
          Container(
            margin: EdgeInsets.only(
              left: 15,
              right: 15.0,
            ),
            width: widthPerCentage(context, 1),
            height: heightPerCentage(context, 0.07),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => {},
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            size: heightPerCentage(context, 0.035),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => {_getClipboardText()},
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
          Container(),
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
    return Container(
      height: heightPerCentage(context, 0.005),
      child: Divider(
        thickness: heightPerCentage(context, 0.001),
        indent: 20,
        endIndent: 20,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget outTextHintOrText(BuildContext context) {
    Widget res;
    if (translation != '') {
      res = Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 15),
          height: heightPerCentage(context, 0.16),
          child: SingleChildScrollView(
            child: Text(
              translation,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ));
    } else {
      res = Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 15),
          height: heightPerCentage(context, 0.16),
          child: SingleChildScrollView(
            child: Text(
              "You'll see the translation here",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ));
    }
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
                          languageSource = value.toString();
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
                          languageSource = value.toString();
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
                          languageSource = value.toString();
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
                          languageSource = value.toString();
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
          languageDestanation = prev;
          controllerTranslatedField.text = translation;
          translation = translate(controllerTranslatedField.text);
        }
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
              content: Container(
                  height: heightPerCentage(context, 0.28),
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
                            languageDestanation = value.toString();
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
                            languageDestanation = value.toString();
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
                            languageDestanation = value.toString();
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
                            languageDestanation = value.toString();
                          });
                        },
                      )
                    ],
                  )),
            );
          });
        }).then((val) {
      setState(() {
        if (languageDestanation == languageSource) {
          languageSource = prev;
          controllerTranslatedField.text = translation;
          translation = translate(controllerTranslatedField.text);
        }
      });
    });
  }

  void _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    controllerTranslatedField.text = clipboardText!;
    setState(() {
      translation = translate(controllerTranslatedField.text);
    });
  }
}
