import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_screen.dart';
import 'package:lichee/screens/home_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';

import 'bloc/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Lichee());
}

class Lichee extends StatefulWidget {
  const Lichee({Key? key}) : super(key: key);
  @override
  LicheeState createState() => LicheeState();
}

class LicheeState extends State<Lichee> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      key: Key("provider"),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          backgroundColor: const Color(0xFF1A1A1A),
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        ),
        home: const TabsScreen(),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          ChannelScreen.id: (context) => ChannelScreen(),
        },
      ),
    );
  }
}
