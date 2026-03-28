import 'dart:typed_data';
import 'image_params.dart';

class EnhanceRequest {
  final Uint8List imageBytes;
  final ImageParams currentParams;

  const EnhanceRequest({
    required this.imageBytes,
    required this.currentParams,
  });
}
