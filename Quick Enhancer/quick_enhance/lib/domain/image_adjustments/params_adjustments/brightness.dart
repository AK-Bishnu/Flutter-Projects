import 'package:image/image.dart' as img;

img.Image applyBrightnessAuto(img.Image image, double adjustment) {
  final result = image.clone();

  // Even softer clamp
  final strength = adjustment.clamp(-0.25, 0.25);

  // Use a more natural curve
  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final p = result.getPixel(x, y);

      int apply(int c) {
        final normalized = c / 255.0;
        if (strength > 0) {
          // Brighten: use a soft S-curve to protect highlights
          final adjusted = normalized + (1.0 - normalized) * strength * 0.7;
          return (adjusted * 255).clamp(0, 255).toInt();
        } else {
          // Darken: use a soft S-curve to protect shadows
          final adjusted = normalized + normalized * strength * 0.7;
          return (adjusted * 255).clamp(0, 255).toInt();
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