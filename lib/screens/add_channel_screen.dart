import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'channel_list/categories_tree_view.dart';

class AddChannelScreen extends StatefulWidget {
  const AddChannelScreen({Key? key}) : super(key: key);

  @override
  _AddChannelScreenState createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  bool isAddChannelPressed = false;
  bool isAddEventPressed = false;
  bool isChooseCategoryPressed = false;

  late String newChannelName;
  late String newChannelCity;
  late String newChannelDescription;
  String? chosenCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddChannelPressed = !isAddChannelPressed;
                    isAddEventPressed = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add channel',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isAddChannelPressed
                      ? Colors.pinkAccent
                      : const Color(0xFF363636),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddEventPressed = !isAddEventPressed;
                    isAddChannelPressed = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add event',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isAddEventPressed
                      ? Colors.pinkAccent
                      : const Color(0xFF363636),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
          isAddChannelPressed
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LicheeTextField(
                        decoration: kAddChannelNameBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelName = text;
                          });
                        },
                      ),
                      LicheeTextField(
                        decoration: kAddChannelCityBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelCity = text;
                          });
                        },
                      ),
                      LicheeTextField(
                        decoration: kAddChannelDescriptionBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelDescription = text;
                          });
                        },
                        textInputType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            getAnswer();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'Choose category',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF363636),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'category:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          chosenCategory == '' || chosenCategory == null
                              ? const Text(
                                  'no category chosen',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  chosenCategory!,
                                  style: const TextStyle(color: Colors.white),
                                )
                        ],
                      )
                    ],
                  ),
                )
              : Container(),
          isAddEventPressed
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'add an event',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void getAnswer() async {
    var channelParentId = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 800,
                child: const CategoriesTreeView(
                  isChoosingCategoryForChannelAddingAvailable: true,
                )),
          ],
        );
      },
    );

    setState(() {
      chosenCategory = channelParentId;
    });
  }
}

class LicheeTextField extends StatefulWidget {
  const LicheeTextField({
    Key? key,
    required this.getText,
    required this.decoration,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  final Function(String text) getText;
  final TextInputType textInputType;
  final int? maxLines;
  final InputDecoration decoration;

  @override
  _LicheeTextFieldState createState() => _LicheeTextFieldState();
}

class _LicheeTextFieldState extends State<LicheeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF363636),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: (value) {
          widget.getText(value);
        },
        decoration: widget.decoration,
        maxLines: widget.maxLines,
      ),
    );
  }
}
