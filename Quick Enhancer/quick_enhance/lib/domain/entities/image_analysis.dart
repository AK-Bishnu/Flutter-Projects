import '../../core/utils/params_analysis.dart';
import '../enums/param_status.dart';

class ImageAnalysis {
  final ParamAnalysis brightness;
  final ParamAnalysis contrast;
  final ParamAnalysis saturation;
  final ParamAnalysis highlights;
  final ParamAnalysis shadows;

  const ImageAnalysis({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.highlights,
    required this.shadows,
  });

  bool get isPerfect =>
      brightness.status == ParamStatus.perfect &&
          contrast.status == ParamStatus.perfect &&
          saturation.status == ParamStatus.perfect &&
          highlights.status == ParamStatus.perfect &&
          shadows.status == ParamStatus.perfect;
}
