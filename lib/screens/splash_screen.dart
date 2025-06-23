import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _title = "";
  final String fullTitle = "BugFinder";
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _animateText();
    _navigateToHome();
  }

  void _animateText() {
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (_index < fullTitle.length) {
        setState(() {
          _title += fullTitle[_index];
          _index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E5C3F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo2.png',
              width: 160,
              height: 160,
            ),
            SizedBox(height: 20),
            Text(
              _title,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Insect Identification',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}