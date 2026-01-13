import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class DeleteTaskCommentUseCase implements UseCase<void, String> {
  const DeleteTaskCommentUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, void>> call(String param) {
    return _repository.deleteTaskComment(param);
  }
}
