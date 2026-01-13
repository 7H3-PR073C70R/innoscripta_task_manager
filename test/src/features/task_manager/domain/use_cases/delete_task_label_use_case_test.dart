import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/repositories/task_manager_repository.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_label_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskManagerRepository extends Mock implements TaskManagerRepository {}

void main() {
  late MockTaskManagerRepository mockRepository;
  late DeleteTaskLabelUseCase useCase;

  setUp(() {
    mockRepository = MockTaskManagerRepository();
    useCase = DeleteTaskLabelUseCase(mockRepository);
  });

  const tLabelId = '2156154810';

  group('delete task label use case ...', () {
    test(
      'should call [deleteTaskLabel] from repository with correct id',
      () async {
        //! arrange
        when(
          () => mockRepository.deleteTaskLabel(any()),
        ).thenAnswer((_) async => const Right(null));

        //! act
        final result = await useCase(tLabelId);

        //! assert
        expect(
          result,
          const Right<Failure, void>(null),
          reason: 'Should return [Right(null)] upon successful deletion',
        );
        verify(() => mockRepository.deleteTaskLabel(tLabelId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should return [Failure] when repository call fails', () async {
      //! arrange
      const failure = ServerFailure(message: 'failed to delete label');
      when(
        () => mockRepository.deleteTaskLabel(any()),
      ).thenAnswer((_) async => const Left(failure));

      //! act
      final result = await useCase(tLabelId);

      //! assert
      expect(
        result,
        const Left<Failure, void>(failure),
        reason: 'Should propagate the [Failure] from the repository',
      );
      verify(() => mockRepository.deleteTaskLabel(tLabelId)).called(1);
    });
  });
}
