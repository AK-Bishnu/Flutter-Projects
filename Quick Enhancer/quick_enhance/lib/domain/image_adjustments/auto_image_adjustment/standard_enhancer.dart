import 'package:image/image.dart' as img;

import '../../entities/image_params.dart';
import '../params_adjustments/brightness.dart';
import '../params_adjustments/contrast.dart';
import '../params_adjustments/generate_auto_params.dart';
import '../params_adjustments/highlights.dart';
import '../params_adjustments/saturation.dart';
import '../params_adjustments/shadows.dart';

img.Image applyStandardEnhancement(
    img.Image image,
    ImageParams baseParams,
    ) {
  // 1️⃣ Decide auto adjustments
  final autoDelta = generateStandardAutoParams(baseParams);

  // 2️⃣ Merge with current params
  final finalParams = mergeParams(baseParams, autoDelta);

  // 3️⃣ Apply AUTO-SAFE pixel operations
  img.Image enhanced = image.clone();

  if (finalParams.brightness != 0) {
    enhanced = applyBrightnessAuto(enhanced, finalParams.brightness);
  }

  if (finalParams.contrast != 0) {
    enhanced = applyContrastAuto(enhanced, finalParams.contrast);
  }

  if (finalParams.saturation != 0) {
    enhanced = applySaturationAuto(enhanced, finalParams.saturation);
  }

  if (finalParams.highlights != 0) {
    enhanced = applyHighlightsAuto(enhanced, finalParams.highlights);
  }

  if (finalParams.shadows != 0) {
    enhanced = applyShadowsAuto(enhanced, finalParams.shadows);
  }

  return enhanced;
}
