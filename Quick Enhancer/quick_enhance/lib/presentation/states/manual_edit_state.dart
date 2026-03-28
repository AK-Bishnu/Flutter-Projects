import '../../domain/entities/image_params.dart';


class ManualEditState {
  final ImageParams params;
  final bool loading;

  const ManualEditState({
    required this.params,
    this.loading = false,
  });

  ManualEditState copyWith({
    ImageParams? params,
    bool? loading,
  }) {
    return ManualEditState(
      params: params ?? this.params,
      loading: loading ?? this.loading,
    );
  }
}