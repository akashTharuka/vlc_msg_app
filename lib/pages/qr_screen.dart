import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {

  final DatabaseHelper dbHelper = DatabaseHelper();

  String qrData = 'public key here';
  String error = '';

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    try {
      User user = await dbHelper.getUser();
      qrData = jsonEncode(user.toMap());
    } catch (e) {
      error = e.toString();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // The Container with the background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'), // replace with your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // The Scaffold with your widgets
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar(context),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: QrImageView(data: qrData),
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // here too
      elevation: 0, // and here
      leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          color: Theme.of(context).colorScheme.background,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // TODO: Navigate to settings screen
          },
          color: Theme.of(context).colorScheme.background,
        ),
      ],
    );
  }
}