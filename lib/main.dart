// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'routes/routes.dart';
// import 'screens/capture_screen.dart';
// import 'screens/auth_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Get the list of available cameras on the device
//   final cameras = await availableCameras();
  
//   // Use the first camera (usually rear camera)
//   final firstCamera = cameras.first;

//   runApp(MyApp(firstCamera: firstCamera));  // Pass it to the app
// }

// class MyApp extends StatelessWidget {
//   final CameraDescription firstCamera;

//   const MyApp({super.key, required this.firstCamera});

//   @override
//   Widget build(BuildContext context) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Face Recognition App',
//         theme: ThemeData.dark().copyWith(
//           scaffoldBackgroundColor: const Color(0xFF1E1E1E),
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Colors.black,
//           ),
//         ),
//         initialRoute: '/',           // Start from HomeScreen
//           onGenerateRoute: (settings) {
//         if (settings.name == '/capture') {
//           // Pass the camera argument when navigating to CaptureScreen
//           return MaterialPageRoute(
//             builder: (context) => CaptureScreen(camera: firstCamera),
//           );
//         }
//         else if (settings.name == '/athenticate'){
//           //pass the camera argument when navigating to AuthenticateScreen
//           return MaterialPageRoute(builder: (context) => AuthenticateScreen(camera:firstCamera));
//         }
//         return null;
//         },
//         routes: AppRoutes.getRoutes(), // 💥 Here's the linkage!
//       );
//   }
// }

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'routes/routes_generator.dart';   // <--- NEW
//import 'routes/routes.dart';             // Your existing routes file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  
  RouteGenerator.firstCamera = firstCamera; // 💥 Set camera here

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
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute, // 💥 Now clean
    );
  }
}


