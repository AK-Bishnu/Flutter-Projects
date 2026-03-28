import 'package:image/image.dart' as img;

img.Image applyContrastAuto(img.Image image, double adjustment) {
  final result = image.clone();

  final strength = adjustment.clamp(-0.25, 0.25);
  const mid = 128.0;

  // Use a sigmoid-like curve to protect extremes
  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final p = result.getPixel(x, y);

      final r = p.r.toDouble();
      final g = p.g.toDouble();
      final b = p.b.toDouble();

      // Apply contrast with protection near extremes
      double apply(double c) {
        final normalized = (c - mid) / mid; // -1 to 1

        if (strength > 0) {
          // Increase contrast: compress near extremes
          final adjusted = normalized * (1 + strength * 0.8);
          return mid + mid * adjusted.clamp(-0.95, 0.95);
        } else {
          // Decrease contrast
          final adjusted = normalized * (1 + strength);
          return mid + mid * adjusted;
        }
      }

      result.setPixelRgba(
        x,
        y,
        apply(r).clamp(0, 255).toInt(),
        apply(g).clamp(0, 255).toInt(),
        apply(b).clamp(0, 255).toInt(),
        p.a,
      );
    }
  }
  return result;
}