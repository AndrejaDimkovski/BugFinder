import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/azure_vision_service.dart';
import '../screens/insect_description_screen.dart';
import '../screens/home_screen.dart';

class InsectRecognitionScreen extends StatefulWidget {
  @override
  _InsectRecognitionScreenState createState() => _InsectRecognitionScreenState();
}

class _InsectRecognitionScreenState extends State<InsectRecognitionScreen> {
  final AzureVisionService _azureVisionService = AzureVisionService();
  final ImagePicker _picker = ImagePicker();

  Future<void> _recognizeInsect(String imagePath) async {
    try {
      final insect = await _azureVisionService.processInsectImage(imagePath);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsectDescriptionScreen(insect: insect),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Грешка при препознавање на инсектот.")),
      );
    }
  }

  Future<void> _getImage(bool fromCamera) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (pickedFile != null) {
      await _recognizeInsect(pickedFile.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Нема избрано слика.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Препознај инсект преку камера',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF2E7D32),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(Icons.camera_alt, size: 30),
                        label: Text("Камера", style: TextStyle(fontSize: 18)),
                        onPressed: () => _getImage(true),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Препознај инсект преку галерија',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF2E7D32),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(Icons.photo, size: 30),
                        label: Text("Галерија", style: TextStyle(fontSize: 18)),
                        onPressed: () => _getImage(false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                color: Colors.black26,
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Назад',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_back, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
