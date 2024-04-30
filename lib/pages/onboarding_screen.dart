import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlc_msg_app/db/db_helper.dart';
import 'package:vlc_msg_app/models/user.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';
import 'package:local_auth/local_auth.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _checkboxValue = false;
  bool _validate = false;
  bool _isButtonEnabled = false;

  String error = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkInput() {
    setState(() {
      _validate = _controller.text.isEmpty ||
          !isAlphanumeric(_controller.text) ||
          _controller.text.length < 3 ||
          _controller.text.length > 20;
      _isButtonEnabled = !_validate;
    });
  }

  bool isAlphanumeric(String input) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumeric.hasMatch(input);
  }

  void _saveUser(User user) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.saveUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top part with border radius
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white, // Container color with opacity
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0), // Bottom left radius
                      bottomRight: Radius.circular(30.0), // Bottom right radius
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 70,
                            bottom: 50.0), // Add a bottom margin of 20 pixels
                        child: SizedBox(
                          width: 220.0, // specify the width
                          height: 220.0, // specify the height
                          child:
                              Image.asset('assets/images/appLogo.png'), // Logo
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleSmall,
                          children: const [
                            TextSpan(
                              text: 'Welcome to ',
                            ),
                            TextSpan(
                              text: 'LuminaLinq',
                              style: TextStyle(
                                color: Color(
                                    0xFF569AA3), // Different color for the word "LuminaLinq"
                                fontWeight: FontWeight
                                    .normal, // Optional: you can apply different styles too
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10), // Pushes the TextField down
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10.0,
                        ), // 5px margin from the bottom
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 30), // Adjust margin as needed
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .onSurface, // This will change the text field color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _checkboxValue,
                        activeColor: Theme.of(context).colorScheme.onSecondary,
                        checkColor: Theme.of(context).colorScheme.onPrimary,
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  height: MediaQuery.of(context).size.height * 0.06,
                  margin: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context)
                              .colorScheme
                              .background), // set opacity here
                      foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    onPressed: _isButtonEnabled
                        ? () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('onboarding', true);

                            if (!mounted) return;

                            final User user = User(
                              name: _controller.text,
                              privateKey: '',
                              publicKey: '',
                              mobileUnlock: _checkboxValue ? 1 : 0,
                            );

                            try {
                              _saveUser(user);
                              if (_checkboxValue) {
                                bool isAuthenticated = false;
                                try {
                                  isAuthenticated =
                                      await _localAuth.authenticate(
                                    localizedReason:
                                        'Please authenticate to proceed',
                                  );
                                } catch (e) {
                                  print('LocalAuth error: $e');
                                }

                                if (isAuthenticated) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                  );
                                }

                                // If the checkbox is ticked, show a dialog to enter the phone PIN
                                // showDialog(
                                //   context: context,
                                //   builder: (context) {
                                //     return AlertDialog(
                                //       title: Text('Enter Phone PIN'),
                                //       content: TextField(
                                //         obscureText:
                                //             true, // Use this to hide the entered text
                                //         onChanged: (value) {
                                //           // Handle the entered PIN here
                                //         },
                                //       ),
                                //       actions: [
                                //         TextButton(
                                //           onPressed: () {
                                //             Navigator.pop(
                                //                 context); // Close the dialog
                                //             Navigator.pushReplacement(
                                //               context,
                                //               MaterialPageRoute(
                                //                   builder: (context) =>
                                //                       HomeScreen()),
                                //             );
                                //           },
                                //           child: Text('OK'),
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // );
                              } else {
                                // If the checkbox is not ticked, navigate to the home page directly
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              }
                            } on Exception catch (e) {
                              setState(() {
                                error = e.toString();
                              });
                            }
                          }
                        : null,

                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => HomeScreen()),
                    //     );
                    //   } on Exception catch (e) {
                    //     setState(() {
                    //       error = e.toString();
                    //     });
                    //   }

                    // } : null,
                    child: Text(
                      'Get Started',
                      style: _isButtonEnabled
                          ? Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.w700)
                          : Theme.of(context).textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                ),
                // Add other widgets below the container if needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
