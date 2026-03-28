import 'package:image/image.dart' as img;

img.Image createPreview(img.Image original) {
  const maxWidth = 600;

  if (original.width <= maxWidth) return original.clone();

  final scale = maxWidth / original.width;
  final newHeight = (original.height * scale).round();

  return img.copyResize(
    original,
    width: maxWidth,
    height: newHeight,
    interpolation: img.Interpolation.average,
  );
}
