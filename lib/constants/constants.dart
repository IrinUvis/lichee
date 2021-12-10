import 'package:flutter/material.dart';

const kHomeSearchBarInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  hintText: 'Search channels...',
  border: InputBorder.none,
  suffixIcon: Icon(Icons.search),
);

const kChatsSearchBarInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  hintText: 'Search chats...',
  border: InputBorder.none,
  suffixIcon: Icon(Icons.search),
);

const kAddChannelNameBarInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  hintText: 'Add channel name',
  border: InputBorder.none,
  suffixIcon: Icon(Icons.title),
);

const kAddChannelCityBarInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  hintText: 'Add channel city',
  border: InputBorder.none,
  suffixIcon: Icon(Icons.location_city),
);

const kAddChannelDescriptionBarInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(20.0),
  hintText: 'Add channel description',
  border: InputBorder.none,
  suffixIcon: Icon(Icons.description),
);

const kBannerTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

const kCardChannelNameTextStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.w400,
);

const kCardLatestMessageTextStyle =
    TextStyle(fontSize: 15.5, fontWeight: FontWeight.w300);

const kCardLatestMessageTimeTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w200,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kLicheeTextStyle = TextStyle(
  color: Colors.pinkAccent,
  letterSpacing: 3.0,
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);
const kRegisterTextStyle = TextStyle(
  color: Colors.pinkAccent,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);
