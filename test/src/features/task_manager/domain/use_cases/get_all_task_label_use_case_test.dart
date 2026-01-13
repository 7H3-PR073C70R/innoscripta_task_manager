import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllTaskLabelUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllTaskLabelUseCase(mockRepository);
  });

  const tLabels = [TestEntities.tLabelEntity];

  group('get all task label use case ...', () {
    test('should call [getAllTaskLabel] from repository', () async {
      //! arrange
      when(
        () => mockRepository.getAllTaskLabel(),
      ).thenAnswer((_) async => const Right(tLabels));

      //! act
      final result = await useCase(const NoParams());

      //! assert
      expect(
        result,
        const Right<Failure, List<TaskLabelEntity>>(tLabels),
        reason:
            'Should return list of [TaskLabelEntity] from the remote source',
      );
      verify(() => mockRepository.getAllTaskLabel()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return [ServerFailure] when repository call fails', () async {
      //! arrange
      const failure = ServerFailure(
        message: 'failed to fetch labels from server',
      );
      when(
        () => mockRepository.getAllTaskLabel(),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(const NoParams());

      //! assert
      expect(
        result,
        const Left<Failure, List<TaskLabelEntity>>(failure),
        reason: 'Should propagate the [ServerFailure] from the repository',
      );
      verify(() => mockRepository.getAllTaskLabel()).called(1);
    });
  });
}
