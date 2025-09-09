import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

void showToast(
  String msg, {
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.BOTTOM,
  int timeInSecForIosWeb = 1,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}

getTimePicker(context, {required Function(TimeOfDay) onUpdate}) {
  showTimePicker(
    initialEntryMode: TimePickerEntryMode.dial,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            // change the border color
            primary: AppColor.primary,
            // change the text color
            onSurface: AppColor.primary,
            surface: Colors.white,

            onSecondary: Colors.white,

            onBackground: AppColor.primary,
          ),
        ),
        child: child!,
      );
    },
    context: context,
    initialTime: TimeOfDay.now(),
  ).then((value) {
    if (value != null) {
      onUpdate(value);
    }
  });
}

bool isOverOneHourOld(String? dateTimeString) {
  if (dateTimeString == null) {
    return false;
  }

  DateTime dateTime = DateTime.parse(dateTimeString);
  final now = DateTime.now();
  final difference = now.difference(dateTime).inHours;

  return difference <= 1;
}

bool isOverTwentyFourHoursOld(String? dateTimeString) {
  if (dateTimeString == null) {
    return true;
  }

  DateTime dateTime = DateTime.parse(dateTimeString);
  final now = DateTime.now();
  final difference = now.difference(dateTime).inHours;
  return difference >= 24;
}
