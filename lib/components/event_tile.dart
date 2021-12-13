import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.symmetric(
            horizontal: 30.0, vertical: 20.0),
        child: const Text(
            'some text dskfsdfdfffffffffffffffffdsfsd sdfsdfdsfdsf sddss asdsadsadasd sad assadsadvcxv'),
      ),
    );
  }
}
