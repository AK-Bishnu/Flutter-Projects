import 'image_params.dart';
import 'image_analysis.dart';

class AnalysisResult {
  final ImageParams params;
  final ImageAnalysis analysis;

  const AnalysisResult({
    required this.params,
    required this.analysis,
  });
}
