import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lichee/constants/constants.dart';

import 'chat_list_card.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String textFieldQuery = '';

  Widget getChatListScreen() {
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
                child: getChatListStream(),
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

  Widget getEmptyChatListScreen() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Chat list unavailable',
            textAlign: TextAlign.center,
            style: kLicheeTextStyle,
          ),
          const SizedBox(
            height: 30,
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.pinkAccent,
            child: MaterialButton(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: null,
              child: const Text(
                'Log in to see your chat list!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot> getChatListStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('channel_chats')
          .where('channelNameLower',
              isGreaterThanOrEqualTo: textFieldQuery.toLowerCase().trim())
          .where('channelNameLower',
              isLessThanOrEqualTo: textFieldQuery.toLowerCase().trim() + '~')
          .where('userIds',
              arrayContains:
                  '2bGoqMTi4URGrGT9foi67zDqT6B3')
      // TODO: should be changed once channels and chats can be created normally
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final chats = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          chats.sort((chat1, chat2) {
            final Timestamp? chat1SentAt = chat1['recentMessageSentAt'];
            final Timestamp? chat2SentAt = chat2['recentMessageSentAt'];
            if (chat1SentAt == null || chat2SentAt == null) {
              return 0;
            }
            return chat1SentAt.compareTo(chat2SentAt);
          });
          return ListView(
            children: chats
                .map((chat) => Column(
                      children: <Widget>[
                        ChatListCard(channelChatData: chat),
                        const SizedBox(
                          height: 5.0,
                        )
                      ],
                    ))
                .toList(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user != null ? getChatListScreen() : getEmptyChatListScreen();
  }
}
