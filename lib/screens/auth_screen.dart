import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class AuthScreen extends StatelessWidget {
  final CameraDescription camera;
  const AuthScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authenticate")),
      body: const Center(
        child: Text("Authentication logic will go here"),
      ),
    );
  }
}
