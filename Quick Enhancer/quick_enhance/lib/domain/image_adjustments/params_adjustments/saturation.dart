import 'package:image/image.dart' as img;

img.Image applySaturationAuto(img.Image image, double adjustment) {
  final result = image.clone();

  // Reduced range
  final strength = adjustment.clamp(-0.30, 0.30);

  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final p = result.getPixel(x, y);

      final r = p.r.toDouble();
      final g = p.g.toDouble();
      final b = p.b.toDouble();

      // perceptual luminance
      final gray = 0.299 * r + 0.587 * g + 0.114 * b;

      // Reduce effect for very bright or dark pixels
      final brightness = gray / 255.0;
      final protection = 1.0 - (brightness - 0.5).abs() * 1.5; // Reduce saturation near extremes
      final effectiveStrength = strength * protection.clamp(0.3, 1.0);

      int apply(double c) {
        return (gray + (c - gray) * (1 + effectiveStrength))
            .clamp(0, 255)
            .toInt();
      }

      result.setPixelRgba(
        x,
        y,
        apply(r),
        apply(g),
        apply(b),
        p.a,
      );
    }
  }
  return result;
}