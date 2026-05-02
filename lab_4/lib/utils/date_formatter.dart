import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDay(DateTime dt) =>
      DateFormat('EEEE, MMM d').format(dt);

  static String formatHour(DateTime dt) =>
      DateFormat('HH:mm').format(dt);

  static String formatShortDay(DateTime dt) =>
      DateFormat('EEE').format(dt);

  static String formatDate(DateTime dt) =>
      DateFormat('MMM d').format(dt);

  static String formatTime(DateTime dt) =>
      DateFormat('HH:mm').format(dt);
}