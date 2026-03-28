import 'package:image/image.dart' as img;
import '../../core/constants/standard_image_model.dart';
import '../../core/utils/params_analysis.dart';
import '../../core/utils/params_evaluation.dart';
import '../../domain/entities/image_params.dart';
import '../../domain/entities/image_analysis.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/entities/image_metrics.dart';


class ImageAnalyzer {
  static AnalysisResult analyze(img.Image image) {

    final params = ImageParams(
      brightness: ImageMetrics.brightness(image),
      contrast: ImageMetrics.contrast(image),
      saturation: ImageMetrics.saturation(image),
      highlights: ImageMetrics.highlights(image),
      shadows: ImageMetrics.shadows(image),
    );

    final analysis = _analyze(params);

    return AnalysisResult(
      params: params,
      analysis: analysis,
    );
  }

  static ImageAnalysis _analyze(ImageParams p) {
    final t = StandardImageParams.reference;

    ParamAnalysis build(double value, double target) {
      return ParamAnalysis(
        value: value,
        standard: target,
        status: evaluateStatus(current: value, target: target),
      );
    }

    return ImageAnalysis(
      brightness: build(p.brightness, t.brightness),
      contrast: build(p.contrast, t.contrast),
      saturation: build(p.saturation, t.saturation),
      highlights: build(p.highlights, t.highlights),
      shadows: build(p.shadows, t.shadows),
    );
  }
}

