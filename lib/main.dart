import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_screen.dart';
import 'package:lichee/screens/home_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';

void main() {
  runApp(const Lichee());
}

class Lichee extends StatelessWidget {
  const Lichee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        backgroundColor: const Color(0xFF1A1A1A),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const TabsScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        ChannelScreen.id: (context) => ChannelScreen(),
      },
    );
  }
}
