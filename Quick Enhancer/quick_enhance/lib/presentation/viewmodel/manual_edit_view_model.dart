import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image/image.dart' as img;

import '../../domain/entities/image_params.dart';
import '../../domain/entities/manual_edit_request.dart';
import '../../domain/image_adjustments/manual_image_adjustment/fast_enhancer_on_dragging.dart';
import '../../data/image_engine/isolate_setup/manual_edit_isolate.dart';
import '../states/manual_edit_state.dart';
import '../viewmodel/image_view_model.dart';

final manualEditProvider =
StateNotifierProvider<ManualEditNotifier, ManualEditState>(
      (ref) => ManualEditNotifier(ref),
);

class ManualEditNotifier extends StateNotifier<ManualEditState> {
  final Ref ref;

  // Original image from home screen (displayed image)
  late Uint8List _entryBytes;
  late img.Image _entryImage;

  // Working temp image shown in manual edit screen
  late img.Image _previewManualImage;

  ManualEditNotifier(this.ref)
      : super(const ManualEditState(params: ImageParams.zero));

  /// Initialize temp image from home screen display
  void initFromImageState() {
    final imageNotifier = ref.read(imageViewModelProvider.notifier);
    final entryBytes = imageNotifier.getDisplayedImageBytes();

    _entryBytes = Uint8List.fromList(entryBytes);
    _entryImage = img.decodeImage(_entryBytes)!;
    _previewManualImage = _entryImage;

    state = state.copyWith(params: ImageParams.zero);
  }

  /// ---------------- SLIDER LIVE DRAG ----------------
  void onSliderDrag(ImageParams params) {
    // Always apply on original entry image to avoid cumulative effect
    _previewManualImage = applyManualEnhancementFast(_entryImage, params);

    state = state.copyWith(params: params);
  }

  /// ---------------- SLIDER RELEASE ----------------
  Future<void> onSliderEnd(ImageParams params) async {
    state = state.copyWith(params: params);

    final bytes = await compute(
      manualEditIsolate,
      ManualEditRequest(_entryImage, params),
    );

    _previewManualImage = img.decodeImage(bytes)!;
  }

  /// ---------------- RESET ----------------
  void resetTempImage() {
    _previewManualImage = img.decodeImage(_entryBytes)!;
    state = state.copyWith(params: ImageParams.zero);
  }

  /// ---------------- APPLY ----------------
  void applyEdits() {
    final editedBytes = Uint8List.fromList(img.encodeJpg(_previewManualImage, quality: 85));

    final imageNotifier = ref.read(imageViewModelProvider.notifier);
    final currentImage = imageNotifier.state.image;
    if (currentImage == null) return;

    imageNotifier.state = imageNotifier.state.copyWith(
      image: currentImage.copyWith(
        enhancedBytes: editedBytes,
        activeParams: state.params,
      ),
      showEnhanced: true,
    );
  }

  /// ---------------- TEMP IMAGE GETTER ----------------
  Uint8List get tempImageBytes {
    return Uint8List.fromList(img.encodeJpg(_previewManualImage, quality: 85));
  }
}
