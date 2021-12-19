
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/constants/constants.dart';

class ChannelBackgroundPhoto extends StatelessWidget {
  const ChannelBackgroundPhoto({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final ReadChannelDto channel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          //hard coded for now
          height: 200.0,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(channel.channelImageUrl),
            ),
          ),
        ),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.grey.shade800.withOpacity(0.4),
                Colors.black,
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        Text(channel.channelName,
            style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
      ],
    );
  }
}
