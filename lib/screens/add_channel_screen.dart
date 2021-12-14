import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:provider/provider.dart';
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
                child: kAddChannelButtonText,
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
                      ),
                      ElevatedButton(
                        onPressed: _createChannel,
                        child: kCreateChannelButtonText,
                        style: kCategoriesTreeViewButtonStyle,
                      ),
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
      _getCategoryForNewChannelDialog();
    });
  }

  void _getCategoryForNewChannelDialog() async {
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

  Future<void> _createChannel() async {
    CollectionReference channels =
        FirebaseFirestore.instance.collection('channels');
    DateTime now = DateTime.now();
    List<String> usersIds = List.empty();
    final newChannel = await channels.add({
      'channelName': newChannelName,
      'channelImageURL':
          'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill',
      'city': newChannelCity,
      'createdOn': DateTime(now.year, now.month, now.day),
      'description': newChannelDescription,
      'userIds': usersIds,
      'ownerId': Provider.of<User?>(context, listen: false)!.uid,
      'parentCategoryId': chosenCategory,
    });

    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    List<String> childrenIds = List.empty();
    final newCategory = await categories.doc(newChannel.id).set({
      'name': newChannelName,
      'type': 'channel',
      'parentId': chosenCategory,
      'childrenIds': childrenIds,
      'isLastCategory': false,
    });

    // get parent category of newly created channel in order to read its
    // array of children ids. This array will be extended by another id
    // (newChannel.id). Then, the parent category will be updated with
    // new list of children ids.
    final parentCategory = await categories.doc(chosenCategory).get();
    Map<String, dynamic> parentCategoryMap =
        parentCategory.data() as Map<String, dynamic>;
    List<String> childrenIdList = List.from(parentCategoryMap['childrenIds']);
    childrenIdList.add(newChannel.id);
    await categories.doc(chosenCategory).update({
      'childrenIds': childrenIdList,
    });
  }
}
