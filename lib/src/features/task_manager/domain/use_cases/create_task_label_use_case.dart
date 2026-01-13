import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class CreateTaskLabelUseCase
    implements UseCase<TaskLabelEntity, CreateTaskLabelEntity> {
  const CreateTaskLabelUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, TaskLabelEntity>> call(CreateTaskLabelEntity param) {
    return _repository.createTaskLabel(param);
  }
}
