import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.language, color: Color(0xFF2E7D32)),
                  title: const Text('Preferred Language'),
                  subtitle: const Text('English (Placeholder for Localization)'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Additional languages coming soon!')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  activeColor: const Color(0xFF2E7D32),
                  secondary: const Icon(Icons.notifications_active, color: Color(0xFF2E7D32)),
                  title: const Text('Notification Preferences'),
                  subtitle: const Text('Receive plant care reminders'),
                  value: appState.notificationsEnabled,
                  onChanged: (bool value) {
                    HapticFeedback.lightImpact();
                    appState.toggleNotifications(value);
                  },
                ),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Clear History',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    final shouldClear = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear History?'),
                        content: const Text('This will permanently delete all saved diagnostic scans. This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (shouldClear == true) {
                      await appState.clearHistory();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('History cleared successfully.')),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
