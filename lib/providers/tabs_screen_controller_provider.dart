import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/screens/add_channel/add_channel_screen.dart';
import 'package:lichee/screens/channel_list/channel_list_screen.dart';
import 'package:lichee/screens/chat_list/chat_list_screen.dart';
import 'package:lichee/screens/home/home_screen.dart';
import 'package:lichee/screens/profile/profile_screen.dart';

class TabsScreenControllerProvider {
  final List<Map<String, Object>> pages = [
    {'page': HomeScreen(), 'title': 'Home'},
    {'page': const ChannelListScreen(), 'title': 'Your channels'},
    {'page': AddChannelScreen(imagePicker: ImagePicker()), 'title': 'Add channel'},
    {'page': const ChatListScreen(), 'title': 'Your chats'},
    {'page': const ProfileScreen(), 'title': 'Your profile'}
  ];
  int selectedPageIndex = 0;
  late final PageController pageController;

  TabsScreenControllerProvider({required this.pageController});

  void selectPage(int index) {
    selectedPageIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  void selectProfilePage() {
    selectPage(4);
  }
}
