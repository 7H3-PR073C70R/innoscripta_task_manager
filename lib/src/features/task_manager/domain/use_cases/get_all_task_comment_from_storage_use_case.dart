import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class GetAllTaskCommentFromStorageUseCase
    implements UseCase<List<TaskCommentEntity>, String> {
  const GetAllTaskCommentFromStorageUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, List<TaskCommentEntity>>> call(
    String param,
  ) {
    return _repository.getAllTaskCommentFromStorage(param);
  }
}
