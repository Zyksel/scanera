import 'package:intl/intl.dart';

class AppDateFormatters {
  static DateFormat get dayMonthYearWithTime =>
      DateFormat("dd.MM.yyyy HH:mm:ss");

  static DateFormat get hourMinuteSecond => DateFormat("HH:mm:ss");

  static DateFormat get hourMinuteSecondMillisecond => DateFormat("HH:mm:ss.S");
}
