import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/message_data.dart';
import 'package:provider/provider.dart';

class ChannelChatScreen extends StatefulWidget {
  static const String id = 'channel_chat_screen';

  final ChannelChatNavigationParams data;

  const ChannelChatScreen({required this.data, Key? key}) : super(key: key);

  @override
  _ChannelChatScreenState createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  final messageTextController = TextEditingController();
  String messageText = '';

  StreamBuilder<QuerySnapshot> getMessagesStream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('channel_messages/' + widget.data.channelId + '/messages')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final messages = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .map((map) => MessageData.mapToMessageData(map))
              .toList();
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            messageBubbles.add(
              MessageBubble(
                sender: message.nameSentBy,
                text: message.messageText,
                isMe: Provider.of<User?>(context)!.uid == message.idSentBy,
              ),
            );
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.channelName),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            getMessagesStream(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: kMessageTextFieldDecoration,
                    controller: messageTextController,
                    onChanged: (value) {
                      messageText = value;
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => sendMessage(),
                  child: const Text(
                    'Send',
                    //style: ,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    messageTextController.clear();
    FirebaseFirestore.instance
        .collection('channel_messages/' + widget.data.channelId + '/messages')
        .add(MessageData(
          idSentBy: Provider.of<User?>(context, listen: false)!.uid,
          nameSentBy: Provider.of<User?>(context, listen: false)!.displayName!,
          messageText: messageText,
          sentAt: DateTime.now(),
        ).toMap());
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.pinkAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelChatNavigationParams {
  final String channelId;
  final String channelName;

  ChannelChatNavigationParams(
      {required this.channelId, required this.channelName});
}
