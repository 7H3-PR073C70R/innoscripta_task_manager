part of 'label_bloc.dart';

@freezed
abstract class LabelState with _$LabelState {
  const factory LabelState.initial({
    @Default(ViewState.idle) ViewState viewState,
    @Default(ViewState.idle) ViewState mutationState,
    @Default([]) List<TaskLabelEntity> labels,
    String? errorMessage,
  }) = _Initial;
}
