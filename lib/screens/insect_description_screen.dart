import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/insect_model.dart';

class InsectDescriptionScreen extends StatelessWidget {
  final InsectModel insect;

  const InsectDescriptionScreen({Key? key, required this.insect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: insect.imageUrl.isNotEmpty && File(insect.imageUrl).existsSync()
                        ? Image.file(File(insect.imageUrl), fit: BoxFit.cover)
                        : const Center(
                      child: Icon(Icons.bug_report, size: 100, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            // Description
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[200]!, Colors.green[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                        insect.name.toUpperCase(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      insect.description,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        "ДЕТАЛИ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildDetailCard(Icons.public, "Региони", insect.regions),
                        _buildDetailCard(Icons.access_time, "Активен во", insect.activeTime),
                        _buildDetailCard(Icons.nature, "Цветови", insect.flowerPreference),
                        _buildDetailCard(Icons.restaurant, "Исхрана", insect.diet),
                        _buildDetailCard(Icons.warning, "Опасен", insect.dangerous ? "Да" : "Не"),
                        _buildDetailCard(Icons.category, "Тип", insect.insectType),
                        _buildDetailCard(Icons.height, "Големина", "${insect.size} см"),
                        _buildDetailCard(Icons.calendar_today, "Животен век", insect.lifespan),
                      ],
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await DatabaseHelper.instance.addInsect(insect);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Додадено во историјата.")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Грешка при зачувување.")),
                          );
                        }
                      },
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const Text("Зачувај во историја"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox();

    return SizedBox(
      width: 160,
      height: 150,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
