import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/details_table.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
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
  bool isLogged = true;
  bool hasBeenPressed = false;

  void handleTap(String value) {
    switch (value) {
      case 'Report':
        _reportDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String owner = widget.channel.ownerId;
    String membersNumber = widget.channel.userIds.length.toString();
    String city = widget.channel.city;

    List<TableRow> aboutRows = [
      TableRow(children: [
        Icon(Icons.access_time_outlined),
        Text(widget.channel.createdOn.toString()),
      ]),
      TableRow(children: [
        Icon(Icons.groups_rounded),
        Text('$membersNumber members'),
      ]),
      TableRow(children: [
        Icon(Icons.person),
        Text('Created by: $owner'),
      ])
    ];

    List<TableRow> descriptionRows = [
      TableRow(children: [
        Icon(Icons.near_me),
        Text(city),
      ]),
      TableRow(children: [
        Icon(Icons.trending_up_outlined),
        Text('Level'),
      ]),
    ];

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
        title: Text(widget.channel.channelName, style: kAppBarTitleTextStyle),
      ),
      body: SafeArea(
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
                            image: NetworkImage(widget.channel.channelImageUrl),
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
                      Text(widget.channel.channelName,
                          style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: hasBeenPressed
                        ? const Icon(Icons.check, color: LicheeColors.primary)
                        : const Icon(Icons.group),
                    style: ButtonStyle(
                      backgroundColor: hasBeenPressed
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(
                              LicheeColors.primary),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogged
                            ? hasBeenPressed = !hasBeenPressed
                            : print('please log in or sth');
                      });
                    },
                    label: hasBeenPressed
                        ? const Text(
                            'Request sent',
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
                          child: Text(widget.channel.description),
                        ),
                        DetailsTable(rows: descriptionRows),
                        const Text('About this channel',
                            style: kBannerTextStyle),
                        DetailsTable(rows: aboutRows),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
