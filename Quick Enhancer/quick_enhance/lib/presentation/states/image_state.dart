import 'package:quick_enhance/domain/entities/analysis_result.dart';
import '../../../domain/entities/image_entity.dart';

class ImageState {
  final ImageEntity? image;
  final bool isAnalyzing;
  final bool showEnhanced;
  final AnalysisResult? originalAnalysis;
  final AnalysisResult? enhancedAnalysis;


  const ImageState({
    this.image,
    this.isAnalyzing = false,
    this.showEnhanced = false,
    this.originalAnalysis,
    this.enhancedAnalysis,
  });

  ImageState copyWith({
    ImageEntity? image,
    bool? isAnalyzing,
    bool? showEnhanced,
    AnalysisResult? originalAnalysis,
    AnalysisResult? enhancedAnalysis,
  }) {
    return ImageState(
      image: image ?? this.image,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      showEnhanced: showEnhanced ?? this.showEnhanced,
      originalAnalysis: originalAnalysis ?? this.originalAnalysis,
      enhancedAnalysis: enhancedAnalysis ?? this.enhancedAnalysis,
    );
  }
}
