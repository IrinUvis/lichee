import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/auth/screens/auth_screen.dart';
import 'package:lichee/screens/profile/profile_info_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

@visibleForTesting
class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      body: SafeArea(
        child: Provider.of<User?>(context) != null
            ? const ProfileInfoScreen()
            : const AuthScreen(),
      ),
    );
  }
}
