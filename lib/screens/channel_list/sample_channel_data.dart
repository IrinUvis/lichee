import 'package:flutter/material.dart';

class ChannelTreeNode {
  String id;
  String name;
  Icon icon;
  String type;
  String? parentId;
  List<String>? childrenIds;

  ChannelTreeNode(
      {required this.id,
      required this.name,
      required this.icon,
      required this.type,
      required this.parentId,
      required this.childrenIds});
}

List<String> filtersList = [
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten'
];

List<ChannelTreeNode> nodesList = [
  ChannelTreeNode(
      id: '1',
      name: 'Football',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: null,
      childrenIds: ['4', '5', '6']),
  ChannelTreeNode(
      id: '2',
      name: 'Basketball',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: null,
      childrenIds: null),
  ChannelTreeNode(
      id: '3',
      name: 'Volleyball',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: null,
      childrenIds: null),
  ChannelTreeNode(
      id: '4',
      name: 'matchPlaying',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '1',
      childrenIds: ['7']),
  ChannelTreeNode(
      id: '5',
      name: 'fanMeetings',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '1',
      childrenIds: null),
  ChannelTreeNode(
      id: '6',
      name: 'matchWatching',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '1',
      childrenIds: null),
  ChannelTreeNode(
      id: '7',
      name: 'Match 3x3',
      icon: const Icon(
        Icons.chat,
        color: Colors.white,
      ),
      type: 'Channel',
      parentId: '4',
      childrenIds: null),
];
