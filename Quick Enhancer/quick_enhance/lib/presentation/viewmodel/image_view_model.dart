import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter_riverpod/legacy.dart';
import 'package:quick_enhance/domain/image_adjustments/manual_image_adjustment/preview_image.dart';
import '../../../domain/entities/image_entity.dart';
import '../../data/image_engine/isolate_setup/image_analyze_isolate.dart';
import '../../data/image_engine/isolate_setup/image_enhance_isolate.dart';
import '../../domain/entities/enhance_request.dart';
import '../states/image_state.dart';


final imageViewModelProvider =
    StateNotifierProvider<ImageViewModel, ImageState>(
      (ref) => ImageViewModel(),
    );

class ImageViewModel extends StateNotifier<ImageState> {
  ImageViewModel() : super(const ImageState());

  Future<void> setPic(Uint8List bytes) async {
    final fullImage = img.decodeImage(bytes);
    if(fullImage == null){
      throw Exception('Image decode failed');
    }

    final previewImage = createPreview(fullImage);
    final previewBytes = Uint8List.fromList(img.encodeJpg(previewImage,quality: 85));


    state = state.copyWith(
      image: ImageEntity(
        originalBytes: bytes,
        previewBytes: previewBytes,
        enhancedBytes: null,
        activeParams: null,
        currentParams: null,
      ),
      showEnhanced: false,
      isAnalyzing: false,
      originalAnalysis: null,
      enhancedAnalysis: null,
    );
  }

  Future<void> analyze() async {
    final image = state.image;
    if (image == null) {
      print('analyze failed!');
      return;
    }

    final isEnhanced = state.showEnhanced && image.enhancedBytes != null;
    final imageBytes = isEnhanced ? image.enhancedBytes : image.previewBytes;

    state = state.copyWith(isAnalyzing: true);

    final result = await analyzeImageInIsolate(imageBytes!);
    print(isEnhanced ? 'Analyzing enhanced' : 'Analyzing original');

    if (isEnhanced) {
      state = state.copyWith(
        isAnalyzing: false,
        enhancedAnalysis: result,
        image: image.copyWith(
          activeParams: result.params,
        ),
      );
    } else {
      state = state.copyWith(
        isAnalyzing: false,
        originalAnalysis: result,
        image: image.copyWith(
          currentParams: result.params,
          activeParams: result.params,
        )
      );
    }
  }

  Future<void> autoEnhance() async {
    final image = state.image;
    if (image == null) return;

    if (state.isAnalyzing){
      print('still analyzing');
      return;
    }

    if (state.originalAnalysis == null) {
      await analyze(); // Analyze original first
    }

    final currentParams = state.originalAnalysis!.params;

    state = state.copyWith(isAnalyzing: true);

    // Use adaptive params instead of fixed standard
    final enhancedBytes = await enhanceImageInIsolate(
      EnhanceRequest(
        imageBytes: image.previewBytes,
        currentParams: currentParams,
      ),
    );

    final enhancedResult = await analyzeImageInIsolate(enhancedBytes);

    state = state.copyWith(
      isAnalyzing: false,
      image: image.copyWith(
        enhancedBytes: enhancedBytes,
        activeParams: currentParams,
      ),
      showEnhanced: true,
      enhancedAnalysis: enhancedResult,
    );
  }

  void toggleBeforeAfter() {
    if (state.image?.enhancedBytes == null) return;

    state = state.copyWith(showEnhanced: !state.showEnhanced);
  }

  void updatePreview(Uint8List previewBytes) {
    final image = state.image;
    if (image == null) return;

    state = state.copyWith(
      image: image.copyWith(previewBytes: previewBytes),
    );
  }

  Uint8List getDisplayedImageBytes() {
    final img = state.image!;
    return (state.showEnhanced && img.enhancedBytes != null)
        ? img.enhancedBytes!
        : img.previewBytes;
  }

  void applyManualEdit(Uint8List editedBytes) {
    final img = state.image!;
    state = state.copyWith(
      image: img.copyWith(
        enhancedBytes: editedBytes,
      ),
      showEnhanced: true,
    );
  }


}
