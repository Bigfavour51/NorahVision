import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  double _buttonScale = 1.0;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  // Initialize the camera
  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameras = cameras;
    if (_cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0], // Select the first camera (usually the rear camera)
        ResolutionPreset.high,
      );

      try {
        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing camera: $e');
        }

        setState(() {
          _isCameraInitialized = false; // Handle error state
        });
      }
    }
  }

  // Animate the button on tap
  void _animateButton() {
    setState(() {
      _buttonScale = 1.2; // Scale up button on press
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _buttonScale = 1.0; // Scale back to original size
      });
      _initializeCamera();  // Initialize camera on button press
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Don't forget to dispose of the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Recognition"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to NorahVision",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Camera-based AI-powered facial detection system",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _isCameraInitialized
                ? Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: CameraPreview(_cameraController!),
                  )
                : const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _animateButton();
                // Trigger the camera initialization
              },
              child: AnimatedScale(
                scale: _buttonScale,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Start Camera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
