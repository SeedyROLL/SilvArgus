import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diagnosis_result.dart';
import '../models/scan_history.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';

class AppState extends ChangeNotifier {
  final AiService _aiService = AiService();
  final DatabaseService _dbService = DatabaseService();

  bool isAnalyzing = false;
  DiagnosisResult? currentDiagnosis;
  List<ScanHistory> historyList = [];
  bool notificationsEnabled = false;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    final db = await _dbService.database;
    await db.delete('scan_history');
    await loadHistory();
  }

  Future<void> loadHistory() async {
    historyList = await _dbService.getAllScans();
    notifyListeners();
  }

  Future<void> analyzeImage(String imagePath) async {
    isAnalyzing = true;
    currentDiagnosis = null;
    notifyListeners();

    try {
      // Calls the placeholder AI mock function
      currentDiagnosis = await _aiService.analyzeImage(imagePath);
      
      // Save to local database
      final scanResult = ScanHistory(
        imagePath: imagePath,
        diseaseName: currentDiagnosis!.diseaseName,
        confidenceScore: currentDiagnosis!.confidenceScore,
        scanDate: DateTime.now(),
      );
      
      await _dbService.insertScan(scanResult);
      await loadHistory();
      
    } catch (e) {
      debugPrint("Analysis Error: \$e");
      currentDiagnosis = DiagnosisResult.unknown();
    } finally {
      isAnalyzing = false;
      notifyListeners();
    }
  }
}
