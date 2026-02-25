import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/diagnosis_result.dart';
import '../utils/image_processor.dart';

class AiService {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInit = false;

  Future<void> initModel() async {
    if (_isInit) return;
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').where((l) => l.trim().isNotEmpty).toList();
      _isInit = true;
      debugPrint("TFLite Model and Labels loaded successfully.");
    } catch (e) {
      debugPrint("Error loading TFLite model or labels: \$e");
    }
  }

  Future<DiagnosisResult> analyzeImage(String imagePath) async {
    if (!_isInit) {
      await initModel();
    }

    if (_interpreter == null || _labels == null || _labels!.isEmpty) {
      return DiagnosisResult.unknown();
    }

    // 1. Preprocess the image (resize to 224x224 and normalize to tensor array)
    final tensorInput = await ImageProcessor.preprocessImageForTFLite(imagePath);
    
    if (tensorInput == null) {
      return DiagnosisResult.unknown();
    }

    // Wrap tensor in batch dimension: [1, 224, 224, 3]
    final input = [tensorInput];

    // Output array shaped [1, num_classes]
    var output = List.generate(1, (_) => List.filled(_labels!.length, 0.0));

    try {
      _interpreter!.run(input, output);
    } catch (e) {
      debugPrint("Error running inference: \$e");
      return DiagnosisResult.unknown();
    }

    final List<double> results = output[0];
    double maxScore = 0.0;
    int maxIndex = -1;

    // Find highest confidence prediction
    for (int i = 0; i < results.length; i++) {
      if (results[i] > maxScore) {
        maxScore = results[i];
        maxIndex = i;
      }
    }

    // Threshold Check
    if (maxScore < 0.60 || maxIndex == -1) {
      return DiagnosisResult(
        diseaseName: "Uncertain",
        confidenceScore: maxScore,
        description: "Analysis uncertain. Please take a clearer photo.",
        biologicalTreatments: ["Clean the camera lens, ensure good lighting, and capture the affected area clearly."],
        chemicalTreatments: [],
      );
    }

    // Clean up label string
    String rawLabel = _labels![maxIndex];
    String diseaseName = rawLabel.replaceAll('___', ' - ').replaceAll('_', ' ');

    return DiagnosisResult(
      diseaseName: diseaseName,
      confidenceScore: maxScore,
      description: "Identified primarily as \$diseaseName.",
      biologicalTreatments: [
        "Consult local agricultural guides for \$diseaseName specific organic control.",
        "Remove affected leaves to prevent spread."
      ],
      chemicalTreatments: [
        "Consult your local Uzbekistan agricultural store for specific treatments targeting \$diseaseName."
      ],
    );
  }
}
