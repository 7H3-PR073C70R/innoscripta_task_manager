import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class SaveAllTaskToStorageUseCase implements UseCase<void, List<TaskEntity>> {
  const SaveAllTaskToStorageUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, void>> call(List<TaskEntity> param) {
    return _repository.saveAllTaskToStorage(param);
  }
}
