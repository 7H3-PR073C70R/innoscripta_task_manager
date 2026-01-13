// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_label_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late UpdateTaskLabelUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = UpdateTaskLabelUseCase(mockRepository);
  });

  const tUpdateParams = CreateTaskLabelEntity(
    id: '2995104339',
    name: 'Urgent',
    order: 2,
  );

  group('update task label use case ...', () {
    test(
      'should call [updateTaskLabel] from repository and return [TaskLabelEntity]',
      () async {
        //! arrange
        registerFallbackValue(tUpdateParams);
        when(
          () => mockRepository.updateTaskLabel(any()),
        ).thenAnswer((_) async => const Right(TestEntities.tLabelEntity));

        //! act
        final result = await useCase(tUpdateParams);

        //! assert
        expect(
          result,
          const Right<Failure, TaskLabelEntity>(TestEntities.tLabelEntity),
          reason: 'Should return updated [TaskLabelEntity] on success',
        );
        verify(() => mockRepository.updateTaskLabel(tUpdateParams)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to update task label');
        when(
          () => mockRepository.updateTaskLabel(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tUpdateParams);

        //! assert
        expect(
          result,
          const Left<Failure, TaskLabelEntity>(failure),
          reason: 'The [Failure] should be propagated from the repository',
        );
        verify(() => mockRepository.updateTaskLabel(tUpdateParams)).called(1);
      },
    );
  });
}
