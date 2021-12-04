import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Chat list Screen'),
      ),
    );
  }
}
