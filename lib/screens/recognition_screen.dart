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
  File? _imageFile;

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
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
      appBar: AppBar(
        title: Text("Избери слика"),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[200]!, Colors.green[100]!],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Препознај инсект преку камера',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt, size: 50, color: Colors.green[800]),
                        onPressed: () => _getImage(true),
                      ),

                      SizedBox(height: 20),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPiImGMFuNM5nGxOdeJX1Bu5hQ8dWsl5_C8Q&s',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        'Препознај инсект преку галерија',
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo, size: 50, color: Colors.green[800]),
                        onPressed: () => _getImage(false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Назад секција
          Container(
            width: double.infinity,
            color: Colors.green[800],
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Назад',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 26, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
