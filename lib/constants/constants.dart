import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';

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

final kCategoriesTreeViewButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.pinkAccent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(40.0),
  ),
);

final kCategoriesTreeViewInactiveButtonStyle = ElevatedButton.styleFrom(
  primary: LicheeColors.greyColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
);

const kCategoriesTreeViewFiltersButtonText = Padding(
  padding: EdgeInsets.all(7.0),
  child: Text(
    'Filters',
    style: TextStyle(color: Colors.white, fontSize: 20.0),
  ),
);

const kChooseCategoryForAddingChannelButtonText = Text(
  'Choose this category',
  style: TextStyle(color: Colors.white),
);

const kEmptyCategoryText = Text(
  'This category is empty for now',
  style: TextStyle(color: Colors.white, fontSize: 20.0),
);

const kAddChannelButtonText = Text(
  'Add channel',
  style: TextStyle(color: Colors.white, fontSize: 20.0),
);

const kAddEventButtonText = Text(
  'Add event',
  style: TextStyle(color: Colors.white, fontSize: 20.0),
);

const kChooseCategoryButtonText = Text(
  'Choose category',
  style: TextStyle(color: Colors.white, fontSize: 20.0),
);

const kCreateChannelButtonText = Padding(
  padding: EdgeInsets.all(8.0),
  child: Text(
    'Create channel',
    style: TextStyle(color: Colors.white, fontSize: 30.0),
  ),
);

const kCategoryNodeEmptyText = Text(
  'empty',
  style: TextStyle(color: Colors.grey),
);

const kCategoryNodeTestStyle = TextStyle(color: Colors.white, fontSize: 20.0);

const kCategoryChoosingCategoryText = Text(
  'Category:',
  style: TextStyle(
    color: Colors.white,
    fontSize: 16.0,
  ),
);

const kChosenCategoryValidTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const kChosenCategoryInvalidTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);
