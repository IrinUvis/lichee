import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_chat_screen.dart';
import 'package:provider/provider.dart';

import 'package:lichee/constants/constants.dart';

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

class ChatListCard extends StatelessWidget {
  final Map<String, dynamic> channelChatData;

  const ChatListCard({Key? key, required this.channelChatData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChannelChatScreen.id,
          arguments: ChannelChatNavigationParams(
            channelId: channelChatData['channelId'],
            channelName: channelChatData['channelName'],
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.horizontal(
          start: Radius.circular(30),
          end: Radius.circular(10),
        )),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(channelChatData['photoStoragePath']),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        channelChatData['channelName'],
                        style: kCardChannelNameTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: getRecentMessageDetails(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Text> getRecentMessageDetails() {
    final List<Text> widgets = [];
    final String? text = channelChatData['recentMessageText'];
    if (text == null || text.isEmpty) {
      widgets.add(const Text(
        'No messages present yet!',
        style: kCardLatestMessageTextStyle,
      ));
    } else {
      widgets.add(
        Text(
          channelChatData['recentMessageSentBy'] +
              ': ' +
              channelChatData['recentMessageText'],
          style: kCardLatestMessageTextStyle,
        ),
      );
      widgets.add(
        Text(
          _getFormattedDate(channelChatData['recentMessageSentAt']),
          style: kCardLatestMessageTimeTextStyle,
        ),
      );
    }
    return widgets;
  }

  String _getFormattedDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    final currentDate = DateTime.now();
    if (_isDateTheSame(date, currentDate)) {
      return 'Today';
    } else {
      final dayDifference = currentDate.difference(date).inDays;
      return dayDifference == 1
          ? dayDifference.toString() + ' day ago'
          : dayDifference.toString() + ' days ago';
    }
  }

  bool _isDateTheSame(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
