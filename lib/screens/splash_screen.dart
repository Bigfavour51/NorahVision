import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'welcome_screen.dart'; // Import your WelcomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to WelcomeScreen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG Logo
            SizedBox(
              height: 150,
              child: SvgPicture.asset(
                'assets/norahvision_logo.svg',
                semanticsLabel: 'NorahVision Logo',
              ),
            ),
            const SizedBox(height: 30),
            // Loading spinner
            const CircularProgressIndicator(
              color: Color(0xFF3D5AFE),
            ),
          ],
        ),
      ),
    );
  }
}
