import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';
import 'package:vlc_msg_app/pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingCompleted = prefs.getBool('onboarding') ?? false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                onboardingCompleted ? const HomeScreen() :  const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // The Container with the background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'), // replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // The Scaffold with your widgets
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'lumina',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'LINQ',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24, // Adjust the value as needed
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Powered by Flutter',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
