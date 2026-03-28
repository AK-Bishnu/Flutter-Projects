import 'package:image/image.dart' as img;

import 'image_params.dart';

class ManualEditRequest {
  final img.Image previewImage;
  final ImageParams params;

  ManualEditRequest(this.previewImage, this.params);
}
