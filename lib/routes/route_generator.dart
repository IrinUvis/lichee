import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_chat_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments!;

    switch (settings.name) {
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (context) =>
              const TabsScreen(),
        );
      case ChannelChatScreen.id:
        return MaterialPageRoute(
          builder: (context) =>
              ChannelChatScreen(data: args as ChannelChatNavigationParams),
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
