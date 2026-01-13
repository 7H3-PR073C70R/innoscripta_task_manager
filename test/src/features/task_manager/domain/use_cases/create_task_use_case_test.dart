import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late CreateTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = CreateTaskUseCase(mockRepository);
  });

  const tRequest = CreateTaskEntity(
    id: '2995104339',
    content: 'Buy Milk',
    description: 'Grocery shopping',
    priority: 1,
  );

  group('create task use case ...', () {
    test(
      'should call [createTask] from repository and return [TaskEntity]',
      () async {
        //! arrange
        registerFallbackValue(tRequest);
        when(
          () => mockRepository.createTask(any()),
        ).thenAnswer((_) async => Right(TestEntities.tTaskEntity));

        //! act
        final result = await useCase(tRequest);

        //! assert
        expect(
          result,
          Right<Failure, TaskEntity>(TestEntities.tTaskEntity),
          reason: 'Should return [tTaskEntity] from [TestEntities] on success',
        );
        verify(() => mockRepository.createTask(tRequest)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to create task');
        when(
          () => mockRepository.createTask(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tRequest);

        //! assert
        expect(
          result,
          const Left<Failure, TaskEntity>(failure),
          reason: 'Should propagate the [Failure] from the repository',
        );
        verify(() => mockRepository.createTask(tRequest)).called(1);
      },
    );
  });
}
