// ignore_for_file: avoid_redundant_argument_values, document_ignores

import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_comment_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/comment/comment_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../helpers/test_entities.dart';

// Mock use cases
class MockGetAllTaskCommentUseCase extends Mock
    implements GetAllTaskCommentUseCase {}

class MockGetAllTaskCommentFromStorageUseCase extends Mock
    implements GetAllTaskCommentFromStorageUseCase {}

class MockSaveAllTaskCommentToStorageUseCase extends Mock
    implements SaveAllTaskCommentToStorageUseCase {}

class MockCreateTaskCommentUseCase extends Mock
    implements CreateTaskCommentUseCase {}

class MockUpdateTaskCommentUseCase extends Mock
    implements UpdateTaskCommentUseCase {}

class MockDeleteTaskCommentUseCase extends Mock
    implements DeleteTaskCommentUseCase {}

void main() {
  late CommentBloc commentBloc;
  late MockGetAllTaskCommentUseCase mockGetAllTaskCommentUseCase;
  late MockGetAllTaskCommentFromStorageUseCase
  mockGetAllTaskCommentFromStorageUseCase;
  late MockSaveAllTaskCommentToStorageUseCase
  mockSaveAllTaskCommentToStorageUseCase;
  late MockCreateTaskCommentUseCase mockCreateTaskCommentUseCase;
  late MockUpdateTaskCommentUseCase mockUpdateTaskCommentUseCase;
  late MockDeleteTaskCommentUseCase mockDeleteTaskCommentUseCase;

  setUp(() {
    mockGetAllTaskCommentUseCase = MockGetAllTaskCommentUseCase();
    mockGetAllTaskCommentFromStorageUseCase =
        MockGetAllTaskCommentFromStorageUseCase();
    mockSaveAllTaskCommentToStorageUseCase =
        MockSaveAllTaskCommentToStorageUseCase();
    mockCreateTaskCommentUseCase = MockCreateTaskCommentUseCase();
    mockUpdateTaskCommentUseCase = MockUpdateTaskCommentUseCase();
    mockDeleteTaskCommentUseCase = MockDeleteTaskCommentUseCase();

    commentBloc = CommentBloc(
      getAllTaskCommentUseCase: mockGetAllTaskCommentUseCase,
      getAllTaskCommentFromStorageUseCase:
          mockGetAllTaskCommentFromStorageUseCase,
      saveAllTaskCommentToStorageUseCase:
          mockSaveAllTaskCommentToStorageUseCase,
      createTaskCommentUseCase: mockCreateTaskCommentUseCase,
      updateTaskCommentUseCase: mockUpdateTaskCommentUseCase,
      deleteTaskCommentUseCase: mockDeleteTaskCommentUseCase,
    );

    // Register fallback values
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const GetCommentsFilterEntity(
        projectId: '',
        taskId: '',
      ),
    );
    registerFallbackValue(<TaskCommentEntity>[]);
    registerFallbackValue(
      const CreateCommentEntity(
        id: '',
        taskId: '',
        projectId: '',
        content: '',
      ),
    );
  });

  tearDown(() async {
    await commentBloc.close();
  });

  group('CommentBloc', () {
    test('initial state is correct', () {
      expect(
        commentBloc.state,
        const CommentState.initial(
          viewState: ViewState.idle,
          mutationState: ViewState.idle,
          comments: [],
          errorMessage: null,
        ),
      );
    });

    group('getAllTaskComment', () {
      const tFilterEntity = GetCommentsFilterEntity(
        projectId: '123',
        taskId: '456',
      );
      final tComments = [TestEntities.tCommentEntity];

      blocTest<CommentBloc, CommentState>(
        'emits [processing, error, idle] and loads from storage when '
        'getAllTaskComment fails',
        build: () {
          //! Arrange
          when(() => mockGetAllTaskCommentUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Network error'),
            ),
          );
          when(
            () => mockGetAllTaskCommentFromStorageUseCase(any()),
          ).thenAnswer((_) async => Right(tComments));
          return commentBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const CommentEvent.getAllTaskComment(tFilterEntity)),
        //! Assert
        expect: () => [
          const CommentState.initial(
            viewState: ViewState.processing,
            mutationState: ViewState.idle,
            comments: [],
          ),
          CommentState.initial(
            viewState: ViewState.error,
            mutationState: ViewState.idle,
            comments: tComments,
            errorMessage: 'Network error',
          ),
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            comments: tComments,
          ),
        ],
        verify: (_) {
          verify(() => mockGetAllTaskCommentUseCase(tFilterEntity)).called(1);
          verify(
            () => mockGetAllTaskCommentFromStorageUseCase(tFilterEntity.taskId),
          ).called(1);
        },
      );
    });

    group('createTaskComment', () {
      const tCreateCommentEntity = CreateCommentEntity(
        id: '123',
        taskId: '456',
        projectId: '789',
        content: 'New Comment',
      );

      blocTest<CommentBloc, CommentState>(
        'emits [processing, error, idle] when createTaskComment fails',
        build: () {
          //! Arrange
          when(() => mockCreateTaskCommentUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Creation failed'),
            ),
          );
          return commentBloc;
        },
        //! Act
        act: (bloc) => bloc.add(
          const CommentEvent.createTaskComment(tCreateCommentEntity),
        ),
        //! Assert
        expect: () => [
          const CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            comments: [],
          ),
          const CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            comments: [],
            errorMessage: 'Creation failed',
          ),
          const CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            comments: [],
          ),
        ],
        verify: (_) {
          verify(
            () => mockCreateTaskCommentUseCase(tCreateCommentEntity),
          ).called(1);
        },
      );
    });

    group('updateTaskComment', () {
      final tExistingComment = TestEntities.tCommentEntity;
      const tUpdateCommentEntity = CreateCommentEntity(
        id: '2992679862',
        taskId: '2995104339',
        projectId: '2992679862',
        content: 'Updated Comment',
      );

      blocTest<CommentBloc, CommentState>(
        'emits [processing, error, idle] when updateTaskComment fails',
        seed: () => CommentState.initial(comments: [tExistingComment]),
        build: () {
          //! Arrange
          when(() => mockUpdateTaskCommentUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Update failed'),
            ),
          );
          return commentBloc;
        },
        //! Act
        act: (bloc) => bloc.add(
          const CommentEvent.updateTaskComment(tUpdateCommentEntity),
        ),
        //! Assert
        expect: () => [
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            comments: [tExistingComment],
          ),
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            comments: [tExistingComment],
            errorMessage: 'Update failed',
          ),
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            comments: [tExistingComment],
          ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateTaskCommentUseCase(tUpdateCommentEntity),
          ).called(1);
        },
      );
    });

    group('deleteTaskComment', () {
      final tComment = TestEntities.tCommentEntity;
      const tCommentId = '2992679862';

      blocTest<CommentBloc, CommentState>(
        'emits [processing, error, idle] when deleteTaskComment fails',
        seed: () => CommentState.initial(comments: [tComment]),
        build: () {
          //! Arrange
          when(() => mockDeleteTaskCommentUseCase(any())).thenAnswer(
            (_) async => const Left(
              ServerFailure(message: 'Deletion failed'),
            ),
          );
          return commentBloc;
        },
        //! Act
        act: (bloc) =>
            bloc.add(const CommentEvent.deleteTaskComment(tCommentId)),
        //! Assert
        expect: () => [
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.processing,
            comments: [tComment],
          ),
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.error,
            comments: [tComment],
            errorMessage: 'Deletion failed',
          ),
          CommentState.initial(
            viewState: ViewState.idle,
            mutationState: ViewState.idle,
            comments: [tComment],
          ),
        ],
        verify: (_) {
          verify(() => mockDeleteTaskCommentUseCase(tCommentId)).called(1);
        },
      );
    });
  });
}
