import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';
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
  AddChannelScreenState createState() => AddChannelScreenState();
}

class AddChannelScreenState extends State<AddChannelScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  final _channelNameEditingController = TextEditingController();
  final _channelCityEditingController = TextEditingController();
  final _channelDescriptionEditingController = TextEditingController();

  late final AddChannelController addChannelController;

  File? _file;
  bool _isImageChosen = true;
  bool _isCategoryChosen = true;
  String _chosenCategoryId = '';
  String _chosenCategoryName = '';
  late final ImagePicker _imagePicker;

  late final TextFormField _channelNameField;
  late final TextFormField _channelCityField;
  late final TextFormField _channelDescriptionField;

  File? get file => _file;
  String get chosenCategoryId => _chosenCategoryId;
  String get chosenCategoryName => _chosenCategoryName;

  //ImagePicker get imagePicker => _imagePicker;

  set file(File? value) {
    setState(() {
      _file = value;
    });
  }
  set chosenCategoryId(String value) {
    setState(() {
      _chosenCategoryId = value;
    });
  }
  set chosenCategoryName(String value) {
    setState(() {
      _chosenCategoryName = value;
    });
  }

  @override
  void initState() {
    super.initState();
    addChannelController = AddChannelController(
      Provider.of<FirebaseProvider>(context, listen: false).firestore,
      Provider.of<FirebaseProvider>(context, listen: false).storage,
    );
    _focusNode = FocusNode();
    _imagePicker = widget.imagePicker;

    _channelNameField = _channelNameFieldF();
    _channelCityField = _channelCityFieldF();
    _channelDescriptionField = _channelDescriptionFieldF();
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
        ? _getAddChannelView()
        : NotLoggedInView(
            context: context,
            titleText: kAddingChannelsOrEventsUnavailable,
            buttonText: kLogInToAddChannelOrList,
          );
  }

  SafeArea _getAddChannelView() {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      kAddChannelTitleText,
                      const SizedBox(height: 30.0),
                      _getChannelData(),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        key: const Key('createButton'),
                        onPressed: _createChannel,
                        child: kCreateChannelButtonText,
                        style: kPinkRoundedButtonStyle,
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _getChannelData() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _channelNameField,
              const SizedBox(height: 20.0),
              _channelCityField,
              const SizedBox(height: 20.0),
              _channelDescriptionField,
              const SizedBox(height: 20.0),
              _file == null
                  ? ElevatedButton(
                      key: const Key('imageButton'),
                      onPressed: () => chooseImageFromGallery(),
                      style: kGreyRoundedButtonStyle,
                      child: kAddChannelImageButtonContent,
                    )
                  : _getPickedImage(),
              const SizedBox(height: 5.0),
              _isImageChosen ? Container() : kNoImageForChannelChosenText,
              const SizedBox(height: 20.0),
              _chosenCategoryId == ''
                  ? ElevatedButton(
                      key: const Key('categoryButton'),
                      onPressed: _chooseCategoryView,
                      child: kChooseCategoryButtonContent,
                      style: kGreyRoundedButtonStyle,
                    )
                  : _getChosenCategory(),
              const SizedBox(height: 5.0),
              _isCategoryChosen ? Container() : kNoCategoryForChannelChosenText,
            ],
          ),
        ),
      ],
    );
  }

  Column _getChosenCategory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          key: const Key('clearCategory'),
          onPressed: () => clearCategory(),
          icon: kCloseIcon,
        ),
        const SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            kCategoryChoosingCategoryText,
            const SizedBox(width: 15.0),
            Text(
              _chosenCategoryName,
              style: kChosenCategoryValidTextStyle,
            )
          ],
        ),
      ],
    );
  }

  Column _getPickedImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          key: const Key('clearImage'),
          onPressed: () => clearImage(),
          icon: kCloseIcon,
        ),
        const SizedBox(height: 5.0),
        Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.file(
              _file!,
            ),
          ),
        ),
      ],
    );
  }

  TextFormField _channelNameFieldF() {
    return TextFormField(
      key: const Key('nameField'),
      autofocus: false,
      controller: _channelNameEditingController,
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
      // onSaved: (value) {
      //   _channelNameEditingController.text = value!;
      // },
      textInputAction: TextInputAction.next,
      decoration: kAddChannelNameBarInputDecoration,
    );
  }

  TextFormField _channelCityFieldF() {
    return TextFormField(
      key: const Key('cityField'),
      autofocus: false,
      controller: _channelCityEditingController,
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
      // onSaved: (value) {
      //   _channelCityEditingController.text = value!;
      // },
      textInputAction: TextInputAction.next,
      decoration: kAddChannelCityBarInputDecoration,
    );
  }

  TextFormField _channelDescriptionFieldF() {
    return TextFormField(
      key: const Key('descriptionField'),
      autofocus: false,
      controller: _channelDescriptionEditingController,
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
      // onSaved: (value) {
      //   _channelDescriptionEditingController.text = value!;
      // },
      textInputAction: TextInputAction.done,
      decoration: kAddChannelDescriptionBarInputDecoration,
    );
  }

  Future<void> chooseImageFromGallery() async {
    FocusScope.of(context).unfocus();
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() => _file = image);
  }

  void clearImage() {
    setState(() => _file = null);
  }

  void clearCategory() {
    setState(() {
      _chosenCategoryId = '';
      _chosenCategoryName = '';
    });
  }

  void _chooseCategoryView() {
    FocusScope.of(context).unfocus();
    setState(() {
      _getCategoryForNewChannelScreen();
    });
  }

  void _getCategoryForNewChannelScreen() async {
    String? channelParentId = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SafeArea(
          child: Scaffold(
            appBar: AppBar(
                foregroundColor: LicheeColors.primary,
                backgroundColor: LicheeColors.appBarColor,
                title: kChooseCategoryScreenAppBarText),
            body: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CategoriesTreeView(
                  isChoosingCategoryForChannelAddingAvailable: true),
            ),
          ),
        ),
      ),
    );
    channelParentId ??= '';
    if (channelParentId != '') {
      _chosenCategoryName = await addChannelController.getCategoryNameById(
          channelParentId: channelParentId);
    }
    setState(() => _chosenCategoryId = channelParentId!);
  }

  Future<void> _createChannel() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      if (_file == null || _chosenCategoryId == '') {
        _checkIsImageAndCategoryChosen();
        return;
      } else {
        _checkIsImageAndCategoryChosen();
      }

      String? imageUrl;
      var uuid = const Uuid();
      DateTime now = DateTime.now();
      String city = _channelCityEditingController.text.capitalize();
      city = removeDiacritics(city);
      final myId = Provider.of<User?>(context, listen: false)!.uid;
      List<String> usersIds = [myId];

      try {
        imageUrl = await addChannelController.uploadPhoto(
            uuid: uuid.v1(), currentTime: now, file: _file!);
      } on FirebaseException catch (_) {
        Fluttertoast.showToast(
            msg: 'An unexpected error has occurred! Message wasn\'t sent');
      }

      addChannelController.addChannel(
          channelName: _channelNameEditingController.text,
          imageUrl: imageUrl!,
          city: city,
          now: now,
          description: _channelDescriptionEditingController.text,
          usersIds: usersIds,
          userId: myId,
          parentCategoryId: _chosenCategoryId);

      ScaffoldMessenger.of(context).showSnackBar(kChannelAddedSnackBar);

      _channelNameEditingController.clear();
      _channelCityEditingController.clear();
      _channelDescriptionEditingController.clear();
      setState(() {
        _chosenCategoryId = '';
        _chosenCategoryName = '';
        _isCategoryChosen = true;
        _file = null;
        _isImageChosen = true;
      });
    } else {
      _checkIsImageAndCategoryChosen();
    }
  }

  void _checkIsImageAndCategoryChosen() {
    _file == null ? _isImageChosen = false : _isImageChosen = true;
    _chosenCategoryId == ''
        ? _isCategoryChosen = false
        : _isCategoryChosen = true;
    setState(() {});
  }
}
