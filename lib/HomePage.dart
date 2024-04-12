import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vlc_msg_app/StartUp.dart';
import 'package:vlc_msg_app/SendMessage.dart';
import 'package:vlc_msg_app/ReceiveMessage.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // The Container with the background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/background.jpg'), // replace with your image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // The Scaffold with your widgets
        Scaffold(
          backgroundColor:
              Colors.transparent, // it's important to make it transparent
          appBar: AppBar(
            backgroundColor: Colors.transparent, // here too
            elevation: 0, // and here
            actions: [
              IconButton(
                icon: Image.asset('assets/settings.png'),
                onPressed: () {
                  // TODO: Navigate to settings screen
                },
              ),
            ],
          ),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: Image.asset('assets/BareLogo.png'),
                ),
                Text(
                  'Hello Lasith!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // 60% of screen width // specify the width
                      height: 80, // specify the height
                      margin: EdgeInsets.only(bottom: 15, top: 18),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white
                              .withOpacity(0.8)), // set opacity here
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
                            MaterialPageRoute(
                                builder: (context) => SendMessagePage()),
                          );
                        },
                        child: Text('Send Message'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // specify the width
                      height: 80, // specify the height
                      margin: EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white
                              .withOpacity(0.8)), // set opacity here
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
                            MaterialPageRoute(
                                builder: (context) => ReceiveMessagePage()),
                          );
                        },
                        child: Text('Receive Message'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // specify the width
                      height: 80, // specify the height
                      margin: EdgeInsets.only(bottom: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white
                              .withOpacity(0.8)), // set opacity here
                          foregroundColor: MaterialStateProperty.all(
                              Colors.black.withOpacity(0.55)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          // TODO: Add message history functionality
                        },
                        child: Text('Message History'),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.8, // specify the width
                      height: 80, // specify the height
                      margin: EdgeInsets.only(bottom: 25),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white
                              .withOpacity(0.8)), // set opacity here
                          foregroundColor: MaterialStateProperty.all(
                              Colors.black.withOpacity(0.55)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          // TODO: Add contacts functionality
                        },
                        child: Text('Contacts'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 50.0, // specify the width
                      height: 50.0, // specify the height
                      child: IconButton(
                        icon: Image.asset('assets/qrcode.png'),
                        onPressed: () {
                          // TODO: Add view QR code functionality
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.4, // specify the width
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors
                              .white
                              .withOpacity(0.8)), // set opacity here
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
                            MaterialPageRoute(builder: (context) => StartUp()),
                          );
                        },
                        child: Text('Log Out'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
