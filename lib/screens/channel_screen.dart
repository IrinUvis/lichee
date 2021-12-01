import 'package:flutter/material.dart';
import 'package:lichee/constants.dart';

import '../channel_constants.dart';

class ChannelScreen extends StatefulWidget {
  static String id = 'channel_screen';
  String channelName;

  ChannelScreen({this.channelName = ' '});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {

  void handleTap(String value) {
    switch (value) {
      case 'Report':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.pinkAccent,
        backgroundColor: const Color(0x221A1A1A),
        elevation: 0.0,
        leading: null,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz),
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
          widget.channelName,
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.group),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      ),
                      onPressed: () {},
                      label: const Text('Join'),
                    ),
                    SizedBox(height: 10.0),
                    const Text(
                      'Description',
                      style: kBannerTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          'owner\'s description about sport and people they are looking for etc etc.'),
                    ),
                    const Text(
                      'About this channel',
                      style: kBannerTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.access_time_outlined),
                                Icon(Icons.groups_rounded),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Created on 1.1.2020'),
                                Text('XYZ members'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
