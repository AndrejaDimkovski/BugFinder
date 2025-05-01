import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/insect_model.dart';
import '../screens/insect_description_screen.dart';
import '../screens/home_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<InsectModel>> insectHistory;

  @override
  void initState() {
    super.initState();
    _refreshInsectHistory();
  }

  void _refreshInsectHistory() {
    setState(() {
      insectHistory = DatabaseHelper.instance.getInsects();
    });
  }

  void _confirmDelete(BuildContext context, InsectModel insect) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Бришење'),
        content: Text('Дали сте сигурни дека сакате да го избришете "${insect.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Откажи'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await DatabaseHelper.instance.deleteInsect(insect.name);
              _refreshInsectHistory();
            },
            child: const Text('Избриши', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Историја на препознавања'),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[200]!, Colors.green[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<InsectModel>>(
                future: insectHistory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Нема историја.',
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    );
                  }

                  final insects = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: insects.length,
                    itemBuilder: (context, index) {
                      final insect = insects[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: insect.imageUrl.isNotEmpty && File(insect.imageUrl).existsSync()
                                ? Image.file(
                              File(insect.imageUrl),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : const Icon(Icons.bug_report, size: 50, color: Colors.green),
                          ),
                          title: Text(
                            insect.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Видено на: ${insect.lastSeenTime.toLocal()}".split('.').first,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, insect),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InsectDescriptionScreen(insect: insect),
                              ),
                            ).then((_) => _refreshInsectHistory());
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
      ),
    );
  }
}
