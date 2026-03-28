import 'package:flutter/foundation.dart';

import '../../../domain/entities/enhance_request.dart';
import '../image_enhancer.dart';


Future<Uint8List> enhanceImageInIsolate(EnhanceRequest request) {
  return compute(_enhanceEntry, request);
}

Uint8List _enhanceEntry(EnhanceRequest request) {
  print('🧵 Enhancement running in isolate');
  return ImageEnhancer.enhance(request);
}
