import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';

import '../screens/capture_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/login_screen.dart'; // Example, your login page
import '../screens/dashboard_screen.dart'; // Your dashboard

class RouteGenerator {
  static late CameraDescription firstCamera;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/capture':
        return MaterialPageRoute(
          builder: (context) => CaptureScreen(camera: firstCamera),
        );
      case '/authenticate':
        return MaterialPageRoute(
          builder: (context) => AuthenticateScreen(camera: firstCamera),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case '/dashboard':
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        );
      case '/':
      default:
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),  // Default is login
        );
    }
  }
}
