import 'package:flutter/material.dart';

extension CustomColorScheme on ColorScheme {
  Color get primary_0 => brightness == Brightness.light ? const Color(0xFF8AC7F1) : const Color(0xFF1A5D8A);
  Color get primary_25 => brightness == Brightness.light ? const Color(0xFF7AB9E2) : const Color(0xFF1E6B9E);
  Color get primary_50 => brightness == Brightness.light ? const Color(0xFF6BAAD4) : const Color(0xFF2279B2);
  Color get primary_100 => brightness == Brightness.light ? const Color(0xFF3D7EA9) : const Color(0xFF2A94D6);
  Color get primary_200 => brightness == Brightness.light ? const Color(0xFF1F608D) : const Color(0xFF32AFFA);
  Color get primary_300 => brightness == Brightness.light ? const Color(0xFF004370) : const Color(0xFF66C4FF);

  Color get secondary_0 => brightness == Brightness.light ? const Color(0xFFEBF8FD) : const Color(0xFF004D40);
  Color get secondary_25 => brightness == Brightness.light ? const Color(0xFFD8F1FB) : const Color(0xFF00796B);
  Color get secondary_50 => brightness == Brightness.light ? const Color(0xFFB1E3F8) : const Color(0xFF009688);
  Color get secondary_100 => brightness == Brightness.light ? const Color(0xFF8AD6F4) : const Color(0xFF00BFAE);
  Color get secondary_200 => brightness == Brightness.light ? const Color(0xFF63C8F1) : const Color(0xFF00B8A9);
  Color get secondary_300 => brightness == Brightness.light ? const Color(0xFF3CBAED) : const Color(0xFF00ACC1);


  Color get warning_0 => const Color(0xFFFFF7E7);
  Color get warning_25 => const Color(0xFFFFEFD0);
  Color get warning_50 => const Color(0xFFFFE7B8);
  Color get warning_100 => const Color(0xFFFFD072);
  Color get warning_200 => const Color(0xFFFFC043);
  Color get warning_300 => const Color(0xFFFFB014);

  Color get alert_0 => const Color(0xFFFFEBEC);
  Color get alert_25 => const Color(0xFFFFD8D8);
  Color get alert_50 => const Color(0xFFFFC4C5);
  Color get alert_100 => const Color(0xFFFF898B);
  Color get alert_200 => const Color(0xFFFF6164);
  Color get alert_300 => const Color(0xFFFF3A3D);

  Color get success_0 => const Color(0xFFEFF8D8);
  Color get success_25 => const Color(0xFFE4F1C1);
  Color get success_50 => const Color(0xFFD9EBA9);
  Color get success_100 => const Color(0xFFB7D864);
  Color get success_200 => const Color(0xFFA1CC35);
  Color get success_300 => const Color(0xFF8BBF07);

  Color get button_text_01 => brightness == Brightness.light ? Colors.white : Colors.black;
  Color get text_01 => brightness == Brightness.light ? Colors.white : Colors.black;

  Color get borderInput_01 => const Color(0xFFDFE1E7);
}

class AppTheme {
  static const Color primaryColor = Color(0xFF004370);
  static const Color primaryLightColor = Color(0xFF303030);
  static const Color primaryDarkColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryLightColor = Color(0xFF66FFF8);
  static const Color secondaryDarkColor = Color(0xFF00A896);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Saira',
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryLightColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryLightColor,
    ),
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    fontFamily: 'Saira',
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryDarkColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryDarkColor,
    ),
    appBarTheme: const AppBarTheme(
      color: primaryDarkColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryDarkColor,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// Cara penggunaan:
  // Color primaryColor = Theme.of(context).colorScheme.primary;
  // Color secondaryColor = Theme.of(context).colorScheme.secondary;
  // Color primary0Color = Theme.of(context).colorScheme.primary_0;
  // Color primary100Color = Theme.of(context).colorScheme.primary_100;

  // // Mengakses gaya teks
  // TextStyle titleStyle = Theme.of(context).textTheme.titleLarge!;
  // TextStyle bodyStyle = Theme.of(context).textTheme.bodyMedium!;

  // // Mengakses tema AppBar
  // Color appBarColor = Theme.of(context).appBarTheme.backgroundColor!;