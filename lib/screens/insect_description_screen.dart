import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database.dart';  // Внимавајте на точната патека
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
            // Горна слика со копчиња за назад и share
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.black,
                  child: insect.imageUrl.isNotEmpty && File(insect.imageUrl).existsSync()
                      ? Image.file(File(insect.imageUrl), fit: BoxFit.contain)
                      : const Icon(Icons.bug_report, size: 100, color: Colors.white),
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

            // Описен дел
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  children: [
                    Text(
                      insect.name.toUpperCase(),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insect.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text("DETAILS:", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await DatabaseHelper.instance.addInsect(insect);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Insect added to history!"))
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Error adding insect."))
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add to Collection", style: TextStyle(color: Colors.white)),
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
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
