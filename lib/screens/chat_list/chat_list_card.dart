import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/channel_chat_data.dart';

import '../channel_chat/channel_chat_screen.dart';

class ChatListCard extends StatelessWidget {
  final ChannelChatData channelChatData;

  const ChatListCard({Key? key, required this.channelChatData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChannelChatScreen.id,
          arguments: ChannelChatNavigationParams(
            channelId: channelChatData.channelId,
            channelName: channelChatData.channelName,
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.horizontal(
              start: Radius.circular(30),
              end: Radius.circular(10),
            )),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(channelChatData.photoUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        channelChatData.channelName,
                        style: kCardChannelNameTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: getRecentMessageDetails(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Text> getRecentMessageDetails() {
    final List<Text> widgets = [];
    final DateTime? date = channelChatData.recentMessageSentAt;
    if (date == null) {
      widgets.add(const Text(
        'No messages present yet!',
        style: kCardLatestMessageTextStyle,
      ));
    } else {
      final String text = channelChatData.recentMessageText!;
      if (text.isNotEmpty) {
        widgets.add(
          Text(
            channelChatData.recentMessageSentBy!.toString() +
                ': ' +
                channelChatData.recentMessageText!,
            style: kCardLatestMessageTextStyle,
          ),
        );
      } else {
        widgets.add(
          Text(
            channelChatData.recentMessageSentBy!.toString() +
                ' shared file',
            style: kCardLatestMessageTextStyle,
          ),
        );
      }
      widgets.add(
        Text(
          getFormattedDate(channelChatData.recentMessageSentAt!),
          style: kCardLatestMessageTimeTextStyle,
        ),
      );
    }
    return widgets;
  }

  @visibleForTesting
  String getFormattedDate(DateTime date) {
    final currentDate = DateTime.now();
    if (_isDateTheSame(date, currentDate)) {
      return 'Today';
    } else {
      final dayDifference = currentDate.difference(date).inDays;
      return dayDifference == 1
          ? dayDifference.toString() + ' day ago'
          : dayDifference.toString() + ' days ago';
    }
  }

  bool _isDateTheSame(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}