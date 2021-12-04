import 'package:flutter/material.dart';

class ChannelListScreen extends StatefulWidget {
  ChannelListScreen({Key? key}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Channel list Screen'),
      ),
    );
  }
}
