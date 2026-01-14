part of 'task_bloc.dart';

@freezed
abstract class TaskEvent with _$TaskEvent {
  const factory TaskEvent.getAllActiveTask(GetActiveTasksFilterEntity request) =
      _GetAllActiveTask;
  const factory TaskEvent.saveAllTaskToStorage(List<TaskEntity> tasks) =
      _SaveAllTaskToStorage;
  const factory TaskEvent.createTask(
    CreateTaskEntity request,
  ) = _CreateTask;
  const factory TaskEvent.updateTask(
    CreateTaskEntity request,
  ) = _UpdateTask;
  const factory TaskEvent.deleteTask(
    String id,
  ) = _DeleteTask;
  const factory TaskEvent.updateTaskLocally(
    TaskEntity task,
  ) = _UpdateTaskLocally;

  const factory TaskEvent.closeTask(
    String id,
  ) = _CloseTask;

  const factory TaskEvent.reopenTask(
    String id,
  ) = _ReopenTask;
}
