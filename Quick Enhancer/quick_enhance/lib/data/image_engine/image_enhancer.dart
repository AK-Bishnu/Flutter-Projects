import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:quick_enhance/domain/image_adjustments/auto_image_adjustment/standard_enhancer.dart';
import 'package:quick_enhance/domain/image_adjustments/manual_image_adjustment/fast_enhancer_on_dragging.dart';
import 'package:quick_enhance/domain/image_adjustments/params_adjustments/generate_auto_params.dart';
import '../../domain/entities/enhance_request.dart';

class ImageEnhancer {
  static Uint8List enhance(EnhanceRequest request) {
    final image = img.decodeImage(request.imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    final autoDelta = generateStandardAutoParams(request.currentParams);
    final merged = mergeParams(request.currentParams, autoDelta);

    final enhanced = applyStandardEnhancement(image, merged);
    return Uint8List.fromList(img.encodeJpg(enhanced, quality: 95));
  }
}
