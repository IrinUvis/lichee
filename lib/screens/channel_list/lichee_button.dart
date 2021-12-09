import 'package:flutter/material.dart';

class LicheeButton extends StatelessWidget {
  const LicheeButton({
    Key? key,
    required this.text,
    required this.callback,
    required this.textSize,
  }) : super(key: key);

  final String text;
  final VoidCallback callback;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: callback,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: textSize),
            ),
          ),
        ),
      ),
    );
  }
}
