import 'package:flutter/material.dart';
import 'package:lichee/bloc/bloc.dart';
import 'package:lichee/bloc/provider.dart';
import 'package:lichee/screens/profile_screen.dart';
import 'package:lichee/screens/registerScreen.dart';
import 'package:lichee/screens/tabs_screen.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
          buildTextFieldEmail(bloc, context),
          buildTextFieldPassword(bloc, context),
          buildLoginButton(bloc, context),
          buildSignInFlatButton(context)
        ]),
      )),
    );
  }

  Widget buildSignInFlatButton(context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            'Do you need an account?',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              navKey.currentState!.push(
                MaterialPageRoute(
                  builder: (context) => RegisterScreen(),
                ),
              );
            },
            child: Text('Register here!', style: kRegisterTextStyle),
          ),
        ],
      ),
    );
  }

  Widget buildLogo(BuildContext context, height) {
    return Padding(
      padding: EdgeInsets.only(bottom: height / 6),
      child: Center(
        child: Text(
          'Login',
          style: kLicheeTextStyle,
        ),
      ),
    );
  }

  Widget buildTextFieldEmail(Bloc bloc, context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
          stream: bloc.emailField,
          builder: (context, snapshot) {
            return TextField(
                autofocus: false,
                enableInteractiveSelection: true,
                onChanged: bloc.addEmail,
                decoration: InputDecoration(
                    hintText: 'example@email.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                    suffixIcon: Icon(Icons.email)));
          }),
    );
  }

  Widget buildLoginButton(Bloc bloc, context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () async {
          await bloc.login();
          if (bloc.isLoggedIn)
            navKey.currentState!.pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()));
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
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            )),
      ),
    );
  }

  Widget buildTextFieldPassword(Bloc bloc, context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: StreamBuilder(
          stream: bloc.passField,
          builder: (context, snapshot) {
            return TextField(
                obscureText: true,
                autofocus: false,
                enableInteractiveSelection: true,
                onChanged: bloc.addPass,
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
