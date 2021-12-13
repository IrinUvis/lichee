import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    Key? key,
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
            Text(
              'Tuesday, 15.11.2022 at 18:00',
            ),
            SizedBox(height: 3.0),
            Text(
              '2nd match!',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text('Zgierz, ul. Wschodnia 2, sala sportowa MOSiR'),
            SizedBox(height: 5.0),
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
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.star),
                    label: Text('Interested')),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.check),
                    label: Text('Going')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
