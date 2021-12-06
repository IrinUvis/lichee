import 'package:flutter/material.dart';
import 'package:lichee/screens/auth/auth_type.dart';

import '../../../constants.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.padding,
    required this.radius,
    required this.authType
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final double radius;
  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
        child: Center(
        child: Text(
          authType.getName().capitalize(),
          style: kLicheeTextStyle,
        ),
      ),
    );
  }
}