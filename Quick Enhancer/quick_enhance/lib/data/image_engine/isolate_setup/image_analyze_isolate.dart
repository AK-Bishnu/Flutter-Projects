import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import '../../../domain/entities/analysis_result.dart';
import '../image_analyzer.dart';


Future<AnalysisResult> analyzeImageInIsolate(
    Uint8List imageBytes,
    ) {
  return compute(_analyzeEntry, imageBytes);
}

/// Top-level function (required by compute)
AnalysisResult _analyzeEntry(Uint8List bytes) {
  final image = img.decodeImage(bytes);
  if(image == null){
    throw Exception('Image decoding failed in isolate');
  }
  return ImageAnalyzer.analyze(image);
}
