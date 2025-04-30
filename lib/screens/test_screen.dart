import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class TestAzureScreen extends StatefulWidget {
  @override
  _TestAzureScreenState createState() => _TestAzureScreenState();
}

class _TestAzureScreenState extends State<TestAzureScreen> {
  String _testResult = "Чекам тест...";
  final String subscriptionKey = "pCAZKZ4uYSI2p9Meic0s6FxqGexSQNByLyd7afQxkRIMiBndUJrOJQQJ99BDACYeBjFXJ3w3AAAFACOGm9t7";
  final String endpoint = "https://bugfinder.cognitiveservices.azure.com";

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Или ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _testResult = "Слика е избрана.";
      });
    }
  }

  Future<void> _testAzureVisionService() async {
    if (_selectedImage == null) {
      setState(() {
        _testResult = "Ве молиме изберете слика прво.";
      });
      return;
    }

    final Uri url = Uri.parse('$endpoint/vision/v3.2/describe?maxCandidates=1&language=en');
    final headers = {
      'Ocp-Apim-Subscription-Key': subscriptionKey,
      'Content-Type': 'application/octet-stream',
    };

    try {
      final imageBytes = await _selectedImage!.readAsBytes();

      final response = await http.post(
        url,
        headers: headers,
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final caption = jsonResponse['description']['captions']?[0]?['text'] ?? 'Нема опис';
        final confidence = jsonResponse['description']['captions']?[0]?['confidence'] ?? 0.0;

        setState(() {
          _testResult = "Опис: $caption\nДоверба: ${(confidence * 100).toStringAsFixed(2)}%";
        });
      } else {
        setState(() {
          _testResult = "Грешка! Status code: ${response.statusCode}\n${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _testResult = "Грешка: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Azure Vision API"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Избери слика"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testAzureVisionService,
              child: Text('Тестирај Azure API'),
            ),
            SizedBox(height: 20),
            Text(
              _testResult,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
