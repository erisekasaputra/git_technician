import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;

extension CustomDateTimeExtension on DateTime {
  DateTime utcToLocal(String targetTimeZone) {
    final location = tz.getLocation(targetTimeZone);
    return tz.TZDateTime.from(this, location);
  }

  String toHumanReadable({bool withTime = true}) {
    final datePart = DateFormat('d MMMM yyyy').format(this);
    final timePart = DateFormat('h:mm a').format(this);
    return '$datePart${withTime ? ', $timePart' : ''}';
  }
}
