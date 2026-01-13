import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_label_to_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late SaveAllTaskLabelToStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = SaveAllTaskLabelToStorageUseCase(mockRepository);
  });

  final tLabels = [TestEntities.tLabelEntity];

  group('save all task label to storage use case ...', () {
    test('should call [saveAllTaskLabelToStorage] from repository', () async {
      //! arrange
      when(
        () => mockRepository.saveAllTaskLabelToStorage(any()),
      ).thenAnswer((_) async => const Right(null));

      //! act
      final result = await useCase(tLabels);

      //! assert
      expect(
        result,
        const Right<Failure, void>(null),
        reason:
            'Should return [Right(null)] when labels are saved successfully',
      );
      verify(() => mockRepository.saveAllTaskLabelToStorage(tLabels)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return [CacheFailure] when repository fails to save labels',
      () async {
        //! arrange
        const failure = CacheFailure(
          message: 'could not save labels to storage',
        );
        when(
          () => mockRepository.saveAllTaskLabelToStorage(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tLabels);

        //! assert
        expect(
          result,
          const Left<Failure, void>(failure),
          reason: 'Should propagate the [CacheFailure] from the repository',
        );
        verify(
          () => mockRepository.saveAllTaskLabelToStorage(tLabels),
        ).called(1);
      },
    );
  });
}
