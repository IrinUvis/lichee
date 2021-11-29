import 'package:flutter/material.dart';
import 'package:lichee/constants.dart';

class ChannelScreen extends StatefulWidget {
  static String id = 'channel_screen';

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0.0,
        leading: null,
        title: Text(
          'Name of the channel',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('hello to channel\'s screen')),
        ],
      ),
    );
  }
}
