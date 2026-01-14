part of 'task_bloc.dart';

@freezed
abstract class TaskState with _$TaskState {
  const factory TaskState.initial({
    @Default(ViewState.idle) ViewState viewState,
    @Default(ViewState.idle) ViewState mutationState,
    @Default([]) List<TaskEntity> tasks,
    String? errorMessage,
  }) = _Initial;
}
