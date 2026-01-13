import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_comment_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late DeleteTaskCommentUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = DeleteTaskCommentUseCase(mockRepository);
  });

  const tCommentId = '2992679862';

  group('delete task comment use case ...', () {
    test(
      'should call [deleteTaskComment] from repository with correct id',
      () async {
        //! arrange
        when(
          () => mockRepository.deleteTaskComment(any()),
        ).thenAnswer((_) async => const Right(null));

        //! act
        final result = await useCase(tCommentId);

        //! assert
        expect(
          result,
          const Right<Failure, void>(null),
          reason: 'Should return [Right(null)] upon successful deletion',
        );
        verify(() => mockRepository.deleteTaskComment(tCommentId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return [Failure] when repository call fails', () async {
      //! arrange
      const failure = ServerFailure(message: 'failed to delete comment');
      when(
        () => mockRepository.deleteTaskComment(any()),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(tCommentId);

      //! assert
      expect(
        result,
        const Left<Failure, void>(failure),
        reason: 'Should propagate the [Failure] from the repository',
      );
      verify(() => mockRepository.deleteTaskComment(tCommentId)).called(1);
    });
  });
}
