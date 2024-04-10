import 'package:flutter/material.dart';

class SendMessagePage extends StatelessWidget {
  const SendMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          const Text(
                  'Send Message',
                  style: TextStyle(fontSize: 20),
                ),
          SizedBox(
            height: 50,
            
            child: Image.asset('assets/BareLogo.png'),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Search contacts',
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter a message',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement send message functionality
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
