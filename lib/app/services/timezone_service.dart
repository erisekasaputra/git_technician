import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';

class TimezoneService {
  Future<void> initializeTimeZones() async {
    // Inisialisasi timezone jika diperlukan
    await FlutterTimezone.getLocalTimezone();
  }

  Future<String> getDeviceTimezone() async {
    // Mendapatkan nama timezone perangkat
    String timezone = await FlutterTimezone.getLocalTimezone();

    return timezone; // Contoh: "Asia/Jakarta"
  }

  Future<Map<String, String>> getDetailedDeviceTimezone() async {
    await initializeTimeZones();

    // Mendapatkan nama timezone
    String timezone = await getDeviceTimezone();

    // Mendapatkan waktu saat ini di timezone tersebut
    final now = DateTime.now()
        .toUtc()
        .add(Duration(hours: DateTime.now().timeZoneOffset.inHours));

    // Menghitung offset
    final offset = now.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetMinutes = offset.inMinutes.remainder(60).abs();

    final offsetSign = offset.isNegative ? '-' : '+';
    final offsetString =
        '$offsetSign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';

    return {
      'name': timezone,
      'abbreviation': DateFormat('zzzz').format(now),
      'offset': offsetString,
      'currentTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
      'isDST': (offset.isNegative && offsetHours < 0) ? 'Yes' : 'No',
    };
  }
}

// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class TimezoneService {
//   static const String _timezoneKey = 'user_timezone';

//   Future<void> initializeTimeZones() async {
//     tz.initializeTimeZones();
//   }

//   Future<String> getDeviceTimezone() async {
//     await initializeTimeZones();
//     // return tz.local.name;
    
//     final location = tz.local;
//     final now = tz.TZDateTime.now(location);
//     final offset = now.timeZoneOffset;
//     final offsetHours = offset.inHours;
//     final offsetMinutes = offset.inMinutes.remainder(60).abs();
    
//     final offsetSign = offset.isNegative ? '-' : '+';
//     final offsetString = '${offsetSign}${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';
    
//     final formatter = DateFormat('zzzz');
//     final timezoneName = formatter.format(now);

//     return '$timezoneName (GMT$offsetString)';
//   }

//    Future<Map<String, String>> getDetailedDeviceTimezone() async {
//     await initializeTimeZones();
//     final location = tz.local;
//     final now = tz.TZDateTime.now(location);
//     final offset = now.timeZoneOffset;
//     final offsetStr = offset.isNegative
//         ? '-${offset.abs().inHours.toString().padLeft(2, '0')}:${(offset.abs().inMinutes % 60).toString().padLeft(2, '0')}'
//         : '+${offset.inHours.toString().padLeft(2, '0')}:${(offset.inMinutes % 60).toString().padLeft(2, '0')}';

//     return {
//       'name': location.name,
//       'abbreviation': now.timeZoneName,
//       'offset': offsetStr,
//       'currentTime': DateFormat('yyyy-MM-dd HH:mm:ss').format(now),
//       'isDST': location.currentTimeZone.isDst ? 'Yes' : 'No',
//     };
//   }

//   Future<void> saveTimezone(String timezone) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_timezoneKey, timezone);
//   }

//   Future<String?> getSavedTimezone() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_timezoneKey);
//   }
// }