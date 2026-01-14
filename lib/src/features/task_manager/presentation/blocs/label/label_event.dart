part of 'label_bloc.dart';

@freezed
abstract class LabelEvent with _$LabelEvent {
  const factory LabelEvent.getAllTaskLabel() = _GetAllTaskLabel;
  const factory LabelEvent.saveAllTaskLabelToStorage(
    List<TaskLabelEntity> labels,
  ) = _SaveAllTaskLabelToStorage;
  const factory LabelEvent.createTaskLabel(
    CreateTaskLabelEntity request,
  ) = _CreateTaskLabel;
  const factory LabelEvent.updateTaskLabel(
    CreateTaskLabelEntity request,
  ) = _UpdateTaskLabel;
  const factory LabelEvent.deleteTaskLabel(
    String id,
  ) = _DeleteTaskLabel;
}
