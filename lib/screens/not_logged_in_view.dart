import 'package:flutter/material.dart';

class NotLoggedInView extends StatelessWidget {
  const NotLoggedInView({
    Key? key,
    required this.context,
    required this.titleText,
    required this.buttonText,
  }) : super(key: key);

  final BuildContext context;
  final Text titleText;
  final Text buttonText;

  //TODO Define function for button to switch user to login screen
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleText,
          const SizedBox(height: 30),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.pinkAccent,
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: null,
              child: buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
