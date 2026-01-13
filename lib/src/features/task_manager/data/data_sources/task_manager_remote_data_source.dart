import 'package:innoscripta_task_manager/src/features/task_manager/data/client/task_manager_client.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/create_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/get_comments_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/create_task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/create_task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/get_active_task_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';

abstract interface class TaskManagerRemoteDataSource {
  //! Task
  Future<List<TaskEntity>> getAllActiveTask(
    GetActiveTasksFilterEntity request,
  );

  Future<TaskEntity> createTask(
    CreateTaskEntity request,
  );

  Future<TaskEntity> updateTask(
    CreateTaskEntity request,
  );

  Future<void> deleteTask(String id);

  //! Task-Label
  Future<List<TaskLabelEntity>> getAllTaskLabel();

  Future<TaskLabelEntity> createTaskLabel(
    CreateTaskLabelEntity request,
  );

  Future<TaskLabelEntity> updateTaskLabel(
    CreateTaskLabelEntity request,
  );

  Future<void> deleteTaskLabel(String id);

  //! Task-Comment
  Future<List<TaskCommentEntity>> getAllTaskComment(
    GetCommentsFilterEntity request,
  );

  Future<TaskCommentEntity> createTaskComment(
    CreateCommentEntity request,
  );

  Future<TaskCommentEntity> updateTaskComment(
    CreateCommentEntity request,
  );

  Future<void> deleteTaskComment(String id);
}

class TaskManagerRemoteDataSourceImpl implements TaskManagerRemoteDataSource {
  const TaskManagerRemoteDataSourceImpl(this._client);
  final TaskManagerClient _client;

  //! Task
  @override
  Future<List<TaskEntity>> getAllActiveTask(
    GetActiveTasksFilterEntity request,
  ) async {
    return _client.getAllActiveTask(
      GetActiveTasksFilterModel.fromEntity(request),
    );
  }

  @override
  Future<TaskEntity> createTask(CreateTaskEntity request) async {
    return _client.createTask(
      CreateTaskModel.fromEntity(request),
    );
  }

  @override
  Future<TaskEntity> updateTask(CreateTaskEntity request) async {
    return _client.updateTask(
      request.id,
      CreateTaskModel.fromEntity(request),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await _client.deleteTask(id);
  }

  //! Task-Label
  @override
  Future<List<TaskLabelEntity>> getAllTaskLabel() async {
    return _client.getAllTaskLabel();
  }

  @override
  Future<TaskLabelEntity> createTaskLabel(CreateTaskLabelEntity request) async {
    return _client.createTaskLabel(
      CreateTaskLabelModel.fromEntity(request),
    );
  }

  @override
  Future<TaskLabelEntity> updateTaskLabel(
    CreateTaskLabelEntity request,
  ) async {
    return _client.updateTaskLabel(
      request.id,
      CreateTaskLabelModel.fromEntity(request),
    );
  }

  @override
  Future<void> deleteTaskLabel(String id) async {
    await _client.deleteTaskLabel(id);
  }

  //! Task-Comment
  @override
  Future<List<TaskCommentEntity>> getAllTaskComment(
    GetCommentsFilterEntity request,
  ) async {
    return _client.getAllTaskComment(
      GetCommentsFilterModel.fromEntity(request),
    );
  }

  @override
  Future<TaskCommentEntity> createTaskComment(
    CreateCommentEntity request,
  ) async {
    return _client.createTaskComment(
      CreateCommentModel.fromEntity(request),
    );
  }

  @override
  Future<TaskCommentEntity> updateTaskComment(
    CreateCommentEntity request,
  ) async {
    return _client.updateTaskComment(
      request.id,
      CreateCommentModel.fromEntity(request),
    );
  }

  @override
  Future<void> deleteTaskComment(String id) async {
    await _client.deleteTaskComment(id);
  }
}
