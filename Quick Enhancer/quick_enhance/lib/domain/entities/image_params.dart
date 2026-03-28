class ImageParams {
  final double brightness;
  final double contrast;
  final double saturation;
  final double highlights;
  final double shadows;

  const ImageParams({
    required this.brightness,
    required this.contrast,
    required this.saturation,
    required this.highlights,
    required this.shadows,
  });

  ImageParams copyWith({
    double? brightness,
    double? contrast,
    double? saturation,
    double? highlights,
    double? shadows,
  }) {
    return ImageParams(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      highlights: highlights ?? this.highlights,
      shadows: shadows ?? this.shadows,
    );
  }

  static const zero = ImageParams(
    brightness: 0,
    contrast: 0,
    saturation: 0,
    highlights: 0,
    shadows: 0
  );
}
