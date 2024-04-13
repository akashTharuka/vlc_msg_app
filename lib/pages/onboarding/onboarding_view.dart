import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            ? getStarted(context)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  skipButton(context),
                  smoothPageIndicator(),
                  nextButton(context),
                ],
              ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: PageView.builder(
          onPageChanged: (index) => setState(() =>
              isLastPage = controller.onboardingInfoItems.length == index),
          itemCount: controller.onboardingInfoItems.length + 1,
          controller: pageController,
          itemBuilder: (context, index) {
            if (index == controller.onboardingInfoItems.length) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff1D1617).withOpacity(0.11),
                          spreadRadius: 0,
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Image.asset('assets/images/Men talking-amico.png'),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
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
                            'Do you wish to use your device credentials as your app lock?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Text(controller.onboardingInfoItems[index].description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  TextButton nextButton(BuildContext context) {
    return TextButton(
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
    );
  }

  SmoothPageIndicator smoothPageIndicator() {
    return SmoothPageIndicator(
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
    );
  }

  TextButton skipButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        pageController.jumpToPage(controller.onboardingInfoItems.length);
      },
      child: Text(
        'Skip',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget getStarted(context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      ),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('onboarding', true);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Text(
          "Get Started",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
