import 'package:flutter/material.dart';

class DateTimeManager {
  static String currentDateTime() {
    var date = DateTime.now();
    return '${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}';
  }

  static String dateFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String timeFormat(TimeOfDay time) {
    return ' ${time.hour}:${time.minute}';
  }
}
