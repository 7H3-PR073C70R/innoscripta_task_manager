import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class GetAllActiveTaskFromStorageUseCase
    implements UseCase<List<TaskEntity>, NoParams> {
  const GetAllActiveTaskFromStorageUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams param) {
    return _repository.getAllActiveTaskFromStorage();
  }
}
