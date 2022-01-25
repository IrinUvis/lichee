import 'package:cloud_firestore/cloud_firestore.dart';
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

  StreamBuilder getChannelList({required String userId}) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            homeScreenController.getChannelsOfUserWithIdStream(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final channels = snapshot.data!.docs.map((doc) {
              final channel = doc.data() as Map<String, dynamic>;
              channel['id'] = doc.id;
              return channel;
            }).map(
              (channel) {
                String channelId = channel['id'];
                String channelName = channel['channelName'];
                String channelImageURL = channel['channelImageURL'];
                String city = channel['city'];
                Timestamp createdOn = channel['createdOn'];
                String description = channel['description'];
                String ownerId = channel['ownerId'];
                List<String> userIds = List.from(channel['userIds']);
                bool isPromoted = channel['isPromoted'] ?? false;
                return ReadChannelDto(
                  channelId: channelId,
                  channelName: channelName,
                  ownerId: ownerId,
                  userIds: userIds,
                  description: description,
                  channelImageURL: channelImageURL,
                  createdOn: createdOn.toDate(),
                  city: city,
                  isPromoted: isPromoted,
                );
              },
            ).toList();
            return Column(
              children: channels
                  .map((channel) => Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: ChannelListCard(channelDto: channel),
                      ))
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
