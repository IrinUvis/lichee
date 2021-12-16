import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/models/event.dart';
import 'package:provider/provider.dart';

class EventTile extends StatefulWidget {
  final Event event;

  const EventTile({Key? key, required this.event}) : super(key: key);

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    bool isInterestedPressed = false;
    bool isGoingPressed = false;

    return PhysicalModel(
      elevation: 5.0,
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
                .format(widget.event.date)),
            const SizedBox(height: 3.0),
            Text(
              widget.event.title,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(widget.event.localization),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.event.interestedUsers.length} interested   |   ${widget.event.goingUsers.length} going',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: () {
                      isInterestedPressed
                          ? widget.event.interestedUsers.remove(
                              Provider.of<User?>(context, listen: false)!.uid)
                          : widget.event.interestedUsers.add(
                              Provider.of<User?>(context, listen: false)!.uid);
                      isInterestedPressed = !isInterestedPressed;
                    },
                    icon: Icon(Icons.star_outline,
                        color: LicheeColors.accentColor),
                    label: Text('Interested',
                        style: TextStyle(color: LicheeColors.accentColor))),
                TextButton.icon(
                    onPressed: () {
                      isGoingPressed ? widget.event.goingUsers.remove(
                          Provider.of<User?>(context, listen: false)!.uid)
                          : widget.event.goingUsers.add(
                          Provider.of<User?>(context, listen: false)!.uid);
                      isGoingPressed = !isGoingPressed;
                    },
                    icon: Icon(Icons.check, color: LicheeColors.accentColor),
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
