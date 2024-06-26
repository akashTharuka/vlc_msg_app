import 'package:flutter/material.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:vlc_msg_app/pages/receive_message.dart';
import 'package:vlc_msg_app/pages/contacts_screen.dart';
import 'package:vlc_msg_app/pages/message_history.dart';
import 'package:vlc_msg_app/pages/onboarding_screen.dart';
import 'package:vlc_msg_app/pages/qr_screen.dart';
import 'package:vlc_msg_app/pages/send_msg_screen.dart';
import 'package:vlc_msg_app/pages/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String currentUserName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    try {
      User user = await dbHelper.getUser();
      setState(() {
        currentUserName = user.name;
      });
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
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
              image: AssetImage(
                  'assets/images/background.jpg'), // replace with your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // The Scaffold with your widgets
        Scaffold(
          backgroundColor: Colors.transparent, // it's important to make it transparent
          appBar: appBar(context),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 0, bottom: 32, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: Image.asset('assets/images/BareLogo.png'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15.0), // specify the top margin
                  child: Text(
                    'Hello ${currentUserName ?? 'Guest'}!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    sendMessage(context),
                    receiveMessage(context),
                    messageHistory(context),
                    contacts(context),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    qrGenerator(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      
      backgroundColor: Colors.transparent, // here too
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
          color: Theme.of(context).colorScheme.background,
        ),
      ],
    );
  }

  Container logout(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Colors.white.withOpacity(0.9)),
          foregroundColor: MaterialStateProperty.all(
              Colors.black.withOpacity(0.55)),
          shape:
              MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        },
        child: Text(
          'Log Out',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  SizedBox qrGenerator(context) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: IconButton(
        icon: const Icon(Icons.qr_code),
        color: Theme.of(context).colorScheme.background,
        onPressed: () {
          // navigate to the screen with the QR image
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const QRScreen()),
          );
        },
      ),
    );
  }

  Container contacts(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.only(bottom: 25),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
          foregroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactScreen()));
        },
        child: Text(
          'Contacts',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Container messageHistory(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
          foregroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MsgHistory()));
        },
        child: Text(
          'Message History',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Container receiveMessage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
          foregroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveMessagePage()));
        },
        child: Text(
          'Receive Message',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Container sendMessage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.only(bottom: 15, top: 18),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.9)), // set opacity here
          foregroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.55)),
          shape:MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const SendMsgScreen()));
        },
        child: Text(
          'Send Message',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
