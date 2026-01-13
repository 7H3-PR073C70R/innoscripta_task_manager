import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllTaskCommentUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllTaskCommentUseCase(mockRepository);
  });

  const tFilter = GetCommentsFilterEntity(
    taskId: '2995104339',
    projectId: '',
  );

  final tComments = [TestEntities.tCommentEntity];

  group('get all task comment use case ...', () {
    test(
      'should call [getAllTaskComment] from repository with correct filter',
      () async {
        //! arrange
        registerFallbackValue(tFilter);
        when(
          () => mockRepository.getAllTaskComment(any()),
        ).thenAnswer((_) async => Right(tComments));

        //! act
        final result = await useCase(tFilter);

        //! assert
        expect(
          result,
          Right<Failure, List<TaskCommentEntity>>(tComments),
          reason: 'Should return a list of [TaskCommentEntity] on success',
        );
        verify(() => mockRepository.getAllTaskComment(tFilter)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [Failure] when repository call is unsuccessful',
      () async {
        //! arrange
        const failure = ServerFailure(message: 'failed to fetch comments');
        when(
          () => mockRepository.getAllTaskComment(any()),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tFilter);

        //! assert
        expect(
          result,
          const Left<Failure, List<TaskCommentEntity>>(failure),
          reason: 'Should propagate the [Failure] from the repository',
        );
        verify(() => mockRepository.getAllTaskComment(tFilter)).called(1);
      },
    );
  });
}
