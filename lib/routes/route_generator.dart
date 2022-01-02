import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/models/user_data.dart';
import 'package:lichee/screens/channel_chat/channel_chat_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments!;

    switch (settings.name) {
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        );
      case ChannelChatScreen.id:
        return MaterialPageRoute(
          builder: (context) => ChannelChatScreen(
            userData: Provider.of<UserData?>(context),
            data: args as ChannelChatNavigationParams,
            firestore: FirebaseFirestore.instance,
            storage: StorageService(FirebaseStorage.instance),
            imagePicker: ImagePicker(),
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ERROR'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Page not found!'),
        ),
      );
    });
  }
}
