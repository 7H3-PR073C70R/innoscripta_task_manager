import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late DeleteTaskUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = DeleteTaskUseCase(mockRepository);
  });

  const tTaskId = '2995104339';

  group('delete task use case ...', () {
    test('should call [deleteTask] from repository with correct id', () async {
      //! arrange
      when(
        () => mockRepository.deleteTask(any()),
      ).thenAnswer((_) async => const Right(null));

      //! act
      final result = await useCase(tTaskId);

      //! assert
      expect(
        result,
        const Right<Failure, void>(null),
        reason: 'Should return [Right(null)] when task is successfully deleted',
      );
      verify(() => mockRepository.deleteTask(tTaskId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return [Failure] when repository call fails', () async {
      //! arrange
      const failure = ServerFailure(message: 'failed to delete task');
      when(
        () => mockRepository.deleteTask(any()),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(tTaskId);

      //! assert
      expect(
        result,
        const Left<Failure, void>(failure),
        reason: 'Should propagate the [Failure] from the repository',
      );
      verify(() => mockRepository.deleteTask(tTaskId)).called(1);
    });
  });
}
