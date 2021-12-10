import 'package:flutter/material.dart';

class ChannelTreeNodeA {
  String id;
  String name;
  String type;
  String? parentId;
  List<String>? childrenIds;

  ChannelTreeNodeA(
      {required this.id,
        required this.name,
        required this.type,
        required this.parentId,
        required this.childrenIds});
}

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
      childrenIds: ['9']),
  ChannelTreeNode(
      id: '3',
      name: 'Volleyball',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: null,
      childrenIds: ['10']),
  ChannelTreeNode(
      id: '4',
      name: 'Match Playing',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '1',
      childrenIds: ['7']),
  ChannelTreeNode(
      id: '5',
      name: 'Fan Meetings',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '1',
      childrenIds: null),
  ChannelTreeNode(
      id: '6',
      name: 'Match Watching',
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
  ChannelTreeNode(
      id: '8',
      name: 'Running',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: null,
      childrenIds: null),
  ChannelTreeNode(
      id: '9',
      name: 'Discussions',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '2',
      childrenIds: ['11', '12']),
  ChannelTreeNode(
      id: '10',
      name: 'Net discussions',
      icon: const Icon(
        Icons.category,
        color: Colors.white,
      ),
      type: 'Category',
      parentId: '3',
      childrenIds: null),
  ChannelTreeNode(
      id: '11',
      name: 'NBA',
      icon: const Icon(
        Icons.chat,
        color: Colors.white,
      ),
      type: 'Channel',
      parentId: '9',
      childrenIds: null),
  ChannelTreeNode(
      id: '12',
      name: 'Energa Basket Liga',
      icon: const Icon(
        Icons.chat,
        color: Colors.white,
      ),
      type: 'Channel',
      parentId: '9',
      childrenIds: null)
];
