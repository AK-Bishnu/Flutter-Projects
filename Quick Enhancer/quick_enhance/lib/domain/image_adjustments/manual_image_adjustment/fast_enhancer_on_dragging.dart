import 'package:image/image.dart' as img;
import '../../entities/image_params.dart';

img.Image applyManualEnhancementFast(
    img.Image image,
    ImageParams p,
    ) {
  final result = image.clone();
  final previewScale = 0.2;

  // Existing adjustments
  final b = (p.brightness * 255 * previewScale).toInt();
  final c = 1.0 + p.contrast;
  final s = 1.0 + (p.saturation * previewScale);

  // Highlights & shadows (range -1 → 1)
  final h = p.highlights; // positive → darken, negative → brighten
  final sh = p.shadows;   // positive → lighten shadows, negative → deepen

  for (int y = 0; y < result.height; y++) {
    for (int x = 0; x < result.width; x++) {
      final px = result.getPixel(x, y);

      num r = px.r + b;
      num g = px.g + b;
      num bl = px.b + b;

      // Contrast
      r = ((r - 128) * c + 128);
      g = ((g - 128) * c + 128);
      bl = ((bl - 128) * c + 128);

      // Saturation
      final lum = (r * 0.3 + g * 0.6 + bl * 0.1);
      r = lum + (r - lum) * s;
      g = lum + (g - lum) * s;
      bl = lum + (bl - lum) * s;

      // ---------------- HIGHLIGHTS & SHADOWS ----------------

      final lum255 = (0.3 * r + 0.6 * g + 0.1 * bl);
      final l = (lum255 / 255.0).clamp(0.0, 1.0);

      // ----- Highlights (opposite behavior) -----
      if (h != 0 && l > 0.5) {
        final factor = (l - 0.5) * 2; // 0 → 1
        final compression = h * factor;

        // INVERTED: positive h → darken, negative h → brighten
        r += compression * (r - 128);
        g += compression * (g - 128);
        bl += compression * (bl - 128);
      }

      // ----- Shadows (same as before) -----
      if (sh != 0 && l < 0.5) {
        final factor = (0.5 - l) * 2; // 0 → 1
        final lift = sh * factor;

        r += lift * (128 - r);
        g += lift * (128 - g);
        bl += lift * (128 - bl);
      }

      // Clamp final values
      result.setPixelRgba(
        x,
        y,
        r.clamp(0, 255).toInt(),
        g.clamp(0, 255).toInt(),
        bl.clamp(0, 255).toInt(),
        px.a,
      );
    }
  }

  return result;
}
