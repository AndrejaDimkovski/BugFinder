import 'package:bugfinder/screens/history_screen.dart';
import 'package:bugfinder/screens/home_screen.dart';
import 'package:bugfinder/screens/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BugFinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Почетниот екран на апликацијата
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}