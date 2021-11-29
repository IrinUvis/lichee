import 'package:flutter/material.dart';
import 'package:lichee/constants.dart';

class ChannelScreen extends StatefulWidget {
  static String id = 'channel_screen';

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
          ),
        ],
        title: Text(
          'Name of the channel',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
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
                    Text('photo maybe?'),
                    ElevatedButton.icon(
                      icon: Icon(Icons.group),
                      style: ButtonStyle(
                        //foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.pinkAccent),
                      ),
                      onPressed: () {},
                      label: Text('Join'),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Description',
                      style: kBannerTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                              'owner\'s description about sport and people they are looking for'),
                        ],
                      ),
                    ),
                    Text(
                      'About this channel',
                      style: kBannerTextStyle,
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
