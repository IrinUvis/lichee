import 'package:flutter/material.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.grey.shade800,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 30.0, vertical: 20.0),
        child: const Text(
            'some text dskfsdfdfffffffffffffffffdsfsd sdfsdfdsfdsf sddss asdsadsadasd sad assadsadvcxv'),
      ),
    );
  }
}
