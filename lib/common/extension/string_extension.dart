import 'package:intl/intl.dart';

extension StringExtension on String? {
  String get fullDateDMMMMY {
    return DateFormat('d MMM y', 'id_ID').format(
      this != null ? DateTime.parse(this!) : DateTime.now(),
    );
  }
}
