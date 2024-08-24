import 'package:intl/intl.dart';

class FormattingUtils {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(dateTime);
  }
}
