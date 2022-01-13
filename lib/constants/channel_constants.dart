import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';

const kAppBarTitleTextStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);

const kCancelAlertDialogText = TextStyle(
  fontSize: 18.0,
  color: Colors.grey,
  fontWeight: FontWeight.bold,
);

const kSendAlertDialogText = TextStyle(
  fontSize: 18.0,
  color: LicheeColors.primary,
  fontWeight: FontWeight.bold,
);

const kReportInputDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: LicheeColors.primary),
  ),
);

const kDescriptiveText = TextStyle(
  color: Colors.grey,
);