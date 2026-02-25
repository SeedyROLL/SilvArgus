import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/health_score_gauge.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Diagnosis Result'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isAnalyzing) {
            return _buildLoadingState();
          }

          if (appState.currentDiagnosis == null) {
            return _buildErrorState(context);
          }

          final diagnosis = appState.currentDiagnosis!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: HealthScoreGauge(score: diagnosis.confidenceScore)),
                const SizedBox(height: 24),
                Text(
                  diagnosis.diseaseName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
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
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          diagnosis.description,
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTreatmentCard(
                  title: 'Biological Treatments',
                  icon: Icons.eco,
                  treatments: diagnosis.biologicalTreatments,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 16),
                _buildTreatmentCard(
                  title: 'Chemical Treatments (Uzbekistan)',
                  icon: Icons.science,
                  treatments: diagnosis.chemicalTreatments,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Return to Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF2E7D32)),
          const SizedBox(height: 24),
          Text(
            'Searching for Disease...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Running local AI model...',
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Analysis failed. Please try again.'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard({
    required String title,
    required IconData icon,
    required List<String> treatments,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (treatments.isEmpty)
              const Text('None recommended.')
            else
              ...treatments.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 18)),
                        Expanded(child: Text(t, style: const TextStyle(fontSize: 15))),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
