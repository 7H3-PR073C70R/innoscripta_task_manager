import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';

abstract interface class TaskManagerRepository {
  //! Task
  Future<Either<Failure, List<TaskEntity>>> getAllActiveTask(
    GetActiveTasksFilterEntity request,
  );

  Future<Either<Failure, List<TaskEntity>>> getAllActiveTaskFromStorage();

  Future<Either<Failure, void>> saveAllTaskToStorage(
    List<TaskEntity> request,
  );

  Future<Either<Failure, TaskEntity>> createTask(
    CreateTaskEntity request,
  );

  Future<Either<Failure, TaskEntity>> updateTask(
    CreateTaskEntity request,
  );

  Future<Either<Failure, void>> deleteTask(String id);

  //! Task-Label
  Future<Either<Failure, List<TaskLabelEntity>>> getAllTaskLabel();

  Future<Either<Failure, List<TaskLabelEntity>>> getAllTaskLabelFromStorage(
    GetActiveTasksFilterEntity request,
  );

  Future<Either<Failure, void>> saveAllTaskLabelToStorage(
    List<TaskLabelEntity> request,
  );

  Future<Either<Failure, TaskLabelEntity>> createTaskLabel(
    CreateTaskLabelEntity request,
  );

  Future<Either<Failure, TaskLabelEntity>> updateTaskLabel(
    CreateTaskLabelEntity request,
  );

  Future<Either<Failure, void>> deleteTaskLabel(String id);

  //! Task-Comment
  Future<Either<Failure, List<TaskCommentEntity>>> getAllTaskComment(
    GetCommentsFilterEntity request,
  );

  Future<Either<Failure, List<TaskCommentEntity>>> getAllTaskCommentFromStorage(
    GetCommentsFilterEntity request,
  );

  Future<Either<Failure, void>> saveAllTaskCommentToStorage({
    required List<TaskCommentEntity> taskComment,
    required String taskID,
  });

  Future<Either<Failure, TaskCommentEntity>> createTaskComment(
    CreateCommentEntity request,
  );

  Future<Either<Failure, TaskCommentEntity>> updateTaskComment(
    CreateCommentEntity request,
  );

  Future<Either<Failure, void>> deleteTaskComment(String id);
}
