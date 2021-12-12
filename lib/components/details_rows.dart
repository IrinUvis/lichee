import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';

class DetailsRows {
  final bool isAboutTable;
  final ReadChannelDto channel;

  DetailsRows({required this.channel, required this.isAboutTable});

  List<TableRow> create() {
    List<TableRow> rows = [];
    if (isAboutTable) {
      rows = [
        TableRow(children: [
          const Icon(Icons.access_time_outlined),
          Text(
              'Created on ${channel.createdOn.day}.${channel.createdOn.month}.${channel.createdOn.year}'),
        ]),
        TableRow(children: [
          const Icon(Icons.groups_rounded),
          Text('${channel.userIds.length} members'),
        ]),
        TableRow(children: [
          const Icon(Icons.person),
          Text('Created by: ${channel.ownerId}'),
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
          const Icon(Icons.trending_up_outlined),
          Text('Level'),
        ]),
      ];
      return rows;
    }
  }
}
