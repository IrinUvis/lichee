import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/models/channel_chat_data.dart';
import 'package:lichee/screens/chat_list/chat_list_screen.dart';

import '../channel_chat/channel_chat_screen.dart';

class ChatListCard extends StatelessWidget {
  final ChannelChatData channelChatData;

  const ChatListCard({required this.channelChatData});

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
            fromRoute: ChatListScreen.id
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.horizontal(
            start: Radius.circular(30),
            end: Radius.circular(10),
          ),
        ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          channelChatData.channelName,
                          style: kCardChannelNameTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  List<Widget> getRecentMessageDetails() {
    final List<Widget> widgets = [];
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
          Flexible(
            child: Text(
              channelChatData.recentMessageSentBy! +
                  ': ' +
                  channelChatData.recentMessageText!,
              overflow: TextOverflow.ellipsis,
              style: kCardLatestMessageTextStyle,
            ),
          ),
        );
      } else {
        widgets.add(
          Flexible(
            child: Text(
              channelChatData.recentMessageSentBy! + ' shared file',
              style: kCardLatestMessageTextStyle,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        );
      }
      widgets.add(
        Text(
          getFormattedDate(
              DateTime.now(), channelChatData.recentMessageSentAt!),
          style: kCardLatestMessageTimeTextStyle,
        ),
      );
    }
    return widgets;
  }

  @visibleForTesting
  String getFormattedDate(DateTime now, DateTime date) {
    final dayDifference = now.difference(date).inDays;
    if (dayDifference == 0) {
      return 'Today';
    } else {
      if (dayDifference <= 7) {
        return dayDifference == 1
            ? dayDifference.toString() + ' day ago'
            : dayDifference.toString() + ' days ago';
      } else if (dayDifference <= 70) {
        final weeks = dayDifference ~/ 7;
        if (weeks == 1) {
          return weeks.toString() + ' week ago';
        } else {
          return weeks.toString() + ' weeks ago';
        }
      } else {
        return (dayDifference ~/ 30).toString() + ' months ago';
      }
    }
  }
}
