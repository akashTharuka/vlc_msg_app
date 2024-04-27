import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _nameController = TextEditingController();
  String accountName = 'John Doe'; // Initial account name

  @override
  void initState() {
    super.initState();
    _nameController.text = accountName;
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
          backgroundColor:
              Colors.transparent, // it's important to make it transparent
          appBar: AppBar(
            backgroundColor: Colors.transparent, // here too
            elevation: 0, // and here
          ),
          body: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.only(top: 0, bottom: 32, left: 20, right: 20),
            child: SingleChildScrollView(
              // Add this
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: Image.asset('assets/images/BareLogo.png'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 15.0), // specify the top margin
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Account Name',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(230, 239, 239,
                              239), // Change this to your desired color
                        ),
                        hintText: _nameController.text.isEmpty
                            ? 'Enter account name'
                            : _nameController.text,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: <Widget>[
                      Text(
                        'Use Phone PIN',
                        style: TextStyle(
                          color: Color.fromARGB(230, 239, 239,
                              239), // Change this to your desired color
                        ),
                      ),
                      SizedBox(width: 180),
                      Switch(
                        value:
                            false, // replace with your logic to determine the initial value
                        onChanged: (bool value) {
                          // Add your code here to handle the switch state change
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 200),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.05,
                      margin: EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(
                                  230, 239, 239, 239)), // set opacity here
                          foregroundColor: MaterialStateProperty.all(
                              Colors.black.withOpacity(0.55)),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            accountName = _nameController.text;
                          });
                        },
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
