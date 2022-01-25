import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/chat_message_data.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/screens/channel_chat/channel_chat_controller.dart';
import 'package:provider/provider.dart';

import 'message_bubble.dart';

class ChannelChatScreen extends StatefulWidget {
  static const String id = 'channel_chat_screen';

  final ChannelChatNavigationParams data;

  final ImagePicker imagePicker;
  UserData? userData;

  ChannelChatScreen({
    Key? key,
    required Future<UserData> userData,
    required this.data,
    required this.imagePicker,
  }) : super(key: key) {
    userData.then((data) => this.userData = data);
  }

  @override
  ChannelChatScreenState createState() => ChannelChatScreenState();
}

@visibleForTesting
class ChannelChatScreenState extends State<ChannelChatScreen> {
  late final ChannelChatController _channelChatController;

  final _messageTextController = TextEditingController();
  late final ImagePicker _imagePicker;

  File? _file;
  String _messageText = '';

  File? get file => _file;

  String get messageText => _messageText;

  TextEditingController get messageTextController => _messageTextController;

  ImagePicker get imagePicker => _imagePicker;

  set file(File? value) {
    setState(() {
      _file = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _channelChatController = ChannelChatController(
      Provider.of<FirebaseProvider>(context, listen: false).firestore,
      Provider.of<FirebaseProvider>(context, listen: false).storage,
    );
    _imagePicker = widget.imagePicker;
  }

  StreamBuilder<QuerySnapshot> getMessagesStream() {
    return StreamBuilder(
      stream: _channelChatController.getMessagesStream(widget.data.channelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final messages = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .map((map) => ChatMessageData.mapToChatMessageData(map))
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
              controller: _messageTextController,
              onChanged: (value) {
                _messageText = value;
              },
            ),
          ),
          IconButton(
            onPressed: () => sendMessage(),
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
    if (_file == null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 8.0),
            onPressed: () => chooseImageFromGallery(),
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
            onPressed: () => clearImage(),
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
                _file!,
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
    return widget.data.fromRoute == ChannelScreen.id
        ? Scaffold(
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
          )
        : FutureBuilder(
            future: _channelChatController.getParentChannelByChatId(
                chatId: widget.data.channelId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.data.channelName),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.group_outlined),
                        tooltip: 'Go to channel',
                        onPressed: () {
                          Navigator.pushNamed(context, ChannelScreen.id,
                              arguments: snapshot.data);
                        },
                      ),
                    ],
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
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: LicheeColors.primary,
                  ),
                );
              }
            },
          );
  }

  @visibleForTesting
  Future<void> sendMessage() async {
    _messageTextController.clear();
    String? imageUrl;
    if (_file == null && _messageText.isEmpty) {
      return;
    }
    DateTime now = DateTime.now();
    if (_file != null) {
      try {
        imageUrl = await _channelChatController.uploadPhoto(
          channelId: widget.data.channelId,
          currentTime: now,
          file: _file!,
        );
        setState(() {
          _file = null;
        });
      } on FirebaseException catch (_) {
        Fluttertoast.showToast(
            msg: 'An unexpected error has occurred! Message wasn\'t sent');
      }
    }
    _channelChatController.sendMessage(
      channelId: widget.data.channelId,
      chatMessageData: ChatMessageData(
        idSentBy: widget.userData!.id!,
        nameSentBy: widget.userData!.username!,
        messageText: _messageText,
        imageUrl: imageUrl,
        sentAt: now,
      ),
    );
    _channelChatController.updateChatListWithMostRecentMessage(
      channelId: widget.data.channelId,
      messageText: _messageText,
      userId: widget.userData!.id!,
      username: widget.userData!.username!,
      currentTime: now,
    );
    _messageText = '';
  }

  @visibleForTesting
  Future<void> chooseImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _file = image;
    });
  }

  @visibleForTesting
  void clearImage() {
    setState(() {
      _file = null;
    });
  }
}

class ChannelChatNavigationParams {
  final String channelId;
  final String channelName;
  final String? fromRoute;

  ChannelChatNavigationParams({
    required this.channelId,
    required this.channelName,
    this.fromRoute = '',
  });
}
