import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_screen.dart';
import 'package:lichee/screens/home_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.pinkAccent,
        )
      ),
      home: const TabsScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        ChannelScreen.id: (context) => ChannelScreen(),
      },
    );
  }
}
