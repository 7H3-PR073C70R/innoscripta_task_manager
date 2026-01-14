// ignore_for_file: avoid_redundant_argument_values, document_ignores

import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_label_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/test_entities.dart';

// Mock use cases
class MockGetAllTaskLabelUseCase extends Mock
    implements GetAllTaskLabelUseCase {}

class MockGetAllTaskLabelFromStorageUseCase extends Mock
    implements GetAllTaskLabelFromStorageUseCase {}

class MockSaveAllTaskLabelToStorageUseCase extends Mock
    implements SaveAllTaskLabelToStorageUseCase {}

class MockCreateTaskLabelUseCase extends Mock
    implements CreateTaskLabelUseCase {}

class MockUpdateTaskLabelUseCase extends Mock
    implements UpdateTaskLabelUseCase {}

class MockDeleteTaskLabelUseCase extends Mock
    implements DeleteTaskLabelUseCase {}

void main() {
  late LabelBloc labelBloc;
  late MockGetAllTaskLabelUseCase mockGetAllTaskLabelUseCase;
  late MockGetAllTaskLabelFromStorageUseCase
  mockGetAllTaskLabelFromStorageUseCase;
  late MockSaveAllTaskLabelToStorageUseCase
  mockSaveAllTaskLabelToStorageUseCase;
  late MockCreateTaskLabelUseCase mockCreateTaskLabelUseCase;
  late MockUpdateTaskLabelUseCase mockUpdateTaskLabelUseCase;
  late MockDeleteTaskLabelUseCase mockDeleteTaskLabelUseCase;

  setUp(() {
    mockGetAllTaskLabelUseCase = MockGetAllTaskLabelUseCase();
    mockGetAllTaskLabelFromStorageUseCase =
        MockGetAllTaskLabelFromStorageUseCase();
    mockSaveAllTaskLabelToStorageUseCase =
        MockSaveAllTaskLabelToStorageUseCase();
    mockCreateTaskLabelUseCase = MockCreateTaskLabelUseCase();
    mockUpdateTaskLabelUseCase = MockUpdateTaskLabelUseCase();
    mockDeleteTaskLabelUseCase = MockDeleteTaskLabelUseCase();

    labelBloc = LabelBloc(
      getAllTaskLabelUseCase: mockGetAllTaskLabelUseCase,
      getAllTaskLabelFromStorageUseCase: mockGetAllTaskLabelFromStorageUseCase,
      saveAllTaskLabelToStorageUseCase: mockSaveAllTaskLabelToStorageUseCase,
      createTaskLabelUseCase: mockCreateTaskLabelUseCase,
      updateTaskLabelUseCase: mockUpdateTaskLabelUseCase,
      deleteTaskLabelUseCase: mockDeleteTaskLabelUseCase,
    );

    // Register fallback values
    registerFallbackValue(const NoParams());
    registerFallbackValue(<TaskLabelEntity>[]);
    registerFallbackValue(
      const CreateTaskLabelEntity(
        id: '',
        name: '',
      ),
    );
  });

  tearDown(() async {
    await labelBloc.close();
  });

  group('LabelBloc', () {
    test('initial state is correct', () {
      expect(
        labelBloc.state,
        const LabelState.initial(
          viewState: ViewState.idle,
          mutationState: ViewState.idle,
          labels: [],
          errorMessage: null,
        ),
      );
    });

    group('getAllTaskLabel', () {
      final tLabels = [TestEntities.tLabelEntity];

      blocTest<LabelBloc, LabelState>(
        'emits [processing, success, idle] when getAllTaskLabel succeeds',
        build: () {
          //! Arrange
          when(
            () => mockGetAllTaskLabelUseCase(any()),
          ).thenAnswer((_) async => Right(tLabels));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const LabelEvent.getAllTaskLabel()),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.processing,
            mutationState: ViewState.idle,
            labels: [],
          ),
          LabelState.initial(
            viewState: ViewState.success,
            mutationState: ViewState.idle,
            labels: tLabels,
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: tLabels,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllTaskLabelUseCase(const NoParams())).called(1);
          verify(() => mockSaveAllTaskLabelToStorageUseCase(tLabels)).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'emits [processing, error, idle] and loads from storage when '
        'getAllTaskLabel fails',
        build: () {
          //! Arrange
          when(() => mockGetAllTaskLabelUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Network error'),
            ),
          );
          when(
            () => mockGetAllTaskLabelFromStorageUseCase(any()),
          ).thenAnswer((_) async => Right(tLabels));
          return labelBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const LabelEvent.getAllTaskLabel()),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.processing,
            mutationState: ViewState.idle,
            labels: [],
          ),
          LabelState.initial(
            viewState: ViewState.error,
            mutationState: ViewState.idle,
            labels: tLabels,
            errorMessage: 'Network error',
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: tLabels,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllTaskLabelUseCase(const NoParams())).called(1);
          verify(
            () => mockGetAllTaskLabelFromStorageUseCase(const NoParams()),
          ).called(1);
        },
      );
    });

    group('saveAllTaskLabelToStorage', () {
      final tLabels = [TestEntities.tLabelEntity];

      blocTest<LabelBloc, LabelState>(
        'calls saveAllTaskLabelToStorageUseCase',
        build: () {
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        act: (bloc) => bloc.add(LabelEvent.saveAllTaskLabelToStorage(tLabels)),
        verify: (_) {
          verify(() => mockSaveAllTaskLabelToStorageUseCase(tLabels)).called(1);
        },
      );
    });

    group('createTaskLabel', () {
      const tCreateLabelEntity = CreateTaskLabelEntity(
        id: '123',
        name: 'New Label',
        color: 'sky_blue',
      );
      final tCreatedLabel = TestEntities.tLabelEntity.copyWith(
        id: '123',
        name: 'New Label',
      );

      blocTest<LabelBloc, LabelState>(
        'emits [processing, success, idle] when createTaskLabel succeeds',
        build: () {
          //! Arrange
          when(
            () => mockCreateTaskLabelUseCase(any()),
          ).thenAnswer((_) async => Right(tCreatedLabel));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const LabelEvent.createTaskLabel(tCreateLabelEntity)),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            labels: [tCreatedLabel],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [tCreatedLabel],
          ),
        ],
        verify: (_) {
          verify(
            () => mockCreateTaskLabelUseCase(tCreateLabelEntity),
          ).called(1);
          verify(
            () => mockSaveAllTaskLabelToStorageUseCase([tCreatedLabel]),
          ).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'emits [processing, error, idle] when createTaskLabel fails',
        build: () {
          //! Arrange
          when(() => mockCreateTaskLabelUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Creation failed'),
            ),
          );
          return labelBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const LabelEvent.createTaskLabel(tCreateLabelEntity)),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            labels: [],
            errorMessage: 'Creation failed',
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [],
          ),
        ],
        verify: (_) {
          verify(
            () => mockCreateTaskLabelUseCase(tCreateLabelEntity),
          ).called(1);
        },
      );
    });

    group('updateTaskLabel', () {
      const tExistingLabel = TestEntities.tLabelEntity;
      const tUpdateLabelEntity = CreateTaskLabelEntity(
        id: '2156154810',
        name: 'Updated Label',
      );
      final tUpdatedLabel = tExistingLabel.copyWith(name: 'Updated Label');

      blocTest<LabelBloc, LabelState>(
        'emits [processing, success, idle] when updateTaskLabel succeeds',
        seed: () => const LabelState.initial(labels: [tExistingLabel]),
        build: () {
          //! Arrange
          when(
            () => mockUpdateTaskLabelUseCase(any()),
          ).thenAnswer((_) async => Right(tUpdatedLabel));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const LabelEvent.updateTaskLabel(tUpdateLabelEntity)),
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tExistingLabel],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            labels: [tUpdatedLabel],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [tUpdatedLabel],
          ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateTaskLabelUseCase(tUpdateLabelEntity),
          ).called(1);
          verify(
            () => mockSaveAllTaskLabelToStorageUseCase([tUpdatedLabel]),
          ).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'emits [processing, error, idle] when updateTaskLabel fails',
        seed: () => const LabelState.initial(labels: [tExistingLabel]),
        build: () {
          //! Arrange
          when(() => mockUpdateTaskLabelUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Update failed'),
            ),
          );
          return labelBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const LabelEvent.updateTaskLabel(tUpdateLabelEntity)),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tExistingLabel],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            labels: [tExistingLabel],
            errorMessage: 'Update failed',
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [tExistingLabel],
          ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateTaskLabelUseCase(tUpdateLabelEntity),
          ).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'does not emit new states when mutation already processing',
        seed: () => const LabelState.initial(labels: [tExistingLabel]),
        build: () {
          //! Arrange
          when(
            () => mockUpdateTaskLabelUseCase(any()),
          ).thenAnswer((_) async => Right(tUpdatedLabel));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) {
          bloc
            ..add(const LabelEvent.updateTaskLabel(tUpdateLabelEntity))
            ..add(const LabelEvent.updateTaskLabel(tUpdateLabelEntity));
        },
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tExistingLabel],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            labels: [tUpdatedLabel],
          ),
          LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [tUpdatedLabel],
          ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateTaskLabelUseCase(tUpdateLabelEntity),
          ).called(1);
        },
      );
    });

    group('deleteTaskLabel', () {
      const tLabel = TestEntities.tLabelEntity;
      const tLabelId = '2156154810';

      blocTest<LabelBloc, LabelState>(
        'emits [processing, success, idle] when deleteTaskLabel succeeds',
        seed: () => const LabelState.initial(labels: [tLabel]),
        build: () {
          //! Arrange
          when(
            () => mockDeleteTaskLabelUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const LabelEvent.deleteTaskLabel(tLabelId)),
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tLabel],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            labels: [],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskLabelUseCase(tLabelId)).called(1);
          verify(() => mockSaveAllTaskLabelToStorageUseCase([])).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'emits [processing, error, idle] when deleteTaskLabel fails',
        seed: () => const LabelState.initial(labels: [tLabel]),
        build: () {
          //! Arrange
          when(() => mockDeleteTaskLabelUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Deletion failed'),
            ),
          );
          return labelBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const LabelEvent.deleteTaskLabel(tLabelId)),
        //! Assert
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tLabel],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            labels: [tLabel],
            errorMessage: 'Deletion failed',
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [tLabel],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskLabelUseCase(tLabelId)).called(1);
        },
      );

      blocTest<LabelBloc, LabelState>(
        'does not emit new states when mutation already processing',
        seed: () => const LabelState.initial(labels: [tLabel]),
        build: () {
          //! Arrange
          when(
            () => mockDeleteTaskLabelUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskLabelToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return labelBloc;
        },
        //! Act
        act: (bloc) {
          bloc
            ..add(const LabelEvent.deleteTaskLabel(tLabelId))
            ..add(const LabelEvent.deleteTaskLabel(tLabelId));
        },
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            labels: [tLabel],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            labels: [],
          ),
          const LabelState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            labels: [],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskLabelUseCase(tLabelId)).called(1);
        },
      );
    });
  });
}
