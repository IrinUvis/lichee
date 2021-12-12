import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/update/update_channel.dart';
import 'package:lichee/components/details_rows.dart';
import 'package:lichee/components/details_table.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:provider/provider.dart';
import '../constants/channel_constants.dart';

class ChannelScreen extends StatefulWidget {
  static const String id = 'channel_screen';
  final ReadChannelDto channel;

  ChannelScreen({required this.channel});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  String? report;
  late bool hasBeenInitiallyPressed;
  late ReadChannelDto channel;
  late DetailsRows about;
  late DetailsRows description;

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
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      //hard coded for now
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(channel.channelImageUrl),
                        ),
                      ),
                    ),
                    Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.grey.shade800.withOpacity(0.4),
                            Colors.black,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                    Text(channel.channelName,
                        style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                  ],
                ),
                ElevatedButton.icon(
                  icon: hasBeenInitiallyPressed
                      ? const Icon(Icons.check, color: LicheeColors.primary)
                      : const Icon(Icons.group),
                  style: ButtonStyle(
                    backgroundColor: hasBeenInitiallyPressed
                        ? MaterialStateProperty.all<Color>(Colors.white)
                        : MaterialStateProperty.all<Color>(
                            LicheeColors.primary),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (user != null && hasBeenInitiallyPressed) {
                          hasBeenInitiallyPressed = !hasBeenInitiallyPressed;
                          UpdateChannelService().removeUserFromChannelById(
                              user.uid, channel.channelId);
                          channel.userIds.remove(user.uid);
                        } else if (user != null && !hasBeenInitiallyPressed) {
                          hasBeenInitiallyPressed = !hasBeenInitiallyPressed;
                          UpdateChannelService().addUserToChannelById(
                              user.uid, channel.channelId);
                          channel.userIds.add(user.uid);
                        }
                      },
                    );
                  },
                  label: hasBeenInitiallyPressed
                      ? const Text(
                          'Joined',
                          style: TextStyle(color: LicheeColors.primary),
                        )
                      : const Text('Join'),
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
    final PageController controller = PageController();
    return PageView(
      controller: controller,
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          //hard coded for now
                          height: 200.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(channel.channelImageUrl),
                            ),
                          ),
                        ),
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.grey.shade800.withOpacity(0.4),
                                Colors.black,
                              ],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                        ),
                        Text(channel.channelName,
                            style:
                                kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                      ],
                    ),
                    ElevatedButton.icon(
                      icon: hasBeenInitiallyPressed
                          ? const Icon(Icons.check, color: LicheeColors.primary)
                          : const Icon(Icons.group),
                      style: ButtonStyle(
                        backgroundColor: hasBeenInitiallyPressed
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : MaterialStateProperty.all<Color>(
                                LicheeColors.primary),
                      ),
                      onPressed: () {
                        setState(
                          () {
                            if (user != null && hasBeenInitiallyPressed) {
                              hasBeenInitiallyPressed =
                                  !hasBeenInitiallyPressed;
                              UpdateChannelService().removeUserFromChannelById(
                                  user.uid, channel.channelId);
                              channel.userIds.remove(user.uid);
                            } else if (user != null &&
                                !hasBeenInitiallyPressed) {
                              hasBeenInitiallyPressed =
                                  !hasBeenInitiallyPressed;
                              UpdateChannelService().addUserToChannelById(
                                  user.uid, channel.channelId);
                              channel.userIds.add(user.uid);
                            }
                          },
                        );
                      },
                      label: hasBeenInitiallyPressed
                          ? const Text(
                              'Joined',
                              style: TextStyle(color: LicheeColors.primary),
                            )
                          : const Text('Join'),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('News feed', style: kBannerTextStyle),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 30.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Text('some text'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                child: ListView(
                  children: [
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description', style: kBannerTextStyle),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 16.0,
                                right: 16.0,
                                bottom: 0.0),
                            child: Text(channel.description),
                          ),
                          DetailsTable(rows: description.create()),
                          const Text('About this channel',
                              style: kBannerTextStyle),
                          DetailsTable(rows: about.create()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    hasBeenInitiallyPressed = channel.userIds.contains(user?.uid);
    return Scaffold(
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
        title: Text(channel.channelName, style: kAppBarTitleTextStyle),
      ),
      body: channel.userIds.contains(user?.uid)
          ? channelForMember(user)
          : channelForNonMember(user),
    );
  }

  @override
  void initState() {
    super.initState();
    channel = widget.channel;
    about = DetailsRows(channel: channel, isAboutTable: true);
    description = DetailsRows(channel: channel, isAboutTable: false);
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
