import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticateScreen extends StatefulWidget {
  final CameraDescription camera;
  const AuthenticateScreen({super.key, required this.camera});

  @override
  State<AuthenticateScreen> createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double _buttonScale = 1.0;
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _captureAndAuthenticateFace() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      await _cameraController.takePicture().then((XFile file) async {
        file.saveTo(imagePath);

        // Load image and detect faces
        final inputImage = InputImage.fromFilePath(imagePath);
        final List<Face> faces = await _faceDetector.processImage(inputImage);

        if (faces.isEmpty) {
          // No face detected
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No face detected.')));
        } else {
          // Face detected, proceed to authentication logic
          bool isAuthenticated = await _authenticateFace(faces);
          
          if (isAuthenticated) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication successful!')));
            // Redirect to dashboard or main screen
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Face not recognized. Please try again.')));
          }
        }
      });
    } catch (e) {
      if (kDebugMode) print('Error during face detection: $e');
    }
  }

  // Simulating authentication logic - in a real case, you would match against stored faces/embeddings
  Future<bool> _authenticateFace(List<Face> detectedFaces) async {
    // Here, you would compare the detected faces with the stored faces (using embeddings or images)
    // For simplicity, let's assume a match is always found.
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay for matching
    return true;  // In reality, return true if the face is recognized; false if not
  }

  void _animateButton() {
    setState(() => _buttonScale = 1.2);
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _buttonScale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authenticate Face")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CameraPreview(_cameraController),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _animateButton();
                  _captureAndAuthenticateFace();
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
                    ),
                    child: const Center(
                      child: Text("Authenticate", style: TextStyle(color: Colors.white, fontSize: 18)),
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
