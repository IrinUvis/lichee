import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/screens/auth/auth_type.dart';
import 'package:provider/provider.dart';

import '../auth/screens/not_logged_in_view.dart';
import '../channel_list/categories_tree_view.dart';

class AddChannelScreen extends StatefulWidget {
  const AddChannelScreen({Key? key}) : super(key: key);

  @override
  _AddChannelScreenState createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  bool isAddChannelPressed = false;
  bool isAddEventPressed = false;
  bool isCategoryEmpty = true;
  String chosenCategoryId = '';
  String chosenCategoryName = '';

  final _formKey = GlobalKey<FormState>();
  final channelNameEditingController = TextEditingController();
  final cityEditingController = TextEditingController();
  final channelDescriptionEditingController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  //TODO add possibility to upload channel image
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user != null
        ? getAddThingView()
        : NotLoggedInView(
            context: context,
            titleText: kAddingChannelsOrEventsUnavailable,
            buttonText: kLogInToAddChannelOrList,
          );
  }

  Scaffold getAddThingView() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        getChannelData(),
                        const SizedBox(height: 50),
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
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
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
              const SizedBox(height: 50),
              channelNameField,
              const SizedBox(height: 50),
              cityField,
              const SizedBox(height: 50),
              channelDescriptionField,
              const SizedBox(height: 50),
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
    FocusScope.of(context).unfocus();
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

    channelParentId ??= '';

    if (channelParentId != '') {
      CollectionReference categories =
          FirebaseFirestore.instance.collection('categories');
      final parentCategory = await categories.doc(channelParentId).get();
      Map<String, dynamic> parentCategoryMap =
          parentCategory.data() as Map<String, dynamic>;
      String channelParentName = parentCategoryMap['name'];

      chosenCategoryName = channelParentName;
    }

    setState(() {
      isCategoryEmpty = false;
      chosenCategoryId = channelParentId;
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
      String city = cityEditingController.text.capitalize();
      city = removeDiacritics(city);
      DateTime now = DateTime.now();
      final myId = Provider.of<User?>(context, listen: false)!.uid;
      List<String> usersIds = [myId];
      final newChannel = await channels.add({
        'channelName': channelNameEditingController.text,
        'channelImageURL':
            'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill',
        'city': city,
        'createdOn': DateTime(now.year, now.month, now.day),
        'description': channelDescriptionEditingController.text,
        'userIds': usersIds,
        'ownerId': myId,
        'parentCategoryId': chosenCategoryId,
      });

      CollectionReference channelChats =
          FirebaseFirestore.instance.collection('channel_chats');
      await channelChats.doc(newChannel.id).set(ChannelChatData(
          channelId: newChannel.id,
          channelName: channelNameEditingController.text,
          photoUrl: 'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill',
          userIds: usersIds).toMap());

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

      ScaffoldMessenger.of(context).showSnackBar(kChannelAddedSnackBar);

      channelNameEditingController.clear();
      cityEditingController.clear();
      channelDescriptionEditingController.clear();
    }
  }
}
