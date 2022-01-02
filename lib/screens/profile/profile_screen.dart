import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/auth/screens/auth_screen.dart';
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
    final user = Provider.of<User?>(context);
    return Scaffold(
      body: SafeArea(
        child: user != null
            ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(user.email!),
                      Text(user.uid),
                      TextButton(
                        onPressed: () async {
                          await Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .signOut();
                        },
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
              )
            : const AuthScreen(),
      ),
    );
  }
}
