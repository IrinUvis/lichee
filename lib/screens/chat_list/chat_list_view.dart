import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

import 'chat_list_card.dart';
import 'chat_list_controller.dart';

class ChatListView extends StatefulWidget {
  const ChatListView();

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  late final ChatListController chatListController;

  @override
  void initState() {
    super.initState();
    chatListController = ChatListController(Provider.of<FirebaseProvider>(context, listen: false).firestore);
  }

  String textFieldQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF363636),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() => textFieldQuery = value),
                  decoration: kChatsSearchBarInputDecoration,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: getChatsStream(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> getChatsStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatListController.getChatsStream(
        query: textFieldQuery,
        userId: Provider.of<User?>(context)!.uid,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final chats = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .map((map) => ChannelChatData.mapToChannelChatData(map))
              .toList();
          chats.sort((chat1, chat2) {
            return chat1.compareTo(chat2);
          });
          return ListView(
            children: chats
                .map(
                  (chat) => Column(
                    children: <Widget>[
                      ChatListCard(channelChatData: chat),
                      const SizedBox(
                        height: 5.0,
                      )
                    ],
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }
}
