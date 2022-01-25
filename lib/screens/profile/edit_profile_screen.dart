import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final String username;

  const EditScreen({Key? key, required this.username}) : super(key: key);

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool inAsyncCall = false;

  final usernameEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.pinkAccent,
      opacity: 0.1,
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 60.0,
          elevation: 0.0,
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Center(
            child: Text(
              'Lichee',
              style: kLicheeTextStyle,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  getFirstNameField(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  getPasswordField(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  getSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        toggleInAsyncCall();
      });
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        final user = Provider.of<User?>(context, listen: false)!;
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signIn(
          email: user.email!,
          password: passwordEditingController.text,
        );
        await user.updateDisplayName(usernameEditingController.text);
        final firestore =
            Provider.of<FirebaseProvider>(context, listen: false).firestore;
        final QuerySnapshot<Map<String, dynamic>> users = await firestore
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .get();
        for (var doc in users.docs) {
          await firestore.collection('users').doc(doc.id).update({
            'username': usernameEditingController.text,
          });
        }
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .signIn(
          email: user.email!,
          password: passwordEditingController.text,
        );
        final userChats = await firestore
            .collection('channel_chats')
            .where('recentMessageSentByUserId', isEqualTo: user.uid)
            .get();
        for (var chatDoc in userChats.docs) {
          firestore
              .collection('channel_chats')
              .doc(chatDoc.id)
              .update({'recentMessageSentBy': usernameEditingController.text});
          final usersMessagesInChat = await firestore
              .collection('channel_messages/${chatDoc.id}/messages')
              .where('idSentBy', isEqualTo: user.uid)
              .get();
          for (var messageDoc in usersMessagesInChat.docs) {
            firestore
                .collection('channel_messages/${chatDoc.id}/messages')
                .doc(messageDoc.id)
                .update({'nameSentBy': usernameEditingController.text});
          }
        }
        setState(() {
          toggleInAsyncCall();
        });
        Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        String? errorMessage;
        switch (error.code) {
          case 'wrong-password':
            errorMessage = 'Your password is wrong.';
            break;
          case 'user-disabled':
            errorMessage = 'User with this email has been disabled.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many requests.';
            break;
          default:
            errorMessage = 'An unexpected error has occurred.';
        }
        Fluttertoast.showToast(msg: errorMessage);
      } finally {
        if (inAsyncCall == true) {
          setState(() {
            setState(() {
              inAsyncCall = false;
            });
          });
        }
      }
    }
  }

  Material getSubmitButton() {
    return Material(
      key: const Key('authorizeButton'),
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.pinkAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => submit(),
        child: const Text(
          'Change username',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  TextFormField getPasswordField() {
    return TextFormField(
      key: const Key('passwordField'),
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm with password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  TextFormField getFirstNameField() {
    return TextFormField(
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: widget.username,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void toggleInAsyncCall() {
    inAsyncCall = !inAsyncCall;
  }
}
