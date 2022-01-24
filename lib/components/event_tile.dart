import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichee/constants/channel_constants.dart';
import 'package:lichee/constants/colors.dart';
import 'package:provider/provider.dart';

class EventTile extends StatefulWidget {
  final Map<String, dynamic> event;
  final String channelId;

  const EventTile({Key? key, required this.event, required this.channelId})
      : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    List going = widget.event['goingUsers'];
    List interested = widget.event['interestedUsers'];

    bool isInterestedPressed = widget.event['interestedUsers']
        .contains(Provider.of<User?>(context, listen: false)!.uid);
    bool isGoingPressed = widget.event['goingUsers']
        .contains(Provider.of<User?>(context, listen: false)!.uid);

    return PhysicalModel(
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(8.0),
      color: const Color(0xFF303030),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('EEEE, d MMM yyyy h:mm a')
                .format(widget.event['date'].toDate())),
            const SizedBox(height: 3.0),
            Text(
              widget.event['title'],
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(widget.event['localization']),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.event['interestedUsers'].length} interested   |   ${widget.event['goingUsers'].length} going',
                  style: kDescriptiveText,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: () {
                      if (!isGoingPressed) {
                        isInterestedPressed
                            ? interested.remove(
                                Provider.of<User?>(context, listen: false)!.uid)
                            : interested.add(
                                Provider.of<User?>(context, listen: false)!
                                    .uid);
                        isInterestedPressed = !isInterestedPressed;
                        FirebaseFirestore.instance
                            .collection('events/${widget.channelId}/events')
                            .doc(widget.event['id'])
                            .update({
                          'interestedUsers': interested,
                        });
                      }
                    },
                    icon: isInterestedPressed
                        ? Icon(Icons.star, color: LicheeColors.accentColor)
                        : Icon(Icons.star_outline,
                            color: LicheeColors.accentColor),
                    label: Text('Interested',
                        style: TextStyle(color: LicheeColors.accentColor))),
                TextButton.icon(
                    onPressed: () {
                      if (!isInterestedPressed) {
                        isGoingPressed
                            ? going.remove(
                                Provider.of<User?>(context, listen: false)!.uid)
                            : going.add(
                                Provider.of<User?>(context, listen: false)!
                                    .uid);
                        isGoingPressed = !isGoingPressed;
                        FirebaseFirestore.instance
                            .collection('events/${widget.channelId}/events')
                            .doc(widget.event['id'])
                            .update({
                          'goingUsers': going,
                        });
                      }
                    },
                    icon: isGoingPressed
                        ? Icon(Icons.check_circle,
                            color: LicheeColors.accentColor)
                        : Icon(Icons.check_circle_outlined,
                            color: LicheeColors.accentColor),
                    label: Text('Going',
                        style: TextStyle(color: LicheeColors.accentColor))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
