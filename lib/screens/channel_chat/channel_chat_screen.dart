import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/message_data.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class ChannelChatScreen extends StatefulWidget {
  static const String id = 'channel_chat_screen';

  final ChannelChatNavigationParams data;

  const ChannelChatScreen({required this.data, Key? key}) : super(key: key);

  @override
  _ChannelChatScreenState createState() => _ChannelChatScreenState();
}

class _ChannelChatScreenState extends State<ChannelChatScreen> {
  final messageTextController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();

  File? file;
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
                imageUrl: message.imageUrl,
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

  Widget getMessageSender() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getImagePicker(),
          Expanded(
            child: TextField(
              decoration: kMessageTextFieldDecoration,
              controller: messageTextController,
              onChanged: (value) {
                messageText = value;
              },
            ),
          ),
          IconButton(
            onPressed: () => _sendMessage(),
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      ),
    );
  }

  Row getImagePicker() {
    if (file == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 8.0),
            onPressed: () => _chooseImageFromGallery(),
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.pinkAccent,
            ),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 10.0),
            onPressed: () => _clearImage(),
            icon: const Icon(
              Icons.close_outlined,
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.file(
                file!,
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          )
        ],
      );
    }
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
            getMessageSender(),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    messageTextController.clear();
    String? imageUrl;
    if (file == null && messageText.isEmpty) {
      return;
    }
    DateTime now = DateTime.now();
    if (file != null) {
      try {
        imageUrl = await StorageService.uploadFile(
            path: 'chats/' + widget.data.channelId + '/' + now.millisecondsSinceEpoch.toString(), file: file!);
        setState(() {
          file = null;
        });
      } on FirebaseException catch (e) {
        Fluttertoast.showToast(msg: 'An unexpected error has occurred! Message wasn\'t sent');
      }
    }
    FirebaseFirestore.instance
        .collection('channel_messages/' + widget.data.channelId + '/messages')
        .add(MessageData(
      idSentBy: Provider.of<User?>(context, listen: false)!.uid,
      nameSentBy: Provider.of<User?>(context, listen: false)!.displayName!,
      messageText: messageText,
      imageUrl: imageUrl,
      sentAt: now,
    ).toMap());
    messageText = '';
  }

  Future<void> _chooseImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path); //
    setState(() {
      file = image;
    });
  }

  void _clearImage() {
    setState(() {
      file = null;
    });
  }
}

class ChannelChatNavigationParams {
  final String channelId;
  final String channelName;

  ChannelChatNavigationParams({
    required this.channelId,
    required this.channelName,
  });
}
