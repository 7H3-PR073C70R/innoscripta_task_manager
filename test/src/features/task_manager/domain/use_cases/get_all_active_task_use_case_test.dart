import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllActiveTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllActiveTaskUseCase(mockRepository);
  });

  const tFilter = GetActiveTasksFilterEntity(
    projectId: '2203306141',
  );

  final tTasks = [TestEntities.tTaskEntity];

  group('get all active task use case ...', () {
    test(
      'should call [getAllActiveTask] from repository with correct filter',
      () async {
        //! arrange
        registerFallbackValue(tFilter);
        when(
          () => mockRepository.getAllActiveTask(any()),
        ).thenAnswer((_) async => Right(tTasks));

        //! act
        final result = await useCase(tFilter);

        //! assert
        expect(
          result,
          Right<Failure, List<TaskEntity>>(tTasks),
          reason: 'Should return list of [TaskEntity] on success',
        );
        verify(() => mockRepository.getAllActiveTask(tFilter)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to fetch tasks');
        when(
          () => mockRepository.getAllActiveTask(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tFilter);

        //! assert
        expect(
          result,
          const Left<Failure, List<TaskEntity>>(failure),
          reason: 'Should propagate [Failure] from repository',
        );
        verify(() => mockRepository.getAllActiveTask(tFilter)).called(1);
      },
    );
  });
}
