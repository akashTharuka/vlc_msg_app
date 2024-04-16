import 'package:flutter/material.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class StartUp extends StatefulWidget {
  @override
  _StartUpState createState() => _StartUpState();
}

class _StartUpState extends State<StartUp> {
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // Top part with border radius
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white, // Container color with opacity
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0), // Bottom left radius
                    bottomRight: Radius.circular(60.0), // Bottom right radius
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 70,
                          bottom: 70.0), // Add a bottom margin of 20 pixels
                      child: SizedBox(
                        width: 220.0, // specify the width
                        height: 220.0, // specify the height
                        child: Image.asset('assets/appLogo.png'), // Logo
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(
                              120, 130, 131, 1), // Default text color
                        ),
                        children: [
                          TextSpan(
                            text: 'Welcome to ',
                          ),
                          TextSpan(
                            text: 'LuminaLinq',
                            style: TextStyle(
                              color: Color.fromRGBO(86, 154, 163,
                                  1), // Different color for the word "LuminaLinq"
                              fontWeight: FontWeight
                                  .normal, // Optional: you can apply different styles too
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Pushes the TextField down
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 50.0,
                      ), // 5px margin from the bottom
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.9, // 80% of screen width
                        height: 55,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                                color: Colors
                                    .grey, // This will change the hint text color
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: Color.fromRGBO(217, 217, 217,
                                0.22), // This will change the text field color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  7.0), // Border radius here
                              borderSide: BorderSide.none, // No side border
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Add other widgets inside the container if needed
                  ],
                ),
              ),
              // Checkbox and Next Page button below the container
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 30), // Adjust padding as needed
                child: Row(
                  children: [
                    Checkbox(
                      value: _checkboxValue,
                      onChanged: (bool? value) {
                        setState(() {
                          _checkboxValue = value!;
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        'Do you wish to use your mobile credentials as your login details?',
                        overflow: TextOverflow
                            .visible, // This ensures the text wraps if needed
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                          fontWeight: FontWeight.normal, // Set font weight to normal
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.37,
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.8)), // set opacity here
                    foregroundColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.55)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              // Add other widgets below the container if needed
            ],
          ),
        ],
      ),
    );
  }
}
