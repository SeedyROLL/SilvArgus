class ScanHistory {
  final int? id;
  final String imagePath;
  final String diseaseName;
  final double confidenceScore;
  final DateTime scanDate;

  ScanHistory({
    this.id,
    required this.imagePath,
    required this.diseaseName,
    required this.confidenceScore,
    required this.scanDate,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'diseaseName': diseaseName,
      'confidenceScore': confidenceScore,
      'scanDate': scanDate.toIso8601String(),
    };
  }

  factory ScanHistory.fromMap(Map<String, Object?> map) {
    return ScanHistory(
      id: map['id'] as int?,
      imagePath: map['imagePath'] as String,
      diseaseName: map['diseaseName'] as String,
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
      scanDate: DateTime.parse(map['scanDate'] as String),
    );
  }
}
