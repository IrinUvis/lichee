import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  final String date;
  final String place;
  final String title;

  const EventTile({
    Key? key,
    required this.date,
    required this.place,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Text(date),
            const SizedBox(height: 3.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(place),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0 interested   |   0 going',
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
                    onPressed: () {},
                    icon: const Icon(Icons.star),
                    label: const Text('Interested')),
                TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text('Going')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
