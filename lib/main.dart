import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/pages/splash_screen.dart';

Future<void> main() async {
  
	WidgetsFlutterBinding.ensureInitialized();
	sqfliteFfiInit();
	final Future<Database> db = DatabaseHelper().db;

	runApp(MyApp(database: await db));
}

class MyApp extends StatelessWidget {

	final Database database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    // custom text theme
    final textTheme = ThemeData.dark().textTheme.copyWith(
        titleLarge: const TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Color(0xff121212),
        ),
        titleMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Color(0xff121212),
        ),
        titleSmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff121212),
        ),
        bodyLarge: const TextStyle(
          fontSize: 20,
          color: Color(0xff121212),
        ),
        bodyMedium: const TextStyle(
          fontSize: 15,
          color: Color(0xFF4B4B4B),
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
          color: Color(0xff121212),
        ),
        labelLarge: const TextStyle(
          fontSize: 12,
          color: Color(0xff121212),
        ),
        labelMedium: const TextStyle(
          fontSize: 16,
          color: Color(0xff121212),
        ),
        labelSmall: const TextStyle(
          fontSize: 14,
          color: Color(0xff121212),
        ));

    const colorScheme = ColorScheme.dark(
      primary: Color(0xff121212), // use for normal text
      secondary: Color(0xff2f3135),
      background: Color(0xFFE1E0E0), // use for scaffold background
      surface: Color(0xff4a545c),
      error: Color(0xFFC7161F), // obviously for errors
      onPrimary: Color(0xff1D1617), // use for box shadows with opacity .11
      onSecondary: Color(0xff83a4a4), // use for hints
      onSurface: Color(0x38D9D9D9), // text field fill color
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LuminaLINQ',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: textTheme,
        colorScheme: colorScheme,
      ),
      home: const SplashScreen(),
    );
  }
}
