// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_comment_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late CreateTaskCommentUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = CreateTaskCommentUseCase(mockRepository);
  });

  const tRequest = CreateCommentEntity(
    taskId: '2995104339',
    projectId: '2203306141',
    content: 'Need one bottle of milk',
  );

  group('create task comment use case ...', () {
    test(
      'should call [createTaskComment] from repository and return [TaskCommentEntity]',
      () async {
        //! arrange
        registerFallbackValue(tRequest);
        when(
          () => mockRepository.createTaskComment(any()),
        ).thenAnswer((_) async => Right(TestEntities.tCommentEntity));

        //! act
        final result = await useCase(tRequest);

        //! assert
        expect(
          result,
          Right<Failure, TaskCommentEntity>(TestEntities.tCommentEntity),
          reason: 'Should return [tCommentEntity] on success',
        );
        verify(() => mockRepository.createTaskComment(tRequest)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to create comment');
        when(
          () => mockRepository.createTaskComment(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tRequest);

        //! assert
        expect(
          result,
          const Left<Failure, TaskCommentEntity>(failure),
          reason: 'The [Failure] should be propagated from the repository',
        );
        verify(() => mockRepository.createTaskComment(tRequest)).called(1);
      },
    );
  });
}
