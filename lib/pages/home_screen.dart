import 'package:flutter/material.dart';
import 'package:vlc_msg_app/pages/contacts/contacts_screen.dart';
import 'package:vlc_msg_app/pages/msg_compose_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hello Lasith!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MsgComposeScreen(),
                      ),
                    );
                  },
                  child: const Text('Send Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add receive message functionality
                  },
                  child: const Text('Receive Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add message history functionality
                  },
                  child: const Text('Message History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactScreen(),
                      ),
                    );
                  },
                  child: const Text('Contacts'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // TODO: Add logout functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () {
                // TODO: Add view QR code functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
