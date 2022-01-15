import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/screens/auth/screens/not_logged_in_view.dart';
import 'package:lichee/screens/home/channel_list_card.dart';
import 'package:lichee/screens/home/home_screen_controller.dart';
import 'package:provider/provider.dart';

class ChannelListView extends StatelessWidget {
  final HomeScreenController homeScreenController;

  const ChannelListView({Key? key, required this.homeScreenController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user == null
        ? Center(
            child: NotLoggedInView(
              context: context,
              buttonText: kLogInToSeeChannelList,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: getChannelList(userId: user.uid),
          );
  }

  FutureBuilder getChannelList({required String userId}) {
    return FutureBuilder(
        future: homeScreenController.getChannelsOfUserWithId(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final channels = snapshot.data! as List<ReadChannelDto>;
            return ListView(
              children: channels
                  .map((channel) => ChannelListCard(channelDto: channel))
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: LicheeColors.primary,
              ),
            );
          }
        });
  }
}
