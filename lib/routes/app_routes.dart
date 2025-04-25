import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/capture_screen.dart';
import '../screens/auth_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(CameraDescription camera) {
    return {
      '/': (context) => const WelcomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/capture': (context) => CaptureScreen(camera: camera),
      '/auth': (context) => AuthScreen(camera: camera),
    };
  }
}
