import 'package:image/image.dart' as img;

img.Image applyHighlightsAuto(img.Image image, double adjustment) {
  final result = image.clone();

  // Very small range for highlights
  final strength = adjustment.clamp(-0.15, 0.15);

  // Skip if adjustment is minimal
  if (strength.abs() < 0.01) return result;

  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final p = result.getPixel(x, y);

      // Calculate luminance (0-1 range)
      final lum = (0.2126 * p.r + 0.7152 * p.g + 0.0722 * p.b) / 255.0;

      // Only affect true highlights (top 40% -> changed from 30%)
      if (lum < 0.6) {
        continue;
      }

      // Gentle mask
      final mask = (lum - 0.6) / 0.4; // Linear from 0 to 1

      // Very subtle adjustment
      final adj = 1.0 + (strength * mask * 0.5); // Half strength

      int apply(int c) {
        if (strength > 0) {
          // Darken highlights slightly
          return (c * (1.0 - (adj - 1.0) * 0.3)).clamp(0, 255).toInt();
        } else {
          // Brighten highlights very carefully
          return (c + (255 - c) * (1.0 - adj) * 0.2).clamp(0, 255).toInt();
        }
      }

      result.setPixelRgba(
        x,
        y,
        apply(p.r.toInt()),
        apply(p.g.toInt()),
        apply(p.b.toInt()),
        p.a,
      );
    }
  }

  return result;
}