import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
            Text(
              'Hello Lasith!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add send message functionality
                  },
                  child: Text('Send Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add receive message functionality
                  },
                  child: Text('Receive Message'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add message history functionality
                  },
                  child: Text('Message History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add contacts functionality
                  },
                  child: Text('Contacts'),
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
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // TODO: Add logout functionality
              },
            ),
            IconButton(
              icon: Icon(Icons.qr_code),
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