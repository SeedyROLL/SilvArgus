import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 80, color: Color(0xFF2E7D32)),
            const SizedBox(height: 16),
            const Text(
              'SilvArgus',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Text(
              'v1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our Mission',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To empower farmers and plant enthusiasts with accessible, on-device AI technology for early detection and treatment of crop diseases, ultimately securing agricultural yields and sustainability.',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact & Support',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF2E7D32)),
                      title: const Text('support@silvargus.uz'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: const Icon(Icons.telegram, color: Colors.blue),
                      title: const Text('@SilvArgusSupport'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
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
}
