import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_to_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late SaveAllTaskToStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = SaveAllTaskToStorageUseCase(mockRepository);
  });

  final tTasks = [TestEntities.tTaskEntity];

  group('save all task to storage use case ...', () {
    test('should call [saveAllTaskToStorage] from repository', () async {
      //! arrange
      when(
        () => mockRepository.saveAllTaskToStorage(any()),
      ).thenAnswer((_) async => const Right(null));

      //! act
      final result = await useCase(tTasks);

      //! assert
      expect(
        result,
        const Right<Failure, void>(null),
        reason: 'Should return [Right(null)] when tasks are saved to storage',
      );
      verify(() => mockRepository.saveAllTaskToStorage(tTasks)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return [CacheFailure] when repository fails to save tasks',
      () async {
        //! arrange
        const failure = CacheFailure(
          message: 'failed to save tasks to local storage',
        );
        when(
          () => mockRepository.saveAllTaskToStorage(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tTasks);

        //! assert
        expect(
          result,
          const Left<Failure, void>(failure),
          reason: 'Should propagate the [CacheFailure] from the repository',
        );
        verify(() => mockRepository.saveAllTaskToStorage(tTasks)).called(1);
      },
    );
  });
}
