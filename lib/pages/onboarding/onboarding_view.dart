import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vlc_msg_app/pages/home_screen.dart';
import 'package:vlc_msg_app/pages/onboarding/onboarding_items.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // skip button
                  TextButton(
                    onPressed: () {
                      pageController
                          .jumpToPage(controller.onboardingInfoItems.length);
                    },
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  // page indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.onboardingInfoItems.length + 1,
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    ),
                    effect: const WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                    ),
                  ),

                  // next button
                  TextButton(
                    onPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
      ),
      body: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: PageView.builder(
          onPageChanged: (index) => setState(() =>
              isLastPage = controller.onboardingInfoItems.length == index),
          itemCount: controller.onboardingInfoItems.length + 1,
          controller: pageController,
          itemBuilder: (context, index) {
            if (index == controller.onboardingInfoItems.length) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Men talking-amico.png'),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Check this box to set the device lock as your password',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(controller.onboardingInfoItems[index].image),
                  const SizedBox(height: 15),
                  Text(
                    controller.onboardingInfoItems[index].title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(controller.onboardingInfoItems[index].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      )),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary,
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: const Text(
          "Get Started",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
