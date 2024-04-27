import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SendMessagePage extends StatelessWidget {
  const SendMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the Scaffold background transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/background.jpg'), // replace with your image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  top: 48, bottom: 32, left: 32, right: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: Image.asset('assets/images/BareLogo.png'),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: 15.0), // specify the top margin
                    child: Text(
                      'Send Message',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Container(
                    // 5px margin from the bottom
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // 80% of screen width
                      height: 55,
                      child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          hintText: 'Search contacts',
                          hintStyle: TextStyle(
                              color: Colors
                                  .grey, // This will change the hint text color
                              fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: Color.fromARGB(220, 232, 232,
                              232), //will change the text field color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                7.0), // Border radius here
                            borderSide: BorderSide.none, // No side border
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Pushes the TextField down
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    margin: EdgeInsets.only(
                        top: 10, bottom: 20), // Adjust margins as needed
                    decoration: BoxDecoration(
                      color: Color.fromARGB(227, 255, 255,
                          255), // Background color of the text box
                      borderRadius: BorderRadius.circular(
                          10.0), // Border radius of the text box
                    ),
                    child: TextField(
                      maxLines:
                          null, // Set the number of lines for the text box
                      decoration: InputDecoration(
                        hintText:
                            'Enter your message here...', // Placeholder text
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color:
                                const Color.fromARGB(222, 158, 158, 158)), // Style for the placeholder text
                        border: InputBorder
                            .none, // Remove the default underline border
                        contentPadding:
                            EdgeInsets.all(10.0), // Padding inside the text box
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.37,
                    height: MediaQuery.of(context).size.height * 0.05,
                    margin: EdgeInsets.only(top: 15),
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
                        // Navigator.push(
                        //   // context,
                        //   // MaterialPageRoute(builder: (context) => HomeScreen()),
                        // );
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
