import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/components/logo.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../providers/authentication_provider.dart';
import '../auth_type.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();
  DateTime? selectedDateOfBirth;

  String? errorMessage;
  bool inAsyncCall = false;
  AuthType authType = AuthType.login;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.pinkAccent,
      opacity: 0.1,
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36.0,
                vertical: 10,
              ),
              child: getAppropriateForm(),
            ),
          ),
        ),
      ),
    );
  }

  Form getAppropriateForm() {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: usernameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('Username cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid username (min. 3 characters)');
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Your username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please enter your email');
        }
        if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
          return ('Please enter a valid email');
        }
        return null;
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final dateOfBirthField = DateTimeField(
      validator: (value) {
        if (value == null) {
          return ('Please enter your date of birth');
        }
        return null;
      },
      format: DateFormat('yyyy-MM-dd'),
      onShowPicker: (context, currentValue) async {
        DateTime? chosenDate = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        selectedDateOfBirth = chosenDate;
        return selectedDateOfBirth;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.date_range),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Date of birth',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ('Please enter your password');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid password (min. 6 characters)');
        }
      },
      onSaved: (value) {
        usernameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return 'Passwords don\'t match';
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final authorizeButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pinkAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:
            authType == AuthType.register ? () => signUp() : () => signIn(),
        child: Text(
          authType == AuthType.register ? 'Sign up' : 'Log in',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final authTypeChanger = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        authType == AuthType.register
            ? const Text('Already have an account? ')
            : const Text('Don\'t have an account? '),
        GestureDetector(
          onTap: () {
            setState(() {
              authType = authType == AuthType.register
                  ? AuthType.login
                  : AuthType.register;
            });
          },
          child: Text(
            authType == AuthType.register ? 'Log in' : 'Sign up',
            style: const TextStyle(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: authType == AuthType.register
            ? <Widget>[
                const SizedBox(height: 40),
                Logo(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  radius: 20.0,
                  authType: authType,
                ),
                const SizedBox(height: 30),
                firstNameField,
                const SizedBox(height: 20),
                emailField,
                const SizedBox(height: 20),
                dateOfBirthField,
                const SizedBox(height: 20),
                passwordField,
                const SizedBox(height: 20),
                confirmPasswordField,
                const SizedBox(height: 20),
                authorizeButton,
                const SizedBox(height: 15),
                authTypeChanger,
              ]
            : <Widget>[
                const SizedBox(height: 40),
                Logo(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  radius: 20.0,
                  authType: authType,
                ),
                const SizedBox(height: 30),
                emailField,
                const SizedBox(height: 20),
                passwordField,
                const SizedBox(height: 20),
                authorizeButton,
                const SizedBox(height: 15),
                authTypeChanger,
              ],
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => toggleInAsyncCall());
      try {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signUp(
          userData: UserData(
            username: usernameEditingController.text.trim(),
            email: emailEditingController.text.trim(),
            photoUrl: 'none',
            dateOfBirth: selectedDateOfBirth!,
          ),
          password: passwordEditingController.text.trim(),
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Your email address appears to be malformed.';
            break;
          case 'wrong-password':
            errorMessage = 'Your password is wrong.';
            break;
          case 'user-not-found':
            errorMessage = 'User with this email doesn\'t exist.';
            break;
          case 'user-disabled':
            errorMessage = 'User with this email has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Signing in with email and password is not enabled.';
            break;
          default:
            errorMessage = 'An undefined error has occurred.';
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
      setState(() => toggleInAsyncCall());
    }
  }

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => toggleInAsyncCall());
      try {
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signIn(
          email: emailEditingController.text.trim(),
          password: passwordEditingController.text.trim(),
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = 'Your email address appears to be malformed.';
            break;
          case 'wrong-password':
            errorMessage = 'Your password is wrong.';
            break;
          case 'user-not-found':
            errorMessage = 'User with this email doesn\'t exist.';
            break;
          case 'user-disabled':
            errorMessage = 'User with this email has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Signing in with email and password is not enabled.';
            break;
          default:
            errorMessage = 'An undefined error has occurred.';
        }
        Fluttertoast.showToast(msg: errorMessage!);
      }
      setState(() => toggleInAsyncCall());
    }
  }

  void toggleInAsyncCall() {
    inAsyncCall = !inAsyncCall;
  }
}
