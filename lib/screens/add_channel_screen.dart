import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'channel_list/categories_tree_view.dart';
import 'channel_list/lichee_text_field.dart';

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
                onPressed: _addChannelView,
                child: kChooseCategoryButtonText,
                style: isAddChannelPressed
                    ? kCategoriesTreeViewButtonStyle
                    : kCategoriesTreeViewInactiveButtonStyle,
              ),
              ElevatedButton(
                onPressed: _addEventView,
                child: kAddEventButtonText,
                style: isAddChannelPressed
                    ? kCategoriesTreeViewButtonStyle
                    : kCategoriesTreeViewInactiveButtonStyle,
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
                        onPressed: _chooseCategoryView,
                        child: kChooseCategoryButtonText,
                        style: kCategoriesTreeViewInactiveButtonStyle,
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

  void _addChannelView() {
    setState(() {
      isAddChannelPressed = !isAddChannelPressed;
      isAddEventPressed = false;
    });
  }

  void _addEventView() {
    setState(() {
      isAddEventPressed = !isAddEventPressed;
      isAddChannelPressed = false;
    });
  }

  void _chooseCategoryView() {
    setState(() {
      getCategoryForNewChannelDialog();
    });
  }

  void getCategoryForNewChannelDialog() async {
    var channelParentId = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 600,
              child: const CategoriesTreeView(
                isChoosingCategoryForChannelAddingAvailable: true,
              ),
            ),
          ],
        );
      },
    );
    setState(() {
      chosenCategory = channelParentId;
    });
  }
}


