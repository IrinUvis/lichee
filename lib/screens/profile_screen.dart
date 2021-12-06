import 'package:flutter/material.dart';
import 'package:lichee/bloc/bloc.dart';
import 'package:lichee/bloc/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Bloc bloc = Bloc();

  Widget build(context) {
    bloc = Provider.of(context);
    String email = bloc.email;
    String uid = bloc.userCredential.user!.uid;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(email), Text(uid)]),
      )),
    );
  }
}
