// lib/main.dart
import 'package:flutter/material.dart';
import 'routes.dart'; // import routes.dart here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Recognition App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
          ),
        ),
        initialRoute: '/',            // Start from HomeScreen
        routes: AppRoutes.getRoutes(), // 💥 Here's the linkage!
      );
  }
}

