import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_list/lichee_button.dart';

class AddChannelScreen extends StatefulWidget {
  AddChannelScreen({Key? key}) : super(key: key);

  @override
  _AddChannelScreenState createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LicheeButton(text: 'Add channel', callback: () {}, textSize: 16.0),
          LicheeButton(text: 'Add event', callback: () {}, textSize: 16.0),
        ],
      )
    );
  }
}
