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

final kAddChannelNameBarInputDecoration = InputDecoration(
  filled: true,
  fillColor: LicheeColors.greyColor,
  contentPadding: const EdgeInsets.all(20.0),
  hintText: 'Add channel name',
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  suffixIcon: const Icon(Icons.title),
);

final kAddChannelCityBarInputDecoration = InputDecoration(
  filled: true,
  fillColor: LicheeColors.greyColor,
  contentPadding: const EdgeInsets.all(20.0),
  hintText: 'Add channel city',
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  suffixIcon: const Icon(Icons.location_city),
);

final kAddChannelDescriptionBarInputDecoration = InputDecoration(
  filled: true,
  fillColor: LicheeColors.greyColor,
  contentPadding: const EdgeInsets.all(20.0),
  hintText: 'Add channel description',
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(color: LicheeColors.greyColor, width: 0.0)),
  suffixIcon: const Icon(Icons.description),
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
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
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

final kCategoryAddingInactiveButtonStyle = ElevatedButton.styleFrom(
  primary: LicheeColors.greyColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
);

const kCategoriesTreeViewFiltersButtonText = Padding(
  padding: EdgeInsets.all(7.0),
  child: Text(
    'Cities',
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

final kAddChannelImageButtonContent = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(
      Icons.camera_alt_outlined,
      color: Colors.pinkAccent,
    ),
    SizedBox(
      width: 10.0,
    ),
    Text(
      'Choose channel image',
      style: TextStyle(color: Colors.white, fontSize: 20.0),
    )
  ],
);

final kChooseCategoryButtonText = Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Text(
      'Choose category',
      style: TextStyle(color: Colors.white, fontSize: 20.0),
    )
  ],
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

const kChannelAddedSnackBar = SnackBar(
  elevation: 10.0,
  behavior: SnackBarBehavior.floating,
  duration: Duration(milliseconds: 1000),
  content: Text('Channel added'),
);

const kChatListUnavailable = Text(
  'Chat list unavailable',
  textAlign: TextAlign.center,
  style: kLicheeTextStyle,
);

const kChannelChatUnavailable = Text(
  'Chat is currently unavailable',
  textAlign: TextAlign.center,
  style: kLicheeTextStyle,
);

const kLogInToSeeChatList = Text(
  'Log in to see your chat list!',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
);

const kAddingChannelsOrEventsUnavailable = Text(
  'Adding channels or events unavailable',
  textAlign: TextAlign.center,
  style: kLicheeTextStyle,
);

const kLogInToAddChannelOrList = Text(
  'Log in to add channel or event',
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
);
