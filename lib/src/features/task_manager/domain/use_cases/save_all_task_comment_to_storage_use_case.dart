import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class SaveAllTaskCommentToStorageUseCase
    implements UseCase<void, SaveAllTaskCommentToStorageParams> {
  const SaveAllTaskCommentToStorageUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, void>> call(SaveAllTaskCommentToStorageParams param) {
    return _repository.saveAllTaskCommentToStorage(
      taskComment: param.taskComment,
      taskID: param.taskID,
    );
  }
}

class SaveAllTaskCommentToStorageParams {
  const SaveAllTaskCommentToStorageParams({
    required this.taskComment,
    required this.taskID,
  });
  final List<TaskCommentEntity> taskComment;
  final String taskID;
}
