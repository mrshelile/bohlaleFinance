import 'package:bohlalefinance/onboarding/onboarding.dart';
import 'package:bohlalefinance/util/colors.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoarding()), // Replace `NextPage` with your target page.
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Container(
          width: 250,
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/logo.png')),
          ),
        ),
      ),
    );
  }
}

// Replace this with your actual next page widget.
class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Next Page')),
      body: const Center(child: Text('Welcome to the next page!')),
    );
  }
}
