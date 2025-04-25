import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Get the available cameras on the device
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
final CameraDescription camera;

  const MyApp({super.key, required this.camera});

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
      home: HomeScreen(camera: camera),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;
  const HomeScreen({super.key, required this.camera});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  // Capture image function
  Future<void> _captureImage() async {
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Get the temporary directory for saving images
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Capture the image and save it to the directory
      await _cameraController.takePicture().then((XFile file) async {
        // Save the image to the file path
        file.saveTo(imagePath);

        // Show a snackbar with the file path for demonstration
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to $imagePath')),
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error capturing image: $e');
      }
    }
  }

  // Button animation function
  void _animateButton() {
    setState(() {
      _buttonScale = 1.2; // Scale up button on press
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _buttonScale = 1.0; // Scale back to original size
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Recognition"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to Vision AI",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Camera-based face detection system",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Camera preview
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // Show camera preview
                    return CameraPreview(_cameraController);
                  } else {
                    // Show a loading indicator while initializing the camera
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  _animateButton();
                  _captureImage(); // Capture image when button is pressed
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
                        "Capture Image",
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
      ),
    );
  }
}




