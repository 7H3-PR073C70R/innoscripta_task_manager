import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/networking/api/app_api_endpoint.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/client/task_manager_client.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/create_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/get_comments_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/create_task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/create_task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/get_active_task_filter_model.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TaskManagerClient client;

  setUpAll(() {
    registerFallbackValue(
      RequestOptions(),
    );
  });

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    client = TaskManagerClient(mockDio);
  });

  group('task manager client - task methods ...', () {
    test('getAllActiveTask should call GET with correct queries', () async {
      //! Arrange
      const request = GetActiveTasksFilterModel(projectId: '123');
      final responsePayload = [
        {'id': 'task_1', 'content': 'Test Task'},
      ];

      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.task),
        ),
      );

      //! Act
      final result = await client.getAllActiveTask(request);

      //! Assert
      expect(result.first.id, 'task_1');
      verify(
        () => mockDio.fetch<List<dynamic>>(
          any(
            that: isA<RequestOptions>()
                .having(
                  (req) => req.method,
                  'method',
                  'GET',
                )
                .having(
                  (req) => req.path,
                  'path',
                  AppApiEndpoint.task,
                ),
          ),
        ),
      ).called(1);
    });

    test('createTask should call POST with body', () async {
      //! Arrange
      const request = CreateTaskModel(
        content: 'New',
        description: 'Desc',
        id: '',
      );
      final responsePayload = {'id': 'new_id', 'content': 'New'};

      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.task),
        ),
      );

      //! Act
      final result = await client.createTask(request);

      //! Assert
      expect(result.id, 'new_id');
      verify(
        () => mockDio.fetch<Map<String, dynamic>>(
          any(
            that: isA<RequestOptions>().having(
              (req) => req.method,
              'method',
              'POST',
            ),
          ),
        ),
      ).called(1);
    });

    test('deleteTask should call DELETE with path parameter', () async {
      //! Arrange
      const taskId = '123';
      when(() => mockDio.fetch<void>(any())).thenAnswer(
        (_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(
            path: '${AppApiEndpoint.task}/$taskId',
          ),
        ),
      );

      //! Act
      await client.deleteTask(taskId);

      //! Assert
      verify(
        () => mockDio.fetch<void>(
          any(
            that: isA<RequestOptions>()
                .having(
                  (req) => req.path,
                  'path',
                  contains(taskId),
                )
                .having(
                  (req) => req.method,
                  'method',
                  'DELETE',
                ),
          ),
        ),
      ).called(1);
    });
  });

  group('task manager client - label methods ...', () {
    test('getAllTaskLabel should call GET with correct path', () async {
      //! Arrange
      final responsePayload = [
        {'id': 'label_1', 'name': 'Urgent'},
      ];
      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.labels),
        ),
      );

      //! Act
      final result = await client.getAllTaskLabel();

      //! Assert
      expect(result.first.id, 'label_1');
      verify(
        () => mockDio.fetch<List<dynamic>>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.method, 'method', 'GET')
                .having((req) => req.path, 'path', AppApiEndpoint.labels),
          ),
        ),
      ).called(1);
    });

    test('createTaskLabel should call POST with body', () async {
      //! Arrange
      const request = CreateTaskLabelModel(name: 'New Label', id: '');
      final responsePayload = {'id': 'label_id', 'name': 'New Label'};
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: responsePayload,
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.labels),
        ),
      );

      //! Act
      final result = await client.createTaskLabel(request);

      //! Assert
      expect(result.id, 'label_id');
      verify(
        () => mockDio.fetch<Map<String, dynamic>>(
          any(
            that: isA<RequestOptions>().having(
              (req) => req.method,
              'method',
              'POST',
            ),
          ),
        ),
      ).called(1);
    });

    test('updateTaskLabel should call POST with ID in path', () async {
      //! Arrange
      const labelId = '456';
      const request = CreateTaskLabelModel(name: 'Updated Name', id: '');
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {'id': labelId},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${AppApiEndpoint.labels}/$labelId',
          ),
        ),
      );

      //! Act
      await client.updateTaskLabel(labelId, request);

      //! Assert
      verify(
        () => mockDio.fetch<Map<String, dynamic>>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.path, 'path', contains(labelId))
                .having((req) => req.method, 'method', 'POST'),
          ),
        ),
      ).called(1);
    });

    test('deleteTaskLabel should call DELETE with ID in path', () async {
      //! Arrange
      const labelId = '456';
      when(() => mockDio.fetch<void>(any())).thenAnswer(
        (_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(
            path: '${AppApiEndpoint.labels}/$labelId',
          ),
        ),
      );

      //! Act
      await client.deleteTaskLabel(labelId);

      //! Assert
      verify(
        () => mockDio.fetch<void>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.path, 'path', contains(labelId))
                .having((req) => req.method, 'method', 'DELETE'),
          ),
        ),
      ).called(1);
    });
  });

  group('task manager client - comment methods ...', () {
    test('getAllTaskComment should call GET with queries', () async {
      //! Arrange
      const request = GetCommentsFilterModel(taskId: '123', projectId: '');
      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.comments),
        ),
      );

      //! Act
      await client.getAllTaskComment(request);

      //! Assert
      verify(
        () => mockDio.fetch<List<dynamic>>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.method, 'method', 'GET')
                .having((req) => req.path, 'path', AppApiEndpoint.comments),
          ),
        ),
      ).called(1);
    });

    test('createTaskComment should call POST with body', () async {
      //! Arrange
      const request = CreateCommentModel(
        taskId: '123',
        content: 'New Comment',
        id: '',
        projectId: '',
      );
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {'id': 'comm_1'},
          statusCode: 200,
          requestOptions: RequestOptions(path: AppApiEndpoint.comments),
        ),
      );

      //! Act
      await client.createTaskComment(request);

      //! Assert
      verify(
        () => mockDio.fetch<Map<String, dynamic>>(
          any(
            that: isA<RequestOptions>().having(
              (req) => req.method,
              'method',
              'POST',
            ),
          ),
        ),
      ).called(1);
    });

    test('updateTaskComment should call POST with ID in path', () async {
      //! Arrange
      const commentId = '789';
      const request = CreateCommentModel(
        content: 'Edited',
        id: '',
        taskId: '',
        projectId: '',
      );
      when(() => mockDio.fetch<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: {'id': commentId},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '${AppApiEndpoint.comments}/$commentId',
          ),
        ),
      );

      //! Act
      await client.updateTaskComment(commentId, request);

      //! Assert
      verify(
        () => mockDio.fetch<Map<String, dynamic>>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.path, 'path', contains(commentId))
                .having((req) => req.method, 'method', 'POST'),
          ),
        ),
      ).called(1);
    });

    test('deleteTaskComment should call DELETE with ID in path', () async {
      //! Arrange
      const commentId = '789';
      when(() => mockDio.fetch<void>(any())).thenAnswer(
        (_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(
            path: '${AppApiEndpoint.comments}/$commentId',
          ),
        ),
      );

      //! Act
      await client.deleteTaskComment(commentId);

      //! Assert
      verify(
        () => mockDio.fetch<void>(
          any(
            that: isA<RequestOptions>()
                .having((req) => req.path, 'path', contains(commentId))
                .having((req) => req.method, 'method', 'DELETE'),
          ),
        ),
      ).called(1);
    });
  });
}
