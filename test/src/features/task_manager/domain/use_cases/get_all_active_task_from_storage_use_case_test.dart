import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_from_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllActiveTaskFromStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllActiveTaskFromStorageUseCase(mockRepository);
  });

  final tTasks = [TestEntities.tTaskEntity];

  group('get all active task from storage use case ...', () {
    test('should call [getAllActiveTaskFromStorage] from repository', () async {
      //! arrange
      when(
        () => mockRepository.getAllActiveTaskFromStorage(),
      ).thenAnswer((_) async => Right(tTasks));

      //! act
      final result = await useCase(const NoParams());

      //! assert
      expect(
        result,
        Right<Failure, List<TaskEntity>>(tTasks),
        reason: 'Should return a list of [TaskEntity] from local storage',
      );
      verify(() => mockRepository.getAllActiveTaskFromStorage()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return [CacheFailure] when storage retrieval fails', () async {
      //! arrange
      const failure = CacheFailure(message: 'no data found in storage');
      when(
        () => mockRepository.getAllActiveTaskFromStorage(),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(const NoParams());

      //! assert
      expect(
        result,
        const Left<Failure, List<TaskEntity>>(failure),
        reason: 'Should propagate the [CacheFailure] from the repository',
      );
      verify(() => mockRepository.getAllActiveTaskFromStorage()).called(1);
    });
  });
}
