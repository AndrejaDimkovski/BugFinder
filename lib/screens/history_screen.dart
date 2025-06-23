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
        title: Text('Бришење', style: TextStyle(color: Color(0xFF2E7D32))),
        content: Text('Дали сте сигурни дека сакате да го избришете "${insect.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Откажи', style: TextStyle(color: Color(0xFF2E7D32))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await DatabaseHelper.instance.deleteInsect(insect.name);
              _refreshInsectHistory();
            },
            child: Text('Избриши', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/564x/25/d0/5c/25d05c5abceb0d29b11e1bdd0793c11d.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                'Историја на препознавања',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<InsectModel>>(
                  future: insectHistory,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Нема историја на препознавања',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    final insects = snapshot.data!;

                    return ListView.builder(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
                      itemCount: insects.length,
                      itemBuilder: (context, index) {
                        final insect = insects[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsectDescriptionScreen(insect: insect),
                                ),
                              ).then((_) => _refreshInsectHistory());
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.green[50],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: insect.imageUrl.isNotEmpty && File(insect.imageUrl).existsSync()
                                          ? Image.file(
                                        File(insect.imageUrl),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                          : Center(
                                        child: Icon(Icons.bug_report, size: 40, color: Color(0xFF2E7D32)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          insect.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Видено на: ${insect.lastSeenTime.toLocal()}".split('.').first,
                                          style: TextStyle(
                                            color: Colors.green[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(context, insect),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Назад кон главното мени',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}