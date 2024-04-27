import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
                            bottom: 70.0), // Add a bottom margin of 20 pixels
                        child: SizedBox(
                          width: 220.0, // specify the width
                          height: 220.0, // specify the height
                          child: Image.asset('assets/images/appLogo.png'), // Logo
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
                                color: Color(0xFF569AA3), // Different color for the word "LuminaLinq"
                                fontWeight: FontWeight
                                    .normal, // Optional: you can apply different styles too
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Pushes the TextField down
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 50.0,
                        ), // 5px margin from the bottom
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30), // Adjust margin as needed
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.onSurface, // This will change the text field color
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                          overflow: TextOverflow.visible, // This ensures the text wraps if needed
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
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.background), // set opacity here
                      foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('onboarding', true);

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Text(
                      'Get Started',
                      style: Theme.of(context).textTheme.labelSmall,
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
