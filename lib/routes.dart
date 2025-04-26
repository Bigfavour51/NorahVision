// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
// Later we'll add import for capture_screen.dart and authentication_screen.dart

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const WelcomeScreen(),         // Welcome / Home screen
      '/login': (context) => const LoginScreen(),    // Login screen
      '/dashboard': (context) => const DashboardScreen(), // Dashboard after login
      // '/capture': (context) => const CaptureScreen(),   <-- to be added later
      // '/authentication': (context) => const AuthenticationScreen(), <-- later
    };
  }
}
