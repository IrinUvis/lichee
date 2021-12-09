import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/screens/add_channel_screen.dart';
import 'package:lichee/screens/channel_list_screen.dart';
import 'package:lichee/screens/chat_list_screen.dart';
import 'package:lichee/screens/home_screen.dart';
import 'package:lichee/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const String id = 'tabs_screen';

  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': HomeScreen(), 'title': 'Home'},
    {'page': ChannelListScreen(), 'title': 'Your channels'},
    {'page': AddChannelScreen(), 'title': 'Add channel'},
    {'page': const ChatListScreen(), 'title': 'Your chats'},
    {'page': ProfileScreen(), 'title': 'Your profile'}
  ];

  int _selectedPageIndex = 0;
  late final PageController _pageController;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0.0,
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Center(
          child: Text(
            'Lichee',
            style: kLicheeTextStyle,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedPageIndex = index);
            },
            children: _pages.map((map) => map['page'] as Widget).toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group_outlined,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
              size: 30.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              size: 30.0,
            ),
          )
        ],
      ),
    );
  }
}
