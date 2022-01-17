import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/auth/screens/auth_screen.dart';
import 'package:lichee/screens/profile/profilePhotoScreen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

@visibleForTesting
class ProfileScreenState extends State<ProfileScreen> {
  late NetworkImage _profilePhoto;
  bool notChanged = true;

  @override
  Widget build(context) {
    User? user = Provider.of<User?>(context);

    return Scaffold(
      body: SafeArea(
        child: user != null
            ? Column(children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePhotoScreen()));

                    setState(() {
                      user = Provider.of<AuthenticationProvider?>(context,
                              listen: false)!
                          .currentUser;
                      _profilePhoto = NetworkImage(user!.photoURL!);
                    });
                  },
                  child: buildPhoto(user, context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey[850],
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(context, "User Info"),
                      buildInfo(user!),
                    ],
                  ),
                ),
                buildSignOutButton(),
              ])
            : const AuthScreen(),
      ),
    );
  }

  Widget buildInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(user.displayName!), Text(user.email!)],
      ),
    );
  }

  Widget buildTitle(context, name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$name',
        style: TextStyle(
            fontSize: 20, color: Colors.grey[400], fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildSignOutButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[850],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Provider.of<AuthenticationProvider>(context,
                        listen: false)
                    .signOut();
              },
              child: const Text('Sign out'),
            ),
          ],
        ));
  }

  Widget buildPhoto(user, context) {
    Widget img;
    if (user.photoURL != null) {
      if (notChanged) {
        _profilePhoto = NetworkImage(user.photoURL);
        notChanged = !notChanged;
      }
      img = Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height / 3,
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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20), child: img);
  }
}
