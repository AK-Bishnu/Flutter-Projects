import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:quick_enhance/domain/image_adjustments/manual_image_adjustment/fast_enhancer_on_dragging.dart';
import '../../../domain/entities/manual_edit_request.dart';



Uint8List manualEditIsolate(ManualEditRequest req) {
  final enhanced = applyManualEnhancementFast(req.previewImage, req.params);

  return Uint8List.fromList(
    img.encodeJpg(enhanced, quality: 85),
  );
}

