import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:intl/intl.dart';

class DetailsRows {
  final bool isAboutTable;
  final ReadChannelDto channel;
  String? ownerName;

  DetailsRows(
      {required this.channel, required this.isAboutTable, this.ownerName});

  List<TableRow> create() {
    List<TableRow> rows = [];
    if (isAboutTable) {
      rows = [
        TableRow(children: [
          const Icon(Icons.access_time_outlined),
          Text(
              'Created on ${DateFormat('d MMM yyyy').format(channel.createdOn)}'),
        ]),
        TableRow(children: [
          const Icon(Icons.groups_rounded),
          Text('${channel.userIds.length} members'),
        ]),
        TableRow(children: [
          const Icon(Icons.person),
          ownerName == null
              ? Text('Created by: ${channel.ownerId}')
              : Text('Created by: $ownerName'),
        ])
      ];
      return rows;
    } else {
      rows = [
        TableRow(children: [
          const Icon(Icons.near_me),
          Text(channel.city),
        ]),
        TableRow(children: [
          const Icon(Icons.assessment_outlined),
          channel.isPromoted
              ? const Text('Channel promoted by owner')
              : const Text('Regular channel'),
        ]),
      ];
      return rows;
    }
  }
}
