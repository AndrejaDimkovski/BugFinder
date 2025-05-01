import 'package:bugfinder/screens/recognition_screen.dart';
import 'package:flutter/material.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добредојде во BugFinder 🐞'),
        backgroundColor: Colors.green[700]?.withOpacity(0.9),
        centerTitle: true,
        elevation: 6,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[200]!, Colors.green[100]!],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyJ6lZssP3y7UebMiywSRgNF6-AUgruSxu-w&s',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.45,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.search,
                    label: 'Препознај инсект 🐞',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InsectRecognitionScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  _buildActionButton(
                    context,
                    icon: Icons.history,
                    label: 'Историја на препознавања',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              color: Colors.green[800],
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.alternate_email, size: 30, color: Colors.white),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, size: 30, color: Colors.white),
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 35, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }
}
