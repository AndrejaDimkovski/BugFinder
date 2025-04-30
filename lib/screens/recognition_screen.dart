import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/azure_vision_service.dart';

import '../screens/insect_description_screen.dart';

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
      // Повик на Azure Vision и OpenAI
      final insect = await _azureVisionService.processInsectImage(imagePath);

      // Навигација до описниот екран
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
        title: Text("Препознавање на инсекти"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200, width: 200, fit: BoxFit.cover)
                : Text("Избери слика"),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _getImage(true),
              child: Text('Препознај инсект преку камера'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _getImage(false),
              child: Text('Препознај инсект преку галерија'),
            ),
          ],
        ),
      ),
    );
  }
}
