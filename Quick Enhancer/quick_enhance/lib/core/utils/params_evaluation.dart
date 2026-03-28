import '../../domain/enums/param_status.dart';

ParamStatus evaluateStatus({
  required double current,
  required double target,
}) {
  final d = current - target;

  if (d < -0.30) return ParamStatus.extremeLow;
  if (d < -0.20) return ParamStatus.veryLow;
  if (d < -0.12) return ParamStatus.low;
  if (d < -0.05) return ParamStatus.slightlyLow;

  if (d <= 0.05) return ParamStatus.perfect;

  if (d < 0.12) return ParamStatus.slightlyHigh;
  if (d < 0.20) return ParamStatus.high;
  if (d < 0.30) return ParamStatus.veryHigh;

  return ParamStatus.extremeHigh;
}
