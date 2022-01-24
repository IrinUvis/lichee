import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {
  final usernameEditingController = TextEditingController();
  bool _isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return Scaffold(
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
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getFirstNameField(user!),
                  buildButton(user, context),
                ],
              ),
            ),
          ),
        ));
  }

  Future submit(User user, String value) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await user.updateDisplayName(value);
    await user.reload();

    Navigator.pop(context);
  }

  Widget buildButton(User user, context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _isButtonEnabled
            ? () async => await submit(user, usernameEditingController.text)
            : null,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    side: BorderSide(color: Colors.red)))),
        child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: const Text("Submit")),
      ),
    );
  }

  TextFormField getFirstNameField(User user) {
    return TextFormField(
      onFieldSubmitted: (value) async {
        _isButtonEnabled = false;
        await submit(user, value);
      },
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
        hintText: user.displayName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
