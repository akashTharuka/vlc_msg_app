import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vlc_msg_app/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          fontSize: 16,
          color: Color(0xff121212),
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
          color: Color(0xff121212),
        ),
        labelLarge: const TextStyle(
          fontSize: 20,
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
      primary: Color(0xff121212),
      secondary: Color(0xff2f3135),
      background: Color(0xffbcbcbc),
      surface: Color(0xff4a545c),
      error: Color(0xFFC7161F),
      onPrimary: Color(0xff657b81),
      onSecondary: Color(0xff83a4a4),
      onSurface: Color(0xffa9cec2),
      onError: Color(0xff1D1617),
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
