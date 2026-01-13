import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';

class GetAllTaskLabelUseCase
    implements UseCase<List<TaskLabelEntity>, NoParams> {
  const GetAllTaskLabelUseCase(this._repository);
  final TaskManagerRepository _repository;

  @override
  Future<Either<Failure, List<TaskLabelEntity>>> call(NoParams param) {
    return _repository.getAllTaskLabel();
  }
}
