import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get monthName {
    return DateFormat('MMMM').format(this);
  }

  int get totalDays {
    DateTime firstDayThisMonth = DateTime(year, month, 1);
    DateTime firstDayNextMonth = DateTime(year, month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }
}
