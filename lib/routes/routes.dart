// lib/routes.dart
import 'package:flutter/material.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
// import 'screens/capture_screen.dart'; 
// import '../screens/auth_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const WelcomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
    
// ... other routes

      // '/capture': (context) => const CaptureScreen(camera: /* pass camera here */),
      // '/authenticate': (context) => const AuthenticateScreen(),
    };
  }
}
