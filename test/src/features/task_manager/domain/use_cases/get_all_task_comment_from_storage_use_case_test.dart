// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_from_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late GetAllTaskCommentFromStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = GetAllTaskCommentFromStorageUseCase(mockRepository);
  });

  const tId = '2995104339';

  final tComments = [TestEntities.tCommentEntity];

  group('get all task comment from storage use case ...', () {
    test(
      'should call [getAllTaskCommentFromStorage] from repository with correct filter',
      () async {
        //! arrange
        registerFallbackValue(tId);
        when(
          () => mockRepository.getAllTaskCommentFromStorage(any()),
        ).thenAnswer((_) async => Right(tComments));

        //! act
        final result = await useCase(tId);

        //! assert
        expect(
          result,
          Right<Failure, List<TaskCommentEntity>>(tComments),
          reason:
              'Should return list of [TaskCommentEntity] from local storage',
        );
        verify(
          () => mockRepository.getAllTaskCommentFromStorage(tId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return [CacheFailure] when storage retrieval fails', () async {
      //! arrange
      const failure = CacheFailure(message: 'no comments found in storage');
      when(
        () => mockRepository.getAllTaskCommentFromStorage(any()),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(tId);

      //! assert
      expect(
        result,
        const Left<Failure, List<TaskCommentEntity>>(failure),
        reason: 'Should propagate [CacheFailure] from repository',
      );
      verify(
        () => mockRepository.getAllTaskCommentFromStorage(tId),
      ).called(1);
    });
  });
}
