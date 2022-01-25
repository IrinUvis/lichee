import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/providers/authentication_provider.dart';
import 'package:lichee/screens/add_event/add_event_screen.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/screens/channel_chat/channel_chat_screen.dart';
import 'package:lichee/screens/tabs_screen.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        );
      case ChannelScreen.id:
        final args = settings.arguments!;
        return MaterialPageRoute(
          builder: (context) => ChannelScreen(channel: args as ReadChannelDto),
        );
      case ChannelChatScreen.id:
        final args = settings.arguments!;
        return MaterialPageRoute(
          builder: (context) => ChannelChatScreen(
            userData: Provider.of<AuthenticationProvider>(context)
                .getCurrentUserData(),
            data: args as ChannelChatNavigationParams,
            imagePicker: ImagePicker(),
          ),
        );
      case AddEventScreen.id:
        final args = settings.arguments!;
        return MaterialPageRoute(
          builder: (context) => AddEventScreen(
            data: args as AddEventNavigationParams,
          ),
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
