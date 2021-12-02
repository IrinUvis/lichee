import 'package:flutter/material.dart';
import 'package:lichee/constants.dart';

import '../channel_constants.dart';

class ChannelScreen extends StatefulWidget {
  static String id = 'channel_screen';
  String channelName;
  String imageSource;

  ChannelScreen({this.channelName = ' ', this.imageSource = ' '});

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
    String description =
        'owner\'s description about sport and people they are looking for etc etc.';

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
        title: Text(
          widget.channelName,
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // padding: EdgeInsets.symmetric(horizontal: 8.0),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Stack(
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
                            style:
                                kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.group),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pinkAccent),
                    ),
                    onPressed: () {},
                    label: const Text('Join'),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: kBannerTextStyle,
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text(description),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: const [
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
                                ]),
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
          ],
        ),
      ),
    );
  }
}
