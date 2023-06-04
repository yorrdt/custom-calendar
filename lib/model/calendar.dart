import 'package:intl/intl.dart';

class Calendar {
  static DateTime getFirstDayOfMonth(DateTime dt) {
    return DateTime(dt.year, dt.month, 1, dt.hour, dt.minute, dt.second, dt.millisecond, dt.microsecond);
  }

  static int getDayNumber(DateTime dt) {
    return int.parse(DateFormat.d().format(dt));
  }

  static String getDayName(DateTime dt) {
    return DateFormat.EEEE().format(dt);
  }

  static String getMonthName(DateTime dt) {
    return DateFormat.LLLL().format(dt);
  }

  static int getYear(DateTime dt) {
    return int.parse(DateFormat.y().format(dt));
  }

  static DateTime getFirstDayOfWeek(DateTime dt) {
    return dt.subtract(Duration(days: dt.weekday - 1));
  }

  static bool isEqaulsYMd(DateTime dt1, DateTime dt2) {
    return (dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day);
  }

  static bool isNotEqaulsYMd(DateTime dt1, DateTime dt2) {
    return !(dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day);
  }
}
