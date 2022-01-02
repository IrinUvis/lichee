import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/tabs_screen_controller_provider.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const String id = 'tabs_screen';

  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
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
            controller: Provider.of<TabsScreenControllerProvider>(context)
                .pageController,
            onPageChanged: (index) {
              setState(() => Provider.of<TabsScreenControllerProvider>(
                    context,
                    listen: false,
                  ).selectedPageIndex = index);
            },
            children: Provider.of<TabsScreenControllerProvider>(context)
                .pages
                .map((map) => map['page'] as Widget)
                .toList()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: Provider.of<TabsScreenControllerProvider>(
          context,
          listen: false,
        ).selectPage,
        type: BottomNavigationBarType.fixed,
        currentIndex: Provider.of<TabsScreenControllerProvider>(
          context).selectedPageIndex,
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
            label: 'Find groups',
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
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
