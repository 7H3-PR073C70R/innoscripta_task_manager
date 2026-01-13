import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late UpdateTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = UpdateTaskUseCase(mockRepository);
  });

  const tUpdateParams = CreateTaskEntity(
    content: 'Update Task Name',
    description: 'Updated description',
  );

  group('update task use case ...', () {
    test(
      'should call [updateTask] from repository and return [TaskEntity]',
      () async {
        //! arrange
        registerFallbackValue(tUpdateParams);
        when(
          () => mockRepository.updateTask(any()),
        ).thenAnswer((_) async => Right(TestEntities.tTaskEntity));

        //! act
        final result = await useCase(tUpdateParams);

        //! assert
        expect(
          result,
          Right<Failure, TaskEntity>(TestEntities.tTaskEntity),
          reason: 'Should return updated [TaskEntity] on success',
        );
        verify(() => mockRepository.updateTask(tUpdateParams)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to update task');
        when(
          () => mockRepository.updateTask(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tUpdateParams);

        //! assert
        expect(
          result,
          const Left<Failure, TaskEntity>(failure),
          reason: 'The [Failure] should be propagated from the repository',
        );
        verify(() => mockRepository.updateTask(tUpdateParams)).called(1);
      },
    );
  });
}
