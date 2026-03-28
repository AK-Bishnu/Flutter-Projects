import '../../domain/enums/param_status.dart';

class ParamAnalysis {
  final double value;
  final double standard;
  final ParamStatus status;

  const ParamAnalysis({
    required this.value,
    required this.standard,
    required this.status,
  });
}
