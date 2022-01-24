import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/providers/authentication_provider.dart';
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
  User? user;

  @override
  Widget build(context) {
    user = Provider.of<User?>(context);

    return Scaffold(
      body: SafeArea(
        child: user != null ? const ProfileInfoScreen() : const AuthScreen(),
      ),
    );
  }
}
