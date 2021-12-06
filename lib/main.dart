import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lichee/authentication_provider.dart';
import 'package:lichee/screens/channel_screen.dart';
import 'package:lichee/screens/home_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        )
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
            backgroundColor: const Color(0xFF1A1A1A),
            scaffoldBackgroundColor: const Color(0xFF1A1A1A),
            colorScheme: ThemeData.dark().colorScheme.copyWith(
                  primary: Colors.pinkAccent,
                )),
        home: const TabsScreen(),
        routes: {
          HomeScreen.id: (context) => HomeScreen(),
          ChannelScreen.id: (context) => ChannelScreen(),
        },
      ),
    );
  }
}
