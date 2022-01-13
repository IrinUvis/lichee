import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/constants/constants.dart';

import 'details_rows.dart';
import 'details_table.dart';

class DetailsListView extends StatelessWidget {
  DetailsListView({
    Key? key,
    required this.channel,
    required this.description,
    required this.about,
    required this.isMember,
    this.members = const [],
  }) : super(key: key);

  final ReadChannelDto channel;
  final DetailsRows description;
  final DetailsRows about;
  final bool isMember;
  List members;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Description',
                  style: kBannerTextStyle),
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
              isMember ? const Text('Members', style: kBannerTextStyle) : Container(),
              isMember ? Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 30.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      for (var item in members) Text('$item'),
                    ],
                  ),
                ),
              ) : Container(),
            ],
          ),
        ),
      ],
    );
  }
}