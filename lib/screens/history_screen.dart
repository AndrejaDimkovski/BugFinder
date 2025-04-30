import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/insect_model.dart';
import '../screens/insect_description_screen.dart';

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
      appBar: AppBar(title: const Text('Историја на препознавања')),
      body: FutureBuilder<List<InsectModel>>(
        future: insectHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нема историја.'));
          }

          final insects = snapshot.data!;

          return ListView.builder(
            itemCount: insects.length,
            itemBuilder: (context, index) {
              final insect = insects[index];
              return ListTile(
                leading: insect.imageUrl.isNotEmpty && File(insect.imageUrl).existsSync()
                    ? Image.file(File(insect.imageUrl), width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.bug_report, size: 50),
                title: Text(insect.name),
                subtitle: Text("Видено на: ${insect.lastSeenTime.toLocal()}".split('.').first),
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
              );
            },
          );
        },
      ),
    );
  }
}
