import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({Key? key}) : super(key: key);

  @override
  ProfilePhotoScreenState createState() => ProfilePhotoScreenState();
}

class ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  late final ImagePicker _imagePicker = ImagePicker();
  late StorageService _storageService;
  late NetworkImage _profilePhoto;
  double buttonOpacity = 0;
  bool notChanged = true;

  Widget buttonContent = const Text(
    'Choose a pic',
    style: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  );

  @override
  Widget build(context) {
    User? user = Provider.of<AuthenticationProvider?>(context)!.currentUser;
    _storageService = Provider.of<FirebaseProvider?>(context)!.storage;

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPhoto(user, context),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  buildButton(user, context),
                  Container(
                    height: 20,
                  ),
                  buildChangeButton(user, context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPhoto(user, context) {
    Widget img;
    if (user.photoURL != null) {
      if (notChanged) {
        _profilePhoto = NetworkImage(user.photoURL);
        notChanged = !notChanged;
      }

      img = Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.height / 2.5,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: _profilePhoto, fit: BoxFit.fitWidth)),
      );
    } else {
      img = Icon(
        Icons.account_circle,
        color: Colors.white60,
        size: MediaQuery.of(context).size.height / 2.5,
      );
    }
    return Container(child: img);
  }

  Widget buildButton(user, context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: buttonContent is Icon
            ? () {
                Navigator.pop(context);
              }
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
                            Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white),
                            TextButton(
                              onPressed: () => getCameraImage(user, context),
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('Camera',
                                          style:
                                              TextStyle(color: Colors.white)))
                                ],
                              ),
                            ),
                            Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white),
                            TextButton(
                              onPressed: () => getGalleryImage(user, context),
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.photo_size_select_actual,
                                      color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text('Gallery',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ],
                              ),
                            ),
                            Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white),
                          ],
                        ),
                      );
                    });
              },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    side: BorderSide(color: Colors.red)))),
        child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: buttonContent),
      ),
    );
  }

  Widget buildChangeButton(user, context) {
    return Opacity(
      opacity: buttonOpacity,
      child: SizedBox(
        height: 60,
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
                              Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white),
                              TextButton(
                                onPressed: () => getCameraImage(user, context),
                                child: Row(
                                  children: const <Widget>[
                                    Icon(Icons.camera_alt, color: Colors.white),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text('Camera',
                                            style:
                                                TextStyle(color: Colors.white)))
                                  ],
                                ),
                              ),
                              Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white),
                              TextButton(
                                onPressed: () => getGalleryImage(user, context),
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
                              Container(
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white),
                            ],
                          ),
                        );
                      });
                },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      side: BorderSide(color: Colors.red)))),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: const Text(
              'Change',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Future getCameraImage(User user, context) async {
    Navigator.pop(context);

    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    File file = File(image!.path);

    String url = await _storageService.uploadFile(
        path: "profilePhotos/${user.uid}/", file: file);

    await user.updatePhotoURL(url);
    await user.reload();

    setState(() {
      _profilePhoto = NetworkImage(url);

      buttonContent = const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      );
      buttonOpacity = 1;
    });
  }

  Future getGalleryImage(User user, context) async {
    Navigator.pop(context);

    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);

    String url = await _storageService.uploadFile(
        path: "profilePhotos/${user.uid}", file: file);

    setState(() {
      user.updatePhotoURL(url);
      user.reload();

      buttonContent = const Icon(
        Icons.arrow_forward,
        color: Colors.white,
      );
      buttonOpacity = 1;
    });
  }
}
