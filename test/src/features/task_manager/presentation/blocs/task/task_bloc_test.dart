// ignore_for_file: avoid_redundant_argument_values, document_ignores

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/close_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/reopen_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/test_entities.dart';

// Mock use cases
class MockGetAllActiveTaskUseCase extends Mock
    implements GetAllActiveTaskUseCase {}

class MockGetAllActiveTaskFromStorageUseCase extends Mock
    implements GetAllActiveTaskFromStorageUseCase {}

class MockSaveAllTaskToStorageUseCase extends Mock
    implements SaveAllTaskToStorageUseCase {}

class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}

class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}

class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class MockCloseTaskUseCase extends Mock implements CloseTaskUseCase {}

class MockReopenTaskUseCase extends Mock implements ReopenTaskUseCase {}

void main() {
  late TaskBloc taskBloc;
  late MockGetAllActiveTaskUseCase mockGetAllActiveTaskUseCase;
  late MockGetAllActiveTaskFromStorageUseCase
  mockGetAllActiveTaskFromStorageUseCase;
  late MockSaveAllTaskToStorageUseCase mockSaveAllTaskToStorageUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockCloseTaskUseCase mockCloseTaskUseCase;
  late MockReopenTaskUseCase mockReopenTaskUseCase;

  setUp(() {
    mockGetAllActiveTaskUseCase = MockGetAllActiveTaskUseCase();
    mockGetAllActiveTaskFromStorageUseCase =
        MockGetAllActiveTaskFromStorageUseCase();
    mockSaveAllTaskToStorageUseCase = MockSaveAllTaskToStorageUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockCloseTaskUseCase = MockCloseTaskUseCase();
    mockReopenTaskUseCase = MockReopenTaskUseCase();

    taskBloc = TaskBloc(
      getAllActiveTaskUseCase: mockGetAllActiveTaskUseCase,
      getAllActiveTaskFromStorageUseCase:
          mockGetAllActiveTaskFromStorageUseCase,
      saveAllTaskToStorageUseCase: mockSaveAllTaskToStorageUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteUseCase: mockDeleteTaskUseCase,
      closeTaskUseCase: mockCloseTaskUseCase,
      reopenTaskUseCase: mockReopenTaskUseCase,
    );

    // Register fallback values
    registerFallbackValue(const NoParams());
    registerFallbackValue(const GetActiveTasksFilterEntity());
    registerFallbackValue(<TaskEntity>[]);
    registerFallbackValue(
      const CreateTaskEntity(
        id: '',
        content: '',
        projectId: '',
        description: '',
      ),
    );
  });

  tearDown(() async {
    await taskBloc.close();
  });

  group('TaskBloc', () {
    test('initial state is correct', () {
      expect(
        taskBloc.state,
        const TaskState.initial(
          viewState: ViewState.idle,
          mutationState: ViewState.idle,
          tasks: [],
          errorMessage: null,
        ),
      );
    });

    group('getAllActiveTask', () {
      const tFilterEntity = GetActiveTasksFilterEntity();
      final tTasks = [TestEntities.tTaskEntity];

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when getAllActiveTask succeeds',
        build: () {
          //! Arrange
          when(
            () => mockGetAllActiveTaskUseCase(any()),
          ).thenAnswer((_) async => Right(tTasks));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const TaskEvent.getAllActiveTask(tFilterEntity)),
        //! Assert
        expect: () => [
          const TaskState.initial(
            viewState: ViewState.processing,
            mutationState: ViewState.idle,
            tasks: [],
          ),
          TaskState.initial(
            viewState: ViewState.success,
            mutationState: ViewState.idle,
            tasks: tTasks,
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: tTasks,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllActiveTaskUseCase(tFilterEntity)).called(1);
          verify(() => mockSaveAllTaskToStorageUseCase(tTasks)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [processing, error, idle] and loads from storage when '
        'getAllActiveTask fails',
        build: () {
          //! Arrange
          when(() => mockGetAllActiveTaskUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Network error'),
            ),
          );
          when(
            () => mockGetAllActiveTaskFromStorageUseCase(any()),
          ).thenAnswer((_) async => Right(tTasks));
          return taskBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const TaskEvent.getAllActiveTask(tFilterEntity)),
        //! Assert
        expect: () => [
          const TaskState.initial(
            viewState: ViewState.processing,
            mutationState: ViewState.idle,
            tasks: [],
          ),
          TaskState.initial(
            viewState: ViewState.error,
            mutationState: ViewState.idle,
            tasks: tTasks,
            errorMessage: 'Network error',
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: tTasks,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllActiveTaskUseCase(tFilterEntity)).called(1);
          verify(
            () => mockGetAllActiveTaskFromStorageUseCase(const NoParams()),
          ).called(1);
        },
      );
    });

    group('saveAllTaskToStorage', () {
      final tTasks = [TestEntities.tTaskEntity];

      blocTest<TaskBloc, TaskState>(
        'calls saveAllTaskToStorageUseCase',
        build: () {
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        act: (bloc) => bloc.add(TaskEvent.saveAllTaskToStorage(tTasks)),
        verify: (_) {
          verify(() => mockSaveAllTaskToStorageUseCase(tTasks)).called(1);
        },
      );
    });

    group('createTask', () {
      const tCreateTaskEntity = CreateTaskEntity(
        id: '123',
        content: 'New Task',
        projectId: '456',
        description: '',
      );
      final tCreatedTask = TestEntities.tTaskEntity.copyWith(
        id: '123',
        content: 'New Task',
      );

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when createTask succeeds',
        build: () {
          //! Arrange
          when(
            () => mockCreateTaskUseCase(any()),
          ).thenAnswer((_) async => Right(tCreatedTask));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.createTask(tCreateTaskEntity)),
        //! Assert
        expect: () => [
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            tasks: [tCreatedTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [tCreatedTask],
          ),
        ],
        verify: (_) {
          verify(() => mockCreateTaskUseCase(tCreateTaskEntity)).called(1);
          verify(
            () => mockSaveAllTaskToStorageUseCase([tCreatedTask]),
          ).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [processing, error, idle] when createTask fails',
        build: () {
          //! Arrange
          when(() => mockCreateTaskUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Creation failed'),
            ),
          );
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.createTask(tCreateTaskEntity)),
        //! Assert
        expect: () => [
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [],
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            tasks: [],
            errorMessage: 'Creation failed',
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [],
          ),
        ],
        verify: (_) {
          verify(() => mockCreateTaskUseCase(tCreateTaskEntity)).called(1);
        },
      );
    });

    group('updateTask', () {
      final tExistingTask = TestEntities.tTaskEntity;
      final tUpdateTaskEntity = CreateTaskEntity(
        id: tExistingTask.id!,
        content: 'Updated Task',
        projectId: tExistingTask.projectId,
        description: '',
      );
      final tUpdatedTask = tExistingTask.copyWith(content: 'Updated Task');

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when updateTask succeeds',
        seed: () => TaskState.initial(tasks: [tExistingTask]),
        build: () {
          //! Arrange
          when(
            () => mockUpdateTaskUseCase(any()),
          ).thenAnswer((_) async => Right(tUpdatedTask));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(TaskEvent.updateTask(tUpdateTaskEntity)),
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tExistingTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            tasks: [tUpdatedTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [tUpdatedTask],
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateTaskUseCase(tUpdateTaskEntity)).called(1);
          verify(
            () => mockSaveAllTaskToStorageUseCase([tUpdatedTask]),
          ).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [processing, error, idle] when updateTask fails',
        seed: () => TaskState.initial(tasks: [tExistingTask]),
        build: () {
          //! Arrange
          when(() => mockUpdateTaskUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Update failed'),
            ),
          );
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(TaskEvent.updateTask(tUpdateTaskEntity)),
        //! Assert
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tExistingTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            tasks: [tExistingTask],
            errorMessage: 'Update failed',
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [tExistingTask],
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateTaskUseCase(tUpdateTaskEntity)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'does not emit new states when mutation already processing',
        seed: () => TaskState.initial(tasks: [tExistingTask]),
        build: () {
          //! Arrange
          when(
            () => mockUpdateTaskUseCase(any()),
          ).thenAnswer((_) async => Right(tUpdatedTask));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) {
          bloc
            ..add(TaskEvent.updateTask(tUpdateTaskEntity))
            ..add(TaskEvent.updateTask(tUpdateTaskEntity));
        },
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tExistingTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            tasks: [tUpdatedTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [tUpdatedTask],
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateTaskUseCase(tUpdateTaskEntity)).called(1);
        },
      );
    });

    group('deleteTask', () {
      final tTask = TestEntities.tTaskEntity;
      const tTaskId = '2995104339';

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when deleteTask succeeds',
        seed: () => TaskState.initial(tasks: [tTask]),
        build: () {
          //! Arrange
          when(
            () => mockDeleteTaskUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.deleteTask(tTaskId)),
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tTask],
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            tasks: [],
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskUseCase(tTaskId)).called(1);
          verify(() => mockSaveAllTaskToStorageUseCase([])).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [processing, error, idle] when deleteTask fails',
        seed: () => TaskState.initial(tasks: [tTask]),
        build: () {
          //! Arrange
          when(() => mockDeleteTaskUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Deletion failed'),
            ),
          );
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.deleteTask(tTaskId)),
        //! Assert
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tTask],
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            tasks: [tTask],
            errorMessage: 'Deletion failed',
          ),
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [tTask],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskUseCase(tTaskId)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'does not emit new states when mutation already processing',
        seed: () => TaskState.initial(tasks: [tTask]),
        build: () {
          //! Arrange
          when(
            () => mockDeleteTaskUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) {
          bloc
            ..add(const TaskEvent.deleteTask(tTaskId))
            ..add(const TaskEvent.deleteTask(tTaskId));
        },
        //! Assert
        wait: const Duration(milliseconds: 500),
        expect: () => [
          TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            tasks: [tTask],
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.success,
            tasks: [],
          ),
          const TaskState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            tasks: [],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskUseCase(tTaskId)).called(1);
        },
      );
    });

    group('closeTask', () {
      final tTask = TestEntities.tTaskEntity;
      const tTaskId = '2995104339';

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when closeTask succeeds',
        seed: () => TaskState.initial(tasks: [tTask]),
        build: () {
          //! Arrange
          when(
            () => mockCloseTaskUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.closeTask(tTaskId)),
        //! Assert
        verify: (_) {
          verify(() => mockCloseTaskUseCase(tTaskId)).called(1);
        },
      );
    });

    group('reopenTask', () {
      final tTask = TestEntities.tTaskEntity.copyWith(isCompleted: true);
      const tTaskId = '2995104339';

      blocTest<TaskBloc, TaskState>(
        'emits [processing, success, idle] when reopenTask succeeds',
        seed: () => TaskState.initial(tasks: [tTask]),
        build: () {
          //! Arrange
          when(
            () => mockReopenTaskUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          when(
            () => mockSaveAllTaskToStorageUseCase(any()),
          ).thenAnswer((_) async => const Right(null));
          return taskBloc;
        },
        //! Act
        act: (bloc) => bloc.add(const TaskEvent.reopenTask(tTaskId)),
        //! Assert
        verify: (_) {
          verify(() => mockReopenTaskUseCase(tTaskId)).called(1);
        },
      );
    });
  });
}
