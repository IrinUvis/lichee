import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/models/user_data.dart';
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
  DateFormat dateformat = DateFormat('dd/MM/yyyy HH:mm');

  Future<UserData> loadUserData() async {
    return await Provider.of<AuthenticationProvider>(context, listen: false)
        .getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: loadUserData(),
        builder: (BuildContext context, AsyncSnapshot<UserData> snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePhotoScreen(),
                      ),
                    );
                  },
                  child: buildPhoto(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.grey[850],
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitle(userData.username!),
                      buildInfo(
                        "Username: ",
                        userData.username!,
                      ),
                      buildInfo(
                        "Email: ",
                        userData.email!,
                      ),
                      buildInfo(
                        "Creation date: ",
                        dateformat.format(
                          Provider.of<User?>(context)!.metadata.creationTime!,
                        ),
                      ),
                      buildInfo(
                        "Last sign in: ",
                        dateformat.format(
                          Provider.of<User?>(context)!.metadata.lastSignInTime!,
                        ),
                      ),
                    ],
                  ),
                ),
                buildSignOutButton(),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: LicheeColors.primary,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildInfo(String title, String info) {
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
          Text(info),
        ],
      ),
    );
  }

  Widget buildTitle(String username) {
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
                  builder: (context) => EditScreen(username: username),
                ),
              );
              setState(() {});
            },
            child: const Text(
              "Edit",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          )
        ],
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
              await Provider.of<AuthenticationProvider>(
                context,
                listen: false,
              ).signOut();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  Widget buildPhoto() {
    Widget img;
    if (Provider.of<User?>(context)!.photoURL != null) {
      img = Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(Provider.of<User?>(context)!.photoURL!),
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    } else {
      img = Icon(
        Icons.account_circle,
        color: Colors.white60,
        size: MediaQuery.of(context).size.height / 2.5,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: img,
    );
  }
}
