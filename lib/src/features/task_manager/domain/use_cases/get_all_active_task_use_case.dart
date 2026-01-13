import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class GetAllActiveTaskUseCase
    implements UseCase<List<TaskEntity>, GetActiveTasksFilterEntity> {
  const GetAllActiveTaskUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(
    GetActiveTasksFilterEntity param,
  ) {
    return _repository.getAllActiveTask(param);
  }
}
