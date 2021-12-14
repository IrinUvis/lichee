import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:provider/provider.dart';
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
  bool isCategoryEmpty = true;
  late String newChannelName;
  late String newChannelCity;
  late String newChannelDescription;
  String chosenCategoryId = '';
  String chosenCategoryName = '';

  final _formKey = GlobalKey<FormState>();
  final channelNameEditingController = TextEditingController();
  final cityEditingController = TextEditingController();
  final channelDescriptionEditingController = TextEditingController();

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
                style: isAddEventPressed
                    ? kCategoriesTreeViewButtonStyle
                    : kCategoriesTreeViewInactiveButtonStyle,
              ),
            ],
          ),
          isAddChannelPressed
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getChannelData(),
                        ElevatedButton(
                          onPressed: _createChannel,
                          child: kCreateChannelButtonText,
                          style: kCategoriesTreeViewButtonStyle,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          isAddEventPressed
              ? const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        'add an event',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Column getChannelData() {
    final channelNameField = TextFormField(
      autofocus: false,
      controller: channelNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('Channel name cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid channel name (min. 3 characters)');
        }
        return null;
      },
      onSaved: (value) {
        channelNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddChannelNameBarInputDecoration,
    );

    final cityField = TextFormField(
      autofocus: false,
      controller: cityEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('City cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid city (min. 3 characters)');
        }
        return null;
      },
      onSaved: (value) {
        cityEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddChannelCityBarInputDecoration,
    );

    final channelDescriptionField = TextFormField(
      autofocus: false,
      controller: channelDescriptionEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        RegExp regex = RegExp(r'^.{20,}$');
        if (value!.isEmpty) {
          return ('Channel description cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid channel description (min. 20 characters)');
        }
        return null;
      },
      onSaved: (value) {
        channelDescriptionEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: kAddChannelDescriptionBarInputDecoration,
    );

    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 30),
              channelNameField,
              const SizedBox(height: 30),
              cityField,
              const SizedBox(height: 30),
              channelDescriptionField,
              const SizedBox(height: 30),
            ],
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: _chooseCategoryView,
              child: kChooseCategoryButtonText,
              style: kCategoriesTreeViewInactiveButtonStyle,
            ),
            chosenCategoryName != ''
                ? Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          kCategoryChoosingCategoryText,
                          const SizedBox(width: 15.0),
                          Text(
                            chosenCategoryName,
                            style: isCategoryEmpty
                                ? kChosenCategoryInvalidTextStyle
                                : kChosenCategoryValidTextStyle,
                          )
                        ],
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ],
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

    CollectionReference categories =
        FirebaseFirestore.instance.collection('categories');
    final parentCategory = await categories.doc(channelParentId).get();
    Map<String, dynamic> parentCategoryMap =
        parentCategory.data() as Map<String, dynamic>;
    String channelParentName = parentCategoryMap['name'];

    setState(() {
      isCategoryEmpty = false;
      chosenCategoryId = channelParentId;
      chosenCategoryName = channelParentName;
    });
  }

  Future<void> _createChannel() async {
    if (_formKey.currentState!.validate()) {
      if (chosenCategoryId == '') {
        setState(() {
          isCategoryEmpty = true;
          chosenCategoryName = 'Category cannot be empty';
        });
        return;
      }

      CollectionReference channels =
          FirebaseFirestore.instance.collection('channels');
      DateTime now = DateTime.now();
      List<String> usersIds = List.empty();
      final newChannel = await channels.add({
        'channelName': channelNameEditingController.text,
        'channelImageURL':
            'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill',
        'city': cityEditingController.text,
        'createdOn': DateTime(now.year, now.month, now.day),
        'description': channelDescriptionEditingController.text,
        'userIds': usersIds,
        'ownerId': '1', //Provider.of<User?>(context, listen: false)!.uid,
        'parentCategoryId': chosenCategoryId,
      });

      CollectionReference categories =
          FirebaseFirestore.instance.collection('categories');
      List<String> childrenIds = List.empty();
      await categories.doc(newChannel.id).set({
        'name': channelNameEditingController.text,
        'type': 'channel',
        'parentId': chosenCategoryId,
        'childrenIds': childrenIds,
        'isLastCategory': false,
      });

      // get parent category of newly created channel in order to read its
      // array of children ids. This array will be extended by another id
      // (newChannel.id). Then, the parent category will be updated with
      // new list of children ids.
      final parentCategory = await categories.doc(chosenCategoryId).get();
      Map<String, dynamic> parentCategoryMap =
          parentCategory.data() as Map<String, dynamic>;
      List<String> childrenIdList = List.from(parentCategoryMap['childrenIds']);
      childrenIdList.add(newChannel.id);
      await categories.doc(chosenCategoryId).update({
        'childrenIds': childrenIdList,
      });
    }
  }
}
