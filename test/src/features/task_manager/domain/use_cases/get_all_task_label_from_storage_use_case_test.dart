// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_from_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllTaskLabelFromStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllTaskLabelFromStorageUseCase(mockRepository);
  });

  const tFilter = GetActiveTasksFilterEntity(projectId: '2203306141');
  const tLabels = [TestEntities.tLabelEntity];

  group('get all task label from storage use case ...', () {
    test(
      'should call [getAllTaskLabelFromStorage] from repository with correct filter',
      () async {
        //! arrange
        registerFallbackValue(tFilter);
        when(
          () => mockRepository.getAllTaskLabelFromStorage(),
        ).thenAnswer((_) async => const Right(tLabels));

        //! act
        final result = await useCase(const NoParams());

        //! assert
        expect(
          result,
          const Right<Failure, List<TaskLabelEntity>>(tLabels),
          reason: 'Should return list of [TaskLabelEntity] from storage',
        );
        verify(
          () => mockRepository.getAllTaskLabelFromStorage(),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return [CacheFailure] when storage retrieval fails', () async {
      //! arrange
      const failure = CacheFailure(message: 'no labels found in storage');
      when(
        () => mockRepository.getAllTaskLabelFromStorage(),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(const NoParams());

      //! assert
      expect(
        result,
        const Left<Failure, List<TaskLabelEntity>>(failure),
        reason: 'Should propagate the [CacheFailure] from the repository',
      );
      verify(
        () => mockRepository.getAllTaskLabelFromStorage(),
      ).called(1);
    });
  });
}
