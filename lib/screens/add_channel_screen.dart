import 'package:flutter/material.dart';

class AddChannelScreen extends StatefulWidget {
  AddChannelScreen({Key? key}) : super(key: key);

  @override
  _AddChannelScreenState createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Add channel Screen'),
      ),
    );
  }
}
