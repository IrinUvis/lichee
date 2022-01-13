import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/screens/chat_list/chat_list_view.dart';
import 'package:provider/provider.dart';

import '../auth/screens/not_logged_in_view.dart';

class ChatListScreen extends StatefulWidget {
  static const String id = 'chat_list_screen';

  const ChatListScreen();

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user != null
        ? const ChatListView()
        : NotLoggedInView(
            context: context,
            titleText: kChatListUnavailable,
            buttonText: kLogInToSeeChatList,
          );
  }
}
