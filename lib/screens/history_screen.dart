import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Scan History'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.historyList.isEmpty) {
            return const Center(
              child: Text(
                'No scan history found.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: appState.historyList.length,
            itemBuilder: (context, index) {
              final scan = appState.historyList[index];
              final dateFormatted = DateFormat('MMM dd, yyyy - HH:mm').format(scan.scanDate);
              
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(scan.imagePath),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    scan.diseaseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Confidence: ${(scan.confidenceScore * 100).toStringAsFixed(1)}%'),
                      const SizedBox(height: 4),
                      Text(
                        dateFormatted,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
