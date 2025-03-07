import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart'; // Your login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAW7Mxis9z09roxP6FTL4vESxmcroHRQE0",
      authDomain: "test1-5e594.firebaseapp.com",
      projectId: "test1-5e594",
      storageBucket: "test1-5e594.appspot.com",
      messagingSenderId: "875484146858",
      appId: "1:875484146858:android:f0f962e21801335e8034d3",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.red),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, // Ensures text field background is visible
          fillColor: Colors.grey[900], // Dark grey background for TextField
          hintStyle: TextStyle(color: Colors.grey), // Hint text color
          labelStyle: TextStyle(color: Colors.white), // Label text color
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Border when focused
          ),
        ),
      ),
      home: LoginPage(), // Redirects to Login Page
    );
  }
}
