import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vlc_msg_app/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LuminaLINQ',
      theme: ThemeData(
        useMaterial3: true,

        // defeault brightness and colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple.shade50,
          primary: Colors.yellow.shade700,
          brightness: Brightness.dark,
          background: const Color(0xffeef1f5),
        ),

        // default text theme
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          displaySmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black26,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
