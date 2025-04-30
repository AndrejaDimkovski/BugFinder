import 'package:bugfinder/screens/recognition_screen.dart';
import 'package:bugfinder/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BugFinder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Копче за препознавање инсект
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InsectRecognitionScreen()),
                );
              },
              child: Text('Препознај инсект'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Копче за историја на препознавања
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text('Историја на препознавања'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Додај копче за тестирање на Azure Vision API
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestAzureScreen()), // Навигација до тест страната
                );
              },
              child: Text('Тестирај Azure Vision API'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}