import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/client/task_manager_client.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_remote_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/create_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/get_comments_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/task_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/create_task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/create_task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/get_active_task_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskManagerClient extends Mock implements TaskManagerClient {}

void main() {
  late MockTaskManagerClient mockClient;
  late TaskManagerRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockTaskManagerClient();
    dataSource = TaskManagerRemoteDataSourceImpl(mockClient);
  });

  setUpAll(() {
    // Register fallback values for all custom models used with any()
    registerFallbackValue(
      const CreateTaskModel(content: '', id: '', description: ''),
    );
    registerFallbackValue(
      const CreateTaskLabelModel(name: '', id: ''),
    );
    registerFallbackValue(
      const CreateCommentModel(content: '', id: '', taskId: '', projectId: ''),
    );
    registerFallbackValue(
      const GetActiveTasksFilterModel(),
    );
    registerFallbackValue(
      const GetCommentsFilterModel(projectId: '', taskId: ''),
    );
  });

  group('task manager remote data source ...', () {
    group('task logic ...', () {
      test(
        'get all active task should call client and return list of tasks',
        () async {
          //! Arrange
          const filter = GetActiveTasksFilterEntity(projectId: '1');
          final tTasks = [
            const TaskModel(
              id: '1',
              content: 'task',
              timer: TaskTimerModel(),
              status: TaskStatus.todo,
            ),
          ];
          when(
            () => mockClient.getAllActiveTask(any()),
          ).thenAnswer((_) async => tTasks);

          //! Act
          final result = await dataSource.getAllActiveTask(filter);

          //! Assert
          expect(result, tTasks);
          verify(() => mockClient.getAllActiveTask(any())).called(1);
        },
      );

      test('create task should call client with mapped model', () async {
        //! Arrange
        const request = CreateTaskEntity(
          content: 'new',
          id: '',
          description: '',
        );
        const tResponse = TaskModel(
          id: '1',
          content: 'new',
          timer: TaskTimerModel(),
          status: TaskStatus.todo,
        );
        when(
          () => mockClient.createTask(any()),
        ).thenAnswer((_) async => tResponse);

        //! Act
        final result = await dataSource.createTask(request);

        //! Assert
        expect(result, tResponse);
        verify(() => mockClient.createTask(any())).called(1);
      });

      test('update task should call client with id and mapped model', () async {
        //! Arrange
        const request = CreateTaskEntity(
          id: '1',
          content: 'updated',
          description: '',
        );
        const tResponse = TaskModel(
          id: '1',
          content: 'new',
          timer: TaskTimerModel(),
          status: TaskStatus.todo,
        );
        when(
          () => mockClient.updateTask(any(), any()),
        ).thenAnswer((_) async => tResponse);

        //! Act
        await dataSource.updateTask(request);

        //! Assert
        verify(() => mockClient.updateTask('1', any())).called(1);
      });

      test('delete task should call client with id', () async {
        //! Arrange
        const tId = '1';
        when(() => mockClient.deleteTask(any())).thenAnswer((_) async => {});

        //! Act
        await dataSource.deleteTask(tId);

        //! Assert
        verify(() => mockClient.deleteTask(tId)).called(1);
      });
    });

    group('task label logic ...', () {
      test('get all task label should return list of labels', () async {
        //! Arrange
        final tLabels = [const TaskLabelModel(id: '1', name: 'label')];
        when(
          () => mockClient.getAllTaskLabel(),
        ).thenAnswer((_) async => tLabels);

        //! Act
        final result = await dataSource.getAllTaskLabel();

        //! Assert
        expect(result, tLabels);
        verify(() => mockClient.getAllTaskLabel()).called(1);
      });

      test('create task label should call client with correct model', () async {
        //! Arrange
        const request = CreateTaskLabelEntity(name: 'new label', id: '');
        const tResponse = TaskLabelModel(id: '1', name: 'new label');
        when(
          () => mockClient.createTaskLabel(any()),
        ).thenAnswer((_) async => tResponse);

        //! Act
        await dataSource.createTaskLabel(request);

        //! Assert
        verify(() => mockClient.createTaskLabel(any())).called(1);
      });
    });

    group('task comment logic ...', () {
      test('get all task comment should call client with filter', () async {
        //! Arrange
        const filter = GetCommentsFilterEntity(taskId: '1', projectId: '');
        final tComments = [const TaskCommentModel(id: '1', content: 'comment')];
        when(
          () => mockClient.getAllTaskComment(any()),
        ).thenAnswer((_) async => tComments);

        //! Act
        final result = await dataSource.getAllTaskComment(filter);

        //! Assert
        expect(result, tComments);
        verify(() => mockClient.getAllTaskComment(any())).called(1);
      });

      test(
        'update task comment should call client with id and model',
        () async {
          //! Arrange
          const request = CreateCommentEntity(
            id: '1',
            content: 'edited',
            taskId: '',
            projectId: '',
          );
          const tResponse = TaskCommentModel(id: '1', content: 'edited');
          when(
            () => mockClient.updateTaskComment(any(), any()),
          ).thenAnswer((_) async => tResponse);

          //! Act
          await dataSource.updateTaskComment(request);

          //! Assert
          verify(() => mockClient.updateTaskComment('1', any())).called(1);
        },
      );
    });
  });
}
