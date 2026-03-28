import '../../../core/constants/standard_image_model.dart';
import '../../../core/utils/params_evaluation.dart';
import '../../entities/image_params.dart';
import '../auto_image_adjustment/stnd_params_mapper.dart';

ImageParams generateStandardAutoParams(ImageParams current) {
  final target = StandardImageParams.reference;

  final bStatus = evaluateStatus(
    current: current.brightness,
    target: target.brightness,
  );

  final cStatus = evaluateStatus(
    current: current.contrast,
    target: target.contrast,
  );

  final sStatus = evaluateStatus(
    current: current.saturation,
    target: target.saturation,
  );

  final hStatus = evaluateStatus(
    current: current.highlights,
    target: target.highlights,
  );

  final shStatus = evaluateStatus(
    current: current.shadows,
    target: target.shadows,
  );

  return ImageParams(
    brightness: StandardParamMapper.brightnessAdjustment(bStatus),
    contrast: StandardParamMapper.contrastAdjustment(cStatus),
    saturation: StandardParamMapper.saturationAdjustment(sStatus),
    highlights: StandardParamMapper.highlightsAdjustment(hStatus),
    shadows: StandardParamMapper.shadowsAdjustment(shStatus),
  );
}

ImageParams mergeParams(ImageParams base, ImageParams delta) {
  return ImageParams(
    brightness: base.brightness + delta.brightness,
    contrast: base.contrast + delta.contrast,
    saturation: base.saturation + delta.saturation,
    highlights: base.highlights + delta.highlights,
    shadows: base.shadows + delta.shadows,
  );
}
