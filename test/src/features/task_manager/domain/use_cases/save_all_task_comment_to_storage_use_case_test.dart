import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_comment_to_storage_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/test_entities.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late SaveAllTaskCommentToStorageUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = SaveAllTaskCommentToStorageUseCase(mockRepository);
  });

  final tComments = [TestEntities.tCommentEntity];
  const tTaskId = '2995104339';
  final tParams = SaveAllTaskCommentToStorageParams(
    taskComment: tComments,
    taskID: tTaskId,
  );

  group('save all task comment to storage use case ...', () {
    test(
      'should call repository to save comments with correct parameters',
      () async {
        //! arrange
        when(
          () => mockRepository.saveAllTaskCommentToStorage(
            taskComment: any(named: 'taskComment'),
            taskID: any(named: 'taskID'),
          ),
        ).thenAnswer((_) async => const Right(null));

        //! act
        final result = await useCase(tParams);

        //! assert
        expect(
          result,
          const Right<Failure, void>(null),
          reason: 'Should return [Right(null)] on successful save',
        );
        verify(
          () => mockRepository.saveAllTaskCommentToStorage(
            taskComment: tComments,
            taskID: tTaskId,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return [CacheFailure] when repository fails to save',
      () async {
        //! arrange
        const failure = CacheFailure(
          message: 'failed to save comments to storage',
        );
        when(
          () => mockRepository.saveAllTaskCommentToStorage(
            taskComment: any(named: 'taskComment'),
            taskID: any(named: 'taskID'),
          ),
        ).thenAnswer((_) async => const Left(failure));

        //! act
        final result = await useCase(tParams);

        //! assert
        expect(
          result,
          const Left<Failure, void>(failure),
          reason: 'Should propagate the [CacheFailure] from the repository',
        );
        verify(
          () => mockRepository.saveAllTaskCommentToStorage(
            taskComment: tComments,
            taskID: tTaskId,
          ),
        ).called(1);
      },
    );
  });
}
