import 'package:flutter/material.dart';
import 'package:lichee/providers/tabs_screen_controller_provider.dart';
import 'package:provider/provider.dart';

class NotLoggedInView extends StatelessWidget {
  const NotLoggedInView({
    Key? key,
    required this.context,
    this.titleText,
    required this.buttonText,
  }) : super(key: key);

  final BuildContext context;
  final Text? titleText;
  final Text buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: titleText != null ? [
          titleText!,
          const SizedBox(height: 30),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.pinkAccent,
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Provider.of<TabsScreenControllerProvider>(
                  context,
                  listen: false,
                ).selectProfilePage();
              },
              child: buttonText,
            ),
          ),
        ] : [
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.pinkAccent,
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Provider.of<TabsScreenControllerProvider>(
                  context,
                  listen: false,
                ).selectProfilePage();
              },
              child: buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
