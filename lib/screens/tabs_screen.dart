import 'package:flutter/material.dart';
import 'package:lichee/screens/add_channel_screen.dart';
import 'package:lichee/screens/channel_list_screen.dart';
import 'package:lichee/screens/chat_list_screen.dart';
import 'package:lichee/screens/home_screen.dart';

import 'loginScreen.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

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
    {'page': ChatListScreen(), 'title': 'Your chats'},
    {'page': LoginScreen(), 'title': 'Your profile'}
  ];

  int _selectedPageIndex = 0;
  late final PageController _pageController;

  void _selectPage(int index) {
    setState(() {
      //Only pops current route in case that the register screen was selected within the profile screen
      //The nested navigator didn't notice that you were tapping other tab so it was necessary to pop it.
      if (navKey.currentState!.canPop()) navKey.currentState!.pop();
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
      body: SizedBox.expand(
        child: Navigator(
          key: navKey,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedPageIndex = index);
                },
                children: _pages.map((map) => map['page'] as Widget).toList()),
          ),
        ),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group_outlined,
              size: 30.0,
            ),
            label: 'Your channels',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            label: 'Add channel',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
              size: 30.0,
            ),
            label: 'Your chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              size: 30.0,
            ),
            label: 'Your profile',
          )
        ],
      ),
    );
  }
}
