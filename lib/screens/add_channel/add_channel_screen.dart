import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_channel/add_channel_controller.dart';
import 'package:lichee/screens/auth/auth_type.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../auth/screens/not_logged_in_view.dart';
import '../channel_list/categories_tree_view.dart';

class AddChannelScreen extends StatefulWidget {
  final ImagePicker imagePicker;

  const AddChannelScreen({Key? key, required this.imagePicker})
      : super(key: key);

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
  final channelCityEditingController = TextEditingController();
  final channelDescriptionEditingController = TextEditingController();
  late FocusNode _focusNode;

  late final AddChannelController _addChannelController;
  File? _file;
  late final ImagePicker _imagePicker;

  //File? get file => _file;

  //ImagePicker get imagePicker => _imagePicker;

  // set file(File? value) {
  //   setState(() {
  //     _file = value;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _addChannelController = AddChannelController(
      Provider.of<FirebaseProvider>(context, listen: false).firestore,
      Provider.of<FirebaseProvider>(context, listen: false).storage,
    );
    _focusNode = FocusNode();
    _imagePicker = widget.imagePicker;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10.0),
                  Text('Add channel',
                      style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                  getChannelData(),
                  const SizedBox(height: 25.0),
                  ElevatedButton(
                    onPressed: _createChannel,
                    child: kCreateChannelButtonText,
                    style: kPinkRoundedButtonStyle,
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            )
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

    final channelCityField = TextFormField(
      autofocus: false,
      controller: channelCityEditingController,
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
        channelCityEditingController.text = value!;
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
              const SizedBox(height: 25.0),
              channelNameField,
              const SizedBox(height: 25.0),
              channelCityField,
              const SizedBox(height: 25.0),
              channelDescriptionField,
              const SizedBox(height: 25.0),
            ],
          ),
        ),
        Column(
          children: [
            _file == null
                ? ElevatedButton(
                    onPressed: () => chooseImageFromGallery(),
                    style: kGreyRoundedButtonStyle,
                    child: kAddChannelImageButtonContent,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(left: 10.0),
                        onPressed: () => clearImage(),
                        icon: const Icon(
                          Icons.close_outlined,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.file(
                            _file!,
                          ),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _chooseCategoryView,
              child: kChooseCategoryButtonContent,
              style: kGreyRoundedButtonStyle,
            ),
            chosenCategoryName != ''
                ? Column(
                    children: [
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

  @visibleForTesting
  Future<void> chooseImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _file = image;
    });
  }

  @visibleForTesting
  void clearImage() {
    setState(() {
      _file = null;
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
      chosenCategoryName = await _addChannelController.getCategoryNameById(
          channelParentId: channelParentId);
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
      String? imageUrl;
      var uuid = const Uuid();
      DateTime now = DateTime.now();
      String city = channelCityEditingController.text.capitalize();
      city = removeDiacritics(city);
      final myId = Provider.of<User?>(context, listen: false)!.uid;
      List<String> usersIds = [myId];

      if (_file == null) {
        imageUrl =
            'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill';
      }
      if (_file != null) {
        try {
          imageUrl = await _addChannelController.uploadPhoto(
              uuid: uuid.v1(), currentTime: now, file: _file!);
          setState(() {
            _file = null;
          });
        } on FirebaseException catch (_) {
          Fluttertoast.showToast(
              msg: 'An unexpected error has occurred! Message wasn\'t sent');
        }
      }

      _addChannelController.addChannel(
          channelName: channelNameEditingController.text,
          imageUrl: imageUrl!,
          city: city,
          now: now,
          description: channelDescriptionEditingController.text,
          usersIds: usersIds,
          userId: myId,
          parentCategoryId: chosenCategoryId);

      ScaffoldMessenger.of(context).showSnackBar(kChannelAddedSnackBar);

      channelNameEditingController.clear();
      channelCityEditingController.clear();
      channelDescriptionEditingController.clear();
      setState(() {
        chosenCategoryId = '';
      });
    }
  }
}
