import 'package:flutter/material.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Logo and Welcome Text
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Image.asset('assets/appLogo.png'),
                const Text(
                  'Welcome to LuminaLinq',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter text',
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: _checkboxValue,
                onChanged: (bool? value) {
                  setState(() {
                    _checkboxValue = value!;
                  });
                },
              ),
              const Text('Checkbox'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to the next page
            },
            child: const Text('Next Page'),
          ),
        ],
      ),
    );
  }
}
