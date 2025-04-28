import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';





class CaptureScreen extends StatefulWidget {
  final CameraDescription camera;
  const CaptureScreen({super.key, required this.camera});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}



class _CaptureScreenState extends State<CaptureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  double _buttonScale = 1.0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await _cameraController.takePicture().then((XFile file) async {
        file.saveTo(imagePath);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image saved to $imagePath')));
      });
    } catch (e) {
      if (kDebugMode) print('Error capturing image: $e');
    }
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
      appBar: AppBar(title: const Text("Capture Face")),
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
                  _captureImage();
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
                      child: Text("Capture Image", style: TextStyle(color: Colors.white, fontSize: 18)),
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
