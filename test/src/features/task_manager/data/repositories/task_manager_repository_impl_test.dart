import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/error/failure.dart';
import 'package:innoscripta_task_manager/src/core/utils/either.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_local_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_remote_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/repositories/task_manager_repository_impl.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskManagerLocalDataSource extends Mock
    implements TaskManagerLocalDataSource {}

class MockTaskManagerRemoteDataSource extends Mock
    implements TaskManagerRemoteDataSource {}

void main() {
  late MockTaskManagerLocalDataSource mockLocal;
  late MockTaskManagerRemoteDataSource mockRemote;
  late TaskManagerRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const GetActiveTasksFilterEntity());
    registerFallbackValue(
      const CreateTaskEntity(content: '', id: '', description: ''),
    );
    registerFallbackValue(const CreateTaskLabelEntity(name: '', id: ''));
    registerFallbackValue(
      const GetCommentsFilterEntity(taskId: '', projectId: ''),
    );
    registerFallbackValue(
      const CreateCommentEntity(content: '', taskId: '', projectId: '', id: ''),
    );
  });

  setUp(() {
    mockLocal = MockTaskManagerLocalDataSource();
    mockRemote = MockTaskManagerRemoteDataSource();
    repository = TaskManagerRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
    );
  });

  group('task manager repository impl ...', () {
    group('task methods ...', () {
      test(
        'get all active task should return hydrated tasks from isolate ...',
        () async {
          //! Arrange
          final remoteTasks = [
            const TaskEntity(
              id: '1',
              content: 'remote',
              status: TaskStatus.todo,
              timer: TaskTimer(),
            ),
          ];
          final localTasks = [
            const TaskEntity(
              id: '1',
              content: 'local',
              status: TaskStatus.todo,
              timer: TaskTimer(),
            ),
          ];

          when(
            () => mockRemote.getAllActiveTask(any()),
          ).thenAnswer((_) async => List.from(remoteTasks));
          when(
            () => mockLocal.getAllActiveTaskFromStorage(),
          ).thenAnswer((_) async => localTasks);

          //! Act
          final result = await repository.getAllActiveTask(
            const GetActiveTasksFilterEntity(),
          );

          //! Assert
          result.fold(
            (l) => fail('Should be Right'),
            (r) {
              expect(r.first.status, TaskStatus.todo);
              expect(r.first.timer.isRunning, false);
            },
          );
        },
      );

      test('create task should call remote data source ...', () async {
        //! Arrange
        const entity = TaskEntity(
          id: '1',
          content: 'new',
          status: TaskStatus.todo,
          timer: TaskTimer(),
        );
        when(
          () => mockRemote.createTask(any()),
        ).thenAnswer((_) async => entity);

        //! Act
        final result = await repository.createTask(
          const CreateTaskEntity(
            content: 'new',
            id: '',
            description: '',
          ),
        );

        //! Assert
        expect(result, const Right<Failure, TaskEntity>(entity));
      });

      test('update task should call remote data source ...', () async {
        //! Arrange
        const entity = TaskEntity(
          id: '1',
          content: 'updated',
          status: TaskStatus.todo,
          timer: TaskTimer(),
        );
        when(
          () => mockRemote.updateTask(any()),
        ).thenAnswer((_) async => entity);

        //! Act
        final result = await repository.updateTask(
          const CreateTaskEntity(id: '1', content: 'updated', description: ''),
        );

        //! Assert
        expect(result, const Right<Failure, TaskEntity>(entity));
      });

      test('delete task should call remote data source ...', () async {
        //! Arrange
        when(
          () => mockRemote.deleteTask(any()),
        ).thenAnswer((_) async => Future.value());

        //! Act
        final result = await repository.deleteTask('1');

        //! Assert
        expect(result, const Right<Failure, void>(null));
      });
    });

    group('task label methods ...', () {
      //! Arrange
      test('get all task label should call remote data source ...', () async {
        final labels = [const TaskLabelEntity(id: '1', name: 'label')];
        when(
          () => mockRemote.getAllTaskLabel(),
        ).thenAnswer((_) async => labels);

        //! Act
        final result = await repository.getAllTaskLabel();

        //! Assert
        expect(result, Right<Failure, List<TaskLabelEntity>>(labels));
      });

      test('create task label should call remote data source ...', () async {
        //! Arrange
        const label = TaskLabelEntity(id: '1', name: 'label');
        when(
          () => mockRemote.createTaskLabel(any()),
        ).thenAnswer((_) async => label);

        //! Act
        final result = await repository.createTaskLabel(
          const CreateTaskLabelEntity(name: 'label', id: ''),
        );

        //! Assert
        expect(result, const Right<Failure, TaskLabelEntity>(label));
      });

      test('update task label should call remote data source ...', () async {
        //! Arrange
        const label = TaskLabelEntity(id: '1', name: 'label');
        when(
          () => mockRemote.updateTaskLabel(any()),
        ).thenAnswer((_) async => label);

        //! Act
        final result = await repository.updateTaskLabel(
          const CreateTaskLabelEntity(id: '1', name: 'label'),
        );

        //! Assert
        expect(result, const Right<Failure, TaskLabelEntity>(label));
      });

      test('delete task label should call remote data source ...', () async {
        //! Arrange
        when(
          () => mockRemote.deleteTaskLabel(any()),
        ).thenAnswer((_) async => Future.value());

        //! Act
        final result = await repository.deleteTaskLabel('1');

        //! Assert
        expect(result, const Right<Failure, void>(null));
      });
    });

    group('task comment methods ...', () {
      test('get all task comment should call remote data source ...', () async {
        //! Arrange
        final comments = [const TaskCommentEntity(id: '1', content: 'comm')];
        when(
          () => mockRemote.getAllTaskComment(any()),
        ).thenAnswer((_) async => comments);

        //! Act
        final result = await repository.getAllTaskComment(
          const GetCommentsFilterEntity(taskId: '1', projectId: ''),
        );

        //! Assert
        expect(result, Right<Failure, List<TaskCommentEntity>>(comments));
      });

      test('create task comment should call remote data source ...', () async {
        //! Arrange
        const comment = TaskCommentEntity(id: '1', content: 'comm');
        when(
          () => mockRemote.createTaskComment(any()),
        ).thenAnswer((_) async => comment);

        //! Act
        final result = await repository.createTaskComment(
          const CreateCommentEntity(
            content: 'comm',
            taskId: '',
            projectId: '',
            id: '',
          ),
        );

        //! Assert
        expect(result, const Right<Failure, TaskCommentEntity>(comment));
      });

      test('update task comment should call remote data source ...', () async {
        //! Arrange
        const comment = TaskCommentEntity(id: '1', content: 'comm');
        when(
          () => mockRemote.updateTaskComment(any()),
        ).thenAnswer((_) async => comment);

        //! Act
        final result = await repository.updateTaskComment(
          const CreateCommentEntity(
            id: '1',
            content: 'comm',
            taskId: '',
            projectId: '',
          ),
        );

        //! Assert
        expect(result, const Right<Failure, TaskCommentEntity>(comment));
      });

      test('delete task comment should call remote data source ...', () async {
        //! Arrange
        when(
          () => mockRemote.deleteTaskComment(any()),
        ).thenAnswer((_) async => Future.value());

        //! Act
        final result = await repository.deleteTaskComment('1');

        //! Assert
        expect(result, const Right<Failure, void>(null));
      });
    });

    group('local storage methods ...', () {
      test(
        'get all active task from storage should call local source ...',
        () async {
          //! Arrange
          final tasks = [
            const TaskEntity(
              id: '1',
              content: 'local',
              status: TaskStatus.todo,
              timer: TaskTimer(),
            ),
          ];
          when(
            () => mockLocal.getAllActiveTaskFromStorage(),
          ).thenAnswer((_) async => tasks);

          //! Act
          final result = await repository.getAllActiveTaskFromStorage();

          //! Assert
          expect(result, Right<Failure, List<TaskEntity>>(tasks));
        },
      );

      test('save all task to storage should call local source ...', () async {
        //! Arrange
        when(
          () => mockLocal.saveAllTaskToStorage(any()),
        ).thenAnswer((_) async => Future.value());

        //! Act
        final result = await repository.saveAllTaskToStorage([]);

        //! Assert
        expect(result, const Right<Failure, void>(null));
      });

      test(
        'save all task comment to storage should call local source ...',
        () async {
          //! Arrange
          when(
            () => mockLocal.saveAllTaskCommentToStorage(
              taskComment: any(named: 'taskComment'),
              taskID: any(named: 'taskID'),
            ),
          ).thenAnswer((_) async => Future.value());

          //! Act
          final result = await repository.saveAllTaskCommentToStorage(
            taskComment: [],
            taskID: '1',
          );

          //! Assert
          expect(result, const Right<Failure, void>(null));
        },
      );

      test(
        'get all task comment from storage should call local source ...',
        () async {
          //! Arrange
          final comments = [const TaskCommentEntity(id: '1', content: 'local')];
          when(
            () => mockLocal.getAllTaskCommentFromStorage(any()),
          ).thenAnswer((_) async => comments);

          //! Act
          final result = await repository.getAllTaskCommentFromStorage('1');

          //! Assert
          expect(result, Right<Failure, List<TaskCommentEntity>>(comments));
        },
      );

      test(
        'get all task label from storage should call local source ...',
        () async {
          //! Arrange
          final labels = [const TaskLabelEntity(id: '1', name: 'local')];
          when(
            () => mockLocal.getAllTaskLabelFromStorage(),
          ).thenAnswer((_) async => labels);

          //! Act
          final result = await repository.getAllTaskLabelFromStorage();

          //! Assert
          expect(result, Right<Failure, List<TaskLabelEntity>>(labels));
        },
      );

      test(
        'save all task label to storage should call local source ...',
        () async {
          //! Arrange
          when(
            () => mockLocal.saveAllTaskLabelToStorage(any()),
          ).thenAnswer((_) async => Future.value());

          //! Act
          final result = await repository.saveAllTaskLabelToStorage([]);

          //! Assert
          expect(result, const Right<Failure, void>(null));
        },
      );
    });
  });
}
