import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/providers/tabs_screen_controller_provider.dart';
import 'package:lichee/routes/route_generator.dart';
import 'package:lichee/screens/tabs_screen.dart';
import 'package:lichee/services/storage_service.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';

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
        Provider<FirebaseProvider>(
          create: (_) => FirebaseProvider(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
            storage: StorageService(FirebaseStorage.instance),
          ),
        ),
        Provider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(
            auth: context.read<FirebaseProvider>().auth,
            firestore: context.read<FirebaseProvider>().firestore,
          ),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        Provider<TabsScreenControllerProvider>(
          create: (_) => TabsScreenControllerProvider(
            pageController: PageController(),
          ),
        ),
      ],
      child: MaterialApp(
        theme: CustomTheme.darkTheme,
        home: const TabsScreen(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
