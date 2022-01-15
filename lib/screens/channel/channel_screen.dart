import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/update/update_channel.dart';
import 'package:lichee/components/channel_backgroud_photo.dart';
import 'package:lichee/components/details_list_view.dart';
import 'package:lichee/components/details_rows.dart';
import 'package:lichee/components/details_table.dart';
import 'package:lichee/components/events_view.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_event/add_event_screen.dart';
import 'package:lichee/screens/channel_chat/channel_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/channel_constants.dart';

class ChannelScreen extends StatefulWidget {
  static const String id = 'channel_screen';
  final ReadChannelDto channel;

  const ChannelScreen({Key? key, required this.channel}) : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  String? report;
  late bool hasBeenInitiallyPressed;
  late ReadChannelDto channel;
  late DetailsRows about;
  late DetailsRows description;
  final PageController _controller = PageController();
  double currentPage = 0;
  late bool isLogged;

  late final UpdateChannelService _updateChannelService;

  @override
  void initState() {
    super.initState();
    channel = widget.channel;
    about = DetailsRows(channel: channel, isAboutTable: true);
    description = DetailsRows(channel: channel, isAboutTable: false);
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!;
      });
    });
    _updateChannelService = UpdateChannelService(
        firestore:
            Provider.of<FirebaseProvider>(context, listen: false).firestore);
  }

  void handleTap(String value) {
    switch (value) {
      case 'Report':
        _reportDialog(context);
    }
  }

  Widget channelForNonMember(User? user) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ChannelBackgroundPhoto(channel: channel),
                ElevatedButton.icon(
                  icon: const Icon(Icons.group_add),
                  style: ButtonStyle(
                    backgroundColor: user != null
                        ? MaterialStateProperty.all<Color>(LicheeColors.primary)
                        : MaterialStateProperty.all<Color>(
                            LicheeColors.disabledButton),
                    foregroundColor: user != null
                        ? MaterialStateProperty.all<Color>(Colors.white)
                        : MaterialStateProperty.all<Color>(
                            const Color(0xFF424242)),
                  ),
                  onPressed: isLogged
                      ? () {
                          setState(() {
                            hasBeenInitiallyPressed = !hasBeenInitiallyPressed;
                            _updateChannelService.addUserToChannelById(
                                user!.uid, channel.channelId);
                            channel.userIds.add(user.uid);
                          });
                        }
                      : null,
                  label: const Text('Join'),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Description', style: kBannerTextStyle),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 16.0, right: 16.0, bottom: 0.0),
                        child: Text(channel.description),
                      ),
                      DetailsTable(rows: description.create()),
                      const Text('About this channel', style: kBannerTextStyle),
                      DetailsTable(rows: about.create()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget channelForMember(User? user) {
    List members = channel.userIds.toList();
    List membersNames;
    members.forEach((member) {});

    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<FirebaseProvider>(context, listen: false)
          .firestore
          .collection('events/${channel.channelId}/events')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final events = snapshot.data!.docs
              .map((e) => e.data() as Map<String, dynamic>)
              .toList();
          final ids = snapshot.data!.docs.map((e) => e.id).toList();
          events.forEach((element) {
            element.putIfAbsent('id', () => ids[events.indexOf(element)]);
          });
          return PageView(
            controller: _controller,
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ChannelBackgroundPhoto(channel: channel),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.check_circle_outline,
                                  color: LicheeColors.primary,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      if (user != null) {
                                        hasBeenInitiallyPressed =
                                            !hasBeenInitiallyPressed;
                                        _updateChannelService
                                            .removeUserFromChannelById(
                                                user.uid, channel.channelId);
                                        channel.userIds.remove(user.uid);
                                      }
                                    },
                                  );
                                },
                                label: const Text(
                                  'Joined',
                                  style: TextStyle(color: LicheeColors.primary),
                                ),
                              ),
                              IconButton(
                                color: LicheeColors.primary,
                                tooltip: "Go to chat",
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ChannelChatScreen.id,
                                    arguments: ChannelChatNavigationParams(
                                        channelId: channel.channelId,
                                        channelName: channel.channelName,
                                        fromRoute: ChannelScreen.id),
                                  );
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          EventsView(events: events, channel: channel),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: DetailsListView(
                          channel: channel,
                          description: description,
                          about: about,
                          isMember: true,
                          members: members),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: LicheeColors.primary,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    hasBeenInitiallyPressed = channel.userIds.contains(user?.uid);
    if (user != null) {
      isLogged = true;
    } else {
      isLogged = false;
    }
    return Scaffold(
      floatingActionButton: channel.userIds.contains(user?.uid)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                mini: true,
                backgroundColor: LicheeColors.primary,
                onPressed: () {
                  Navigator.pushNamed(context, AddEventScreen.id,
                      arguments: AddEventNavigationParams(
                          channelId: channel.channelId,
                          channelName: channel.channelName));
                },
              ),
            )
          : null,
      bottomSheet: Container(
        height: 30.0,
        child: Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: channel.userIds.contains(user?.uid) ? 2 : 1,
            effect: const JumpingDotEffect(
              dotColor: Colors.grey,
              activeDotColor: LicheeColors.primary,
              dotHeight: 10.0,
              dotWidth: 10.0,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: LicheeColors.primary,
        backgroundColor: LicheeColors.appBarColor,
        elevation: 0.0,
        leading: null,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: handleTap,
            itemBuilder: (BuildContext context) {
              return {'Report'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        title: Text(
          channel.channelName,
          style: kAppBarTitleTextStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: channel.userIds.contains(user?.uid)
          ? channelForMember(user)
          : channelForNonMember(user),
    );
  }

  Future<void> _reportDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report a channel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Tell us what\'s happened'),
                TextField(
                  onChanged: (value) {
                    report = value;
                  },
                  autofocus: true,
                  maxLines: null,
                  decoration: kReportInputDecoration,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: kCancelAlertDialogText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send', style: kSendAlertDialogText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}