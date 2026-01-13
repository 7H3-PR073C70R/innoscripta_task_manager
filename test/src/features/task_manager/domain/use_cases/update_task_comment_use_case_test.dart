// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_comment_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late UpdateTaskCommentUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = UpdateTaskCommentUseCase(mockRepository);
  });

  const tUpdateParams = CreateCommentEntity(
    id: '2995104339',
    content: 'Updated comment content',
    taskId: '2995104339',
    projectId: '',
  );

  group('update task comment use case ...', () {
    test(
      'should call [updateTaskComment] from repository and return [TaskCommentEntity]',
      () async {
        //! arrange
        registerFallbackValue(tUpdateParams);
        when(
          () => mockRepository.updateTaskComment(any()),
        ).thenAnswer((_) async => Right(TestEntities.tCommentEntity));

        //! act
        final result = await useCase(tUpdateParams);

        //! assert
        expect(
          result,
          Right<Failure, TaskCommentEntity>(TestEntities.tCommentEntity),
          reason: 'Should return the updated [TaskCommentEntity]',
        );
        verify(() => mockRepository.updateTaskComment(tUpdateParams)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return [Failure] when repository update fails', () async {
      //! arrange
      const failure = ServerFailure(message: 'failed to update comment');
      when(
        () => mockRepository.updateTaskComment(any()),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(tUpdateParams);

      //! assert
      expect(
        result,
        const Left<Failure, TaskCommentEntity>(failure),
        reason: 'Should propagate the [Failure] from the repository',
      );
      verify(() => mockRepository.updateTaskComment(tUpdateParams)).called(1);
    });
  });
}
