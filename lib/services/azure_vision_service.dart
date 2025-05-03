import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import '../models/insect_model.dart';

class AzureVisionService {


  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<InsectModel> processInsectImage(String imagePath) async {
    try {

      final insectName = await recognizeInsect(imagePath);

      if (insectName == 'Unknown insect') {
        throw Exception("Инсектот не е препознаен.");
      }


      final insectDetails = await getInsectDetailsFromOpenAI(insectName);


      final insect = InsectModel(
        name: insectDetails['name'] ?? 'Unknown',
        description: insectDetails['description'] ?? '',
        activeTime: insectDetails['activeTime'] ?? '',
        location: insectDetails['location'] ?? '',
        dangerous: insectDetails['dangerous'] ?? false,
        diet: insectDetails['diet'] ?? '',
        scientificName: insectDetails['scientificName'] ?? '',
        imageUrl: imagePath,
        lastSeenTime: DateTime.now(),
        insectType: insectDetails['insectType'] ?? '',
        flowerPreference: insectDetails['flowerPreference'] ?? '',
        lifespan: insectDetails['lifespan'] ?? '',
        frequency: insectDetails['frequency'] ?? '',
        activityPeriod: insectDetails['activityPeriod'] ?? '',
        abilities: _parseAbilities(insectDetails['abilities']),
        size: (insectDetails['size'] as num?)?.toDouble() ?? 0.0,
        regions: _parseRegions(insectDetails['regions']),
      );


      await _dbHelper.addInsect(insect);

      return insect;
    } catch (e) {
      print('Error processing insect image: $e');
      rethrow;
    }
  }

  String _parseAbilities(dynamic abilities) {
    if (abilities is String) return abilities;
    if (abilities is List) return abilities.join(', ');
    return '';
  }

  String _parseRegions(dynamic regions) {
    if (regions is String) return regions;
    if (regions is List) return regions.join(', ');
    return '';
  }

  Future<String> recognizeInsect(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw Exception("File not found: $imagePath");
      }

      final imageBytes = await file.readAsBytes();

      final uri = Uri.parse(
        "$visionEndpoint/customvision/v3.0/Prediction/$projectId/classify/iterations/$iterationName/image",
      );

      final response = await http.post(
        uri,
        headers: {
          'Prediction-Key': predictionKey,
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('Azure Vision response: $result');

        if (result['predictions'] != null && result['predictions'].isNotEmpty) {
          final insectTag = result['predictions'][0]['tagName'] ?? 'Unknown insect';
          print('Insect tag recognized by Azure Vision: $insectTag');
          return insectTag;
        } else {
          throw Exception("No predictions found in the response.");
        }
      } else {
        throw Exception("Azure Vision error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print('Error recognizing insect: $e');
      rethrow;
    }
  }




  Future<Map<String, dynamic>> getInsectDetailsFromOpenAI(String insectName) async {
    try {
      print('Requesting insect details for: $insectName');

      final response = await http.post(
        Uri.parse(openAIEndpoint),
        headers: {
          "Content-Type": "application/json",
          "api-key": openAIKey,
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content": '''You are an expert entomologist. Return strictly valid JSON describing an insect with these fields: 
                name, description, activeTime, location, dangerous (bool), diet, scientificName, 
                insectType, flowerPreference, lifespan, frequency, activityPeriod, 
                abilities (as array), size (in cm), regions (as array).'''
            },
            {
              "role": "user",
              "content": "Describe the insect: $insectName"
            }
          ],
          "temperature": 0.7,
          "max_tokens": 700,
        }),
      );

      if (response.statusCode == 200) {
        final content = json.decode(response.body)['choices'][0]['message']['content'];
        final insectDetails = json.decode(content) as Map<String, dynamic>;

        print('Insect details from OpenAI: $insectDetails');
        return insectDetails;
      } else {
        throw Exception("OpenAI API error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print('Error getting insect details: $e');
      return _getDefaultInsectDetails(insectName);
    }
  }

  Map<String, dynamic> _getDefaultInsectDetails(String name) {
    return {
      'name': name,
      'description': 'No description available',
      'activeTime': 'Unknown',
      'location': 'Unknown',
      'dangerous': false,
      'diet': 'Unknown',
      'scientificName': 'Unknown',
      'insectType': 'Unknown',
      'flowerPreference': 'Unknown',
      'lifespan': 'Unknown',
      'frequency': 'Unknown',
      'activityPeriod': 'Unknown',
      'abilities': [],
      'size': 0.0,
      'regions': [],
    };
  }
}
