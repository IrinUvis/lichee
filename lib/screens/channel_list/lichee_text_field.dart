import 'package:flutter/material.dart';

class LicheeTextField extends StatefulWidget {
  const LicheeTextField({
    Key? key,
    required this.getText,
    required this.decoration,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  final Function(String text) getText;
  final TextInputType textInputType;
  final int? maxLines;
  final InputDecoration decoration;

  @override
  _LicheeTextFieldState createState() => _LicheeTextFieldState();
}

class _LicheeTextFieldState extends State<LicheeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF363636),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: (value) {
          widget.getText(value);
        },
        decoration: widget.decoration,
        maxLines: widget.maxLines,
      ),
    );
  }
}
