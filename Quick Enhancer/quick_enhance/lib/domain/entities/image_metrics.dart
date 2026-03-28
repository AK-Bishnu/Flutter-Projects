import 'dart:math';
import 'package:image/image.dart' as img;

class ImageMetrics {
  /// Average luminance (0.0 – 1.0)
  static double brightness(img.Image image) {
    double sum = 0;
    final total = image.width * image.height;

    for (final pixel in image) {
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      // Standard luminance formula
      sum += 0.2126 * r + 0.7152 * g + 0.0722 * b;
    }

    return sum / total;
  }

  /// Contrast using luminance standard deviation
  static double contrast(img.Image image) {
    final List<double> luminance = [];

    for (final pixel in image) {
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      luminance.add(0.2126 * r + 0.7152 * g + 0.0722 * b);
    }

    final mean =
        luminance.reduce((a, b) => a + b) / luminance.length;

    final variance = luminance
        .map((l) => pow(l - mean, 2))
        .reduce((a, b) => a + b) /
        luminance.length;

    return sqrt(variance);
  }

  /// Average saturation in HSV (0.0 – 1.0)
  static double saturation(img.Image image) {
    double sum = 0;
    final total = image.width * image.height;

    for (final pixel in image) {
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      final maxC = max(r, max(g, b));
      final minC = min(r, min(g, b));

      final sat = maxC == 0 ? 0 : (maxC - minC) / maxC;
      sum += sat;
    }

    return sum / total;
  }

  /// Average luminance of dark pixels → shadows (0.0 – 1.0)
  static double shadows(img.Image image, {double threshold = 0.4}) {
    double sum = 0;
    int count = 0;

    for (final pixel in image) {
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      final lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;

      if (lum < threshold) {
        sum += lum;
        count++;
      }
    }

    if (count == 0) return 0.0;
    return sum / count;
  }

  /// Average luminance of bright pixels → highlights (0.0 – 1.0)
  static double highlights(img.Image image, {double threshold = 0.6}) {
    double sum = 0;
    int count = 0;

    for (final pixel in image) {
      final r = pixel.r / 255.0;
      final g = pixel.g / 255.0;
      final b = pixel.b / 255.0;

      final lum = 0.2126 * r + 0.7152 * g + 0.0722 * b;

      if (lum > threshold) {
        sum += lum;
        count++;
      }
    }

    if (count == 0) return 0.0;
    return sum / count;
  }

}
