import 'package:image/image.dart' as img;

img.Image applyShadowsAuto(img.Image image, double adjustment) {
  final result = image.clone();

  // Reduced range
  final strength = adjustment.clamp(-0.20, 0.20);

  // Skip if adjustment is minimal
  if (strength.abs() < 0.01) return result;

  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final p = result.getPixel(x, y);

      final lum = (0.2126 * p.r + 0.7152 * p.g + 0.0722 * p.b);
      final l = (lum / 255.0).clamp(0.0, 1.0);

      // Only affect true shadows (bottom 40%)
      if (l >= 0.4) {
        continue;
      }

      // Gentle mask
      final mask = (0.4 - l) / 0.4; // Linear from 0 to 1

      // Reduced effect
      int apply(int c) {
        if (strength >= 0) {
          // Lift shadows gently
          return (c + (255 - c) * strength * mask * 0.4).clamp(0, 255).toInt();
        } else {
          // Deepen shadows gently
          return (c + c * strength * mask * 0.4).clamp(0, 255).toInt();
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