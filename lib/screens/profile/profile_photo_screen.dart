import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';

class ProfilePhotoScreen extends StatefulWidget {
  ProfilePhotoScreen({Key? key, required this.userData}) : super(key: key);
  UserData userData;

  @override
  ProfilePhotoScreenState createState() => ProfilePhotoScreenState();
}

class ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  late StorageService _storageService;
  late NetworkImage _profilePhoto;
  double buttonOpacity = 0;
  bool notChanged = true;
  late String photoUrl;
  late bool isNull;

  Widget buttonContent = const Text(
    'Choose new picture',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );

  Future<void> setUserPicture(
      User user, FirebaseFirestore fs, String url) async {
    final users =
        await fs.collection('users').where('id', isEqualTo: user.uid).get();
    final userId = users.docs[0].id;
    await fs.collection('users').doc(userId).update({'photoUrl': url});
    isNull = !isNull;
  }

  @override
  Widget build(context) {
    User? user = Provider.of<AuthenticationProvider?>(context)!.currentUser;
    _storageService = Provider.of<FirebaseProvider?>(context)!.storage;
    isNull = widget.userData.photoUrl!.isEmpty;
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildPhoto(widget.userData.photoUrl ?? '', context),
                Container(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      buildChoosePictureButton(user),
                      Container(height: 20),
                      buildDeletePictureAndReturnButton(user, false),
                      Container(height: 20),
                      buildSaveAndReturn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSaveAndReturn() {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height / 16,
        ),
        alignment: Alignment.center,
        child: const Text('Save and return', style: TextStyle(fontSize: 16)),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(LicheeColors.primary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            side: BorderSide(color: LicheeColors.primary),
          ),
        ),
      ),
    );
  }

  Widget buildPhoto(String photoUrl, context) {
    Widget profilePictureWidget;
    if (photoUrl.isNotEmpty) {
      if (notChanged) {
        _profilePhoto = NetworkImage(photoUrl);
        notChanged = !notChanged;
      }
      profilePictureWidget = CircleAvatar(
          radius: MediaQuery.of(context).size.height / 5.0,
          backgroundImage: _profilePhoto,
          backgroundColor: Colors.transparent);
    } else {
      profilePictureWidget = Icon(
        Icons.account_circle,
        color: Colors.white60,
        size: MediaQuery.of(context).size.height / 2.5,
      );
    }
    return profilePictureWidget;
  }

  Widget buildDeletePictureAndReturnButton(user, bool isNull) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isNull
            ? null
            : () async {
                final users =
                    await Provider.of<FirebaseProvider>(context, listen: false)
                        .firestore
                        .collection('users')
                        .where('id', isEqualTo: user.uid)
                        .get();
                final userId = users.docs[0].id;
                await Provider.of<FirebaseProvider>(context, listen: false)
                    .firestore
                    .collection('users')
                    .doc(userId)
                    .update({'photoUrl': ''});
                Navigator.pop(context);
              },
        style: ButtonStyle(
          backgroundColor: isNull
              ? MaterialStateProperty.all<Color>(LicheeColors.disabledButton)
              : MaterialStateProperty.all<Color>(LicheeColors.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height / 16,
          ),
          alignment: Alignment.center,
          child:
              const Text('Delete and return', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget buildChoosePictureButton(user) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.grey[800],
                  title: const Text(
                    'Select route',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => getImage(
                            user,
                            true,
                            Provider.of<FirebaseProvider>(context,
                                    listen: false)
                                .firestore),
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.camera_alt, color: Colors.white),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Camera',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 0.7,
                        width: MediaQuery.of(context).size.width,
                        color: LicheeColors.disabledButton,
                      ),
                      TextButton(
                        onPressed: () => getImage(
                            user,
                            false,
                            Provider.of<FirebaseProvider>(context,
                                    listen: false)
                                .firestore),
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.photo_size_select_actual,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Gallery',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(LicheeColors.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(color: LicheeColors.primary),
            ),
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height / 16,
          ),
          alignment: Alignment.center,
          child:
              const Text('Choose new picture', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget buildChangeButton(user, context) {
    return Opacity(
      opacity: buttonOpacity,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: buttonOpacity == 0
              ? null
              : () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[800],
                          title: const Text('Select route',
                              style: TextStyle(color: Colors.white)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextButton(
                                onPressed: () => getImage(
                                    user,
                                    true,
                                    Provider.of<FirebaseProvider>(context,
                                            listen: false)
                                        .firestore),
                                child: Row(
                                  children: const <Widget>[
                                    Icon(Icons.camera_alt, color: Colors.white),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Camera',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 0.7,
                                width: MediaQuery.of(context).size.width,
                                color: LicheeColors.disabledButton,
                              ),
                              TextButton(
                                onPressed: () => getImage(
                                    user,
                                    false,
                                    Provider.of<FirebaseProvider>(context,
                                            listen: false)
                                        .firestore),
                                child: Row(
                                  children: const <Widget>[
                                    Icon(Icons.photo_size_select_actual,
                                        color: Colors.white),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Gallery',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(LicheeColors.primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                side: BorderSide(color: LicheeColors.primary),
              ),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Change picture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(User user, bool isFromCamera, FirebaseFirestore fs) async {
    Navigator.pop(context);
    XFile? image;
    File file;
    String url;
    if (isFromCamera) {
      image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );
    } else {
      image = await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(kProfilePictureBeingLoadedSnackBar);
    try {
      file = File(image!.path);
      url = await _storageService.uploadFile(
        path: "profilePhotos/${user.uid}/",
        file: file,
      );
      await setUserPicture(user, fs, url);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(kProfilePictureLoadedSnackBar);
      setState(() {
        _profilePhoto = NetworkImage(url);
      });
      if (!isNull) {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
}
