import '../../domain/entities/image_params.dart';

class StandardImageParams {
  static const double tolerance = 0.015;

  static const ImageParams reference = ImageParams(
    brightness: 0.340,
    contrast: 0.230,
    saturation: 0.430,
    highlights: 0.70,
    shadows: 0.20,
  );
}
