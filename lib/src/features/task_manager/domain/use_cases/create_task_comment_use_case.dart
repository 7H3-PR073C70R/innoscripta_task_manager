import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class CreateTaskCommentUseCase
    implements UseCase<TaskCommentEntity, CreateCommentEntity> {
  const CreateTaskCommentUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, TaskCommentEntity>> call(CreateCommentEntity param) {
    return _repository.createTaskComment(param);
  }
}
