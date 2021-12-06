import 'package:flutter/material.dart';
import 'package:lichee/components/details_table.dart';
import 'package:lichee/constants/constants.dart';
import '../constants/channel_constants.dart';

class ChannelScreen extends StatefulWidget {
  static String id = 'channel_screen';
  final String channelName;
  final String imageSource;

  ChannelScreen({this.channelName = '', this.imageSource = ''});

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
    String description =
        'owner\'s description about sport and people they are looking for etc etc.';
    List<TableRow> aboutRows = const [
      TableRow(children: [
        Icon(Icons.access_time_outlined),
        Text('Created on 1.1.2020'),
      ]),
      TableRow(children: [
        Icon(Icons.groups_rounded),
        Text('100 members'),
      ]),
      TableRow(children: [
        Icon(Icons.person),
        Text('Created by: '),
      ])
    ];

    List<TableRow> descriptionRows = const [
      TableRow(children: [
        Icon(Icons.near_me),
        Text('City, Country'),
      ]),
      TableRow(children: [
        Icon(Icons.trending_up_outlined),
        Text('Level'),
      ]),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.pinkAccent,
        backgroundColor: const Color(0x221A1A1A),
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
        title: Text(widget.channelName, style: kAppBarTitleTextStyle),
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
                            image: NetworkImage(widget.imageSource),
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
                      Text(widget.channelName,
                          style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: hasBeenPressed
                        ? const Icon(Icons.check, color: Colors.pinkAccent)
                        : const Icon(Icons.group),
                    style: ButtonStyle(
                      backgroundColor: hasBeenPressed
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(Colors.pinkAccent),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogged
                            ? hasBeenPressed = !hasBeenPressed
                            : print('please log in');
                      });
                    },
                    label: hasBeenPressed
                        ? const Text(
                            'Request sent',
                            style: TextStyle(color: Colors.pinkAccent),
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
                          child: Text(description),
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
              child: const Text('Cancel', style: kAlertDialogText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send', style: kAlertDialogText),
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
