import 'package:flutter/material.dart';
import 'package:lichee/bloc/bloc.dart';
import 'package:lichee/bloc/provider.dart';

import 'loginScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Bloc bloc = Bloc();

  Widget build(context) {
    bloc = Provider.of(context);

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    bool isLoggedIn = false;
    try {
      print(bloc.isLoggedIn);
      isLoggedIn = bloc.isLoggedIn;
    } catch (e) {
      print("\n\n\n\n\n\n\n\nError bloccccc\n\n\n\n\n\n\n");
    }

    print(isLoggedIn);
    return Scaffold(
      body: SafeArea(
        child: isLoggedIn
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                height: deviceHeight,
                width: deviceWidth,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(bloc.email),
                      Text(bloc.userCredential.user!.uid)
                    ]))
            : buildLoginButton(),
      ),
    );
  }

  buildLoginButton() {
    return Center(
      child: Container(
        height: 60,
        margin: EdgeInsets.all(15),
        child: ElevatedButton(
            onPressed: () async {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()))
                  .then((value) => setState(() {}));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ))),
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height / 16,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ))),
      ),
    );
  }
}
