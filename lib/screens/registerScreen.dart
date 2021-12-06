import 'package:flutter/material.dart';
import 'package:lichee/bloc/bloc.dart';
import 'package:lichee/bloc/provider.dart';
import 'package:lichee/screens/profile_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';

import '../constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool validFields = false;
  Bloc bloc = Bloc();
  Widget build(context) {
    bloc = Provider.of(context);
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        height: deviceHeight,
        width: deviceWidth,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          buildLogo(context, deviceHeight),
          buildTextFieldEmail(context),
          buildTextFieldPassword(context),
          buildTextFieldConfirmedPassword(context),
          buildRegisterButton(context)
        ]),
      )),
    );
  }

  Widget buildLogo(BuildContext context, height) {
    return Padding(
      padding: EdgeInsets.only(bottom: height / 6),
      child: Center(
        child: Text(
          'Register',
          style: kLicheeTextStyle,
        ),
      ),
    );
  }

  Widget buildTextFieldEmail(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
          stream: bloc.emailField,
          builder: (context, snapshot) {
            return TextField(
                autofocus: false,
                onChanged: (string) {
                  bloc.addEmail(string);
                  setState(() {
                    if (snapshot.error == null)
                      validFields = false;
                    else
                      validFields = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'example@plug.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  suffixIcon: Icon(Icons.email),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                ));
          }),
    );
  }

  Widget buildRegisterButton(context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: validFields
            ? () async {
                if (await bloc.register()) Navigator.pop(context);
              }
            : null,
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
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            )),
      ),
    );
  }

  Widget buildTextFieldPassword(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
          stream: bloc.passField,
          builder: (context, snapshot) {
            return TextField(
                obscureText: true,
                autofocus: false,
                enableInteractiveSelection: true,
                onChanged: (string) {
                  bloc.addPass(string);
                  setState(() {
                    if (snapshot.error == null)
                      validFields = false;
                    else
                      validFields = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  suffixIcon: Icon(Icons.password),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                ));
          }),
    );
  }

  Widget buildTextFieldConfirmedPassword(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
          stream: bloc.confPassField,
          builder: (context, snapshot) {
            return TextField(
                obscureText: true,
                autofocus: false,
                enableInteractiveSelection: true,
                onChanged: (string) {
                  bloc.addConfPass(string);
                  setState(() {
                    if (snapshot.error == null)
                      validFields = false;
                    else
                      validFields = true;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  suffixIcon: Icon(Icons.password),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                ));
          }),
    );
  }
}
