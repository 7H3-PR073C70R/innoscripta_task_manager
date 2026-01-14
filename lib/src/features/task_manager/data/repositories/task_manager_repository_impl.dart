import 'dart:isolate';

import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/extensions/repository_extension.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_local_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_remote_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class TaskManagerRepositoryImpl implements TaskManagerRepository {
  const TaskManagerRepositoryImpl({
    required TaskManagerLocalDataSource localDataSource,
    required TaskManagerRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final TaskManagerLocalDataSource _localDataSource;
  final TaskManagerRemoteDataSource _remoteDataSource;

  /// static function for Isolate execution
  static List<TaskEntity> _hydrateTasks(
    List<TaskEntity> remoteTasks,
    List<TaskEntity> localTasks,
  ) {
    final remoteMap = {for (final task in remoteTasks) task.id: task};
    final localMap = {for (final task in localTasks) task.id: task};

    // Use a LinkedHashSet to maintain order if possible, though ids are keys.
    // We want to return all remote tasks (hydrated)
    // + any local tasks that aren't in remote.
    final allIds = <String?>{
      ...remoteTasks.map((e) => e.id),
      ...localTasks.map((e) => e.id),
    };

    return allIds.map((id) {
      final remoteMatch = remoteMap[id];
      final localMatch = localMap[id];

      if (remoteMatch != null && localMatch != null) {
        // Hydrate remote task with local timer/status (local is source of truth for timer and isCompleted)
        return remoteMatch.copyWith(
          timer: localMatch.timer,
          status: localMatch.status,
          isCompleted: localMatch.isCompleted,
        );
      }

      if (remoteMatch != null) return remoteMatch;

      // If it's only in local, it might be a closed task or something new.
      return localMatch!;
    }).toList();
  }

  //! Tasks
  @override
  Future<Either<Failure, List<TaskEntity>>> getAllActiveTask(
    GetActiveTasksFilterEntity request,
  ) async {
    final response = await _remoteDataSource
        .getAllActiveTask(request)
        .makeRequest();

    if (response.isRight) {
      final remoteTasks = response.fold(
        (_) => <TaskEntity>[],
        (tasks) => tasks,
      );
      final localTasks = await _localDataSource.getAllActiveTaskFromStorage();

      // Offload the heavy merging logic to a separate Isolate
      final hydratedTasks = await Isolate.run(() {
        return _hydrateTasks(remoteTasks, localTasks);
      });

      // return hydratedTasks
      return Right(hydratedTasks.toList());
    }
    return response;
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(CreateTaskEntity request) {
    return _remoteDataSource.createTask(request).makeRequest();
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(
    CreateTaskEntity request,
  ) {
    return _remoteDataSource.updateTask(request).makeRequest();
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) {
    return _remoteDataSource.deleteTask(id).makeRequest();
  }

  @override
  Future<Either<Failure, void>> closeTask(String id) {
    return _remoteDataSource.closeTask(id).makeRequest();
  }

  @override
  Future<Either<Failure, void>> reopenTask(String id) {
    return _remoteDataSource.reopenTask(id).makeRequest();
  }

  //! Task-Label
  @override
  Future<Either<Failure, List<TaskLabelEntity>>> getAllTaskLabel() {
    return _remoteDataSource.getAllTaskLabel().makeRequest();
  }

  @override
  Future<Either<Failure, TaskLabelEntity>> createTaskLabel(
    CreateTaskLabelEntity request,
  ) {
    return _remoteDataSource.createTaskLabel(request).makeRequest();
  }

  @override
  Future<Either<Failure, TaskLabelEntity>> updateTaskLabel(
    CreateTaskLabelEntity request,
  ) {
    return _remoteDataSource.updateTaskLabel(request).makeRequest();
  }

  @override
  Future<Either<Failure, void>> deleteTaskLabel(String id) {
    return _remoteDataSource.deleteTaskLabel(id).makeRequest();
  }

  //! Task-Comment
  @override
  Future<Either<Failure, List<TaskCommentEntity>>> getAllTaskComment(
    GetCommentsFilterEntity request,
  ) {
    return _remoteDataSource.getAllTaskComment(request).makeRequest();
  }

  @override
  Future<Either<Failure, TaskCommentEntity>> createTaskComment(
    CreateCommentEntity request,
  ) {
    return _remoteDataSource.createTaskComment(request).makeRequest();
  }

  //! Local Storage (Cache Requests)
  @override
  Future<Either<Failure, List<TaskEntity>>> getAllActiveTaskFromStorage() {
    return _localDataSource.getAllActiveTaskFromStorage().makeRequest();
  }

  @override
  Future<Either<Failure, void>> saveAllTaskToStorage(List<TaskEntity> request) {
    return _localDataSource.saveAllTaskToStorage(request).makeRequest();
  }

  @override
  Future<Either<Failure, void>> saveAllTaskCommentToStorage({
    required List<TaskCommentEntity> taskComment,
    required String taskID,
  }) {
    return _localDataSource
        .saveAllTaskCommentToStorage(taskComment: taskComment, taskID: taskID)
        .makeRequest();
  }

  @override
  Future<Either<Failure, void>> deleteTaskComment(String id) {
    return _remoteDataSource.deleteTaskComment(id).makeRequest();
  }

  @override
  Future<Either<Failure, List<TaskCommentEntity>>> getAllTaskCommentFromStorage(
    String id,
  ) {
    return _localDataSource.getAllTaskCommentFromStorage(id).makeRequest();
  }

  @override
  Future<Either<Failure, List<TaskLabelEntity>>> getAllTaskLabelFromStorage() {
    return _localDataSource.getAllTaskLabelFromStorage().makeRequest();
  }

  @override
  Future<Either<Failure, void>> saveAllTaskLabelToStorage(
    List<TaskLabelEntity> request,
  ) {
    return _localDataSource.saveAllTaskLabelToStorage(request).makeRequest();
  }

  @override
  Future<Either<Failure, TaskCommentEntity>> updateTaskComment(
    CreateCommentEntity request,
  ) {
    return _remoteDataSource.updateTaskComment(request).makeRequest();
  }
}
