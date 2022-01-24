import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/components/event_tile.dart';
import 'package:lichee/constants/channel_constants.dart';
import 'package:lichee/constants/constants.dart';

class EventsView extends StatelessWidget {
  const EventsView({
    Key? key,
    required this.events,
    required this.channel,
  }) : super(key: key);

  final List<Map<String, dynamic>> events;
  final ReadChannelDto channel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Events', style: kBannerTextStyle),
          events.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'It seems that no events has been planned yet!',
                      style: kDescriptiveText,
                    ),
                  ),
                )
              : Container(),
          for (var e in events)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              child: EventTile(event: e, channelId: channel.channelId),
            ),
        ],
      ),
    );
  }
}
