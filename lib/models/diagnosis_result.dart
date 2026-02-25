class DiagnosisResult {
  final String diseaseName;
  final double confidenceScore;
  final String description;
  final List<String> biologicalTreatments;
  final List<String> chemicalTreatments;

  DiagnosisResult({
    required this.diseaseName,
    required this.confidenceScore,
    required this.description,
    required this.biologicalTreatments,
    required this.chemicalTreatments,
  });

  // Empty constructor for fallback
  factory DiagnosisResult.unknown() {
    return DiagnosisResult(
      diseaseName: "Unknown Error",
      confidenceScore: 0.0,
      description: "Could not fetch a valid diagnosis.",
      biologicalTreatments: [],
      chemicalTreatments: [],
    );
  }
}
