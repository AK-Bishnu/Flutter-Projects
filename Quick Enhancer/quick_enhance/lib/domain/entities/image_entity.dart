import 'dart:typed_data';
import 'package:quick_enhance/domain/entities/image_params.dart';

class ImageEntity {
  final Uint8List originalBytes; //only for exporting time
  final Uint8List previewBytes; //original one , should be untouched
  final Uint8List? enhancedBytes; // actual edited bytes
  final ImageParams? currentParams; // current params for original image
  final ImageParams? activeParams;  // current params for displayed image

  const ImageEntity({
    required this.originalBytes,
    required this.previewBytes,
    this.enhancedBytes,
    this.currentParams,
    this.activeParams,
  });

  ImageEntity copyWith({
    Uint8List? originalBytes,
    Uint8List? previewBytes,
    Uint8List? enhancedBytes,
    ImageParams? currentParams,
    ImageParams? activeParams,
  }) {
    return ImageEntity(
      originalBytes: originalBytes ?? this.originalBytes,
      previewBytes: previewBytes ?? this.previewBytes,
      enhancedBytes: enhancedBytes ?? this.enhancedBytes,
      currentParams: currentParams ?? this.currentParams,
      activeParams: activeParams ?? this.activeParams,
    );
  }
}
