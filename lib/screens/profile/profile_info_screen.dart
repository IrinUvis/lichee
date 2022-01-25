import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/profile/profile_photo_screen.dart';
import 'package:provider/provider.dart';

import 'edit_profile_screen.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({Key? key}) : super(key: key);

  @override
  ProfileInfoScreenState createState() => ProfileInfoScreenState();
}

class ProfileInfoScreenState extends State<ProfileInfoScreen> {
  User? user;
  DateFormat dateformat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthenticationProvider?>(context)!.currentUser;

    return Column(children: [
      GestureDetector(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfilePhotoScreen()));

          setState(() {});
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
            buildTitle(context),
            buildInfo("Username: ", user?.displayName),
            buildInfo("Email: ", user?.email),
            buildInfo("Creation date: ",
                dateformat.format(user!.metadata.creationTime!)),
            buildInfo("Last sign in: ",
                dateformat.format(user!.metadata.lastSignInTime!)),
          ],
        ),
      ),
      buildSignOutButton(),
    ]);
  }

  Widget buildInfo(String title, String? info) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(info ?? "Loading"),
          ],
        ));
  }

  Widget buildTitle(context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "User Info",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditScreen()));
                  setState(() {});
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(decoration: TextDecoration.underline),
                ))
          ],
        ));
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
                setState(() {});
              },
              child: const Text('Sign out'),
            ),
          ],
        ));
  }

  Widget buildPhoto(User? user, context) {
    Widget img;

    if (user?.photoURL != null) {
      img = Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(user!.photoURL!), fit: BoxFit.fitWidth)),
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
