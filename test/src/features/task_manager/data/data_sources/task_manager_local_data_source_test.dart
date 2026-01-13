import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/constants/pref_keys.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/data_sources/task_manager_local_data_source.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/services/local_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late MockLocalStorageService mockStorage;
  late TaskManagerLocalDataSourceImpl dataSource;

  setUp(() {
    mockStorage = MockLocalStorageService();
    dataSource = TaskManagerLocalDataSourceImpl(mockStorage);
  });

  group('task manager local data source ...', () {
    group('get all active task from storage ...', () {
      test('should return empty list when no data exists in storage', () async {
        //! Arrange
        when(
          () => mockStorage.getPreference(key: PrefKeys.tasks),
        ).thenReturn(null);

        //! Act
        final result = await dataSource.getAllActiveTaskFromStorage();

        //! Assert
        expect(result, isEmpty);
        verify(() => mockStorage.getPreference(key: PrefKeys.tasks)).called(1);
      });

      test('should return list of tasks when data exists', () async {
        //! Arrange
        final tasksJson = [
          {
            'id': '1',
            'content': 'task 1',
            'timer': {'is_running': false},
          },
        ];
        when(
          () => mockStorage.getPreference(key: PrefKeys.tasks),
        ).thenReturn(jsonEncode(tasksJson));

        //! Act
        final result = await dataSource.getAllActiveTaskFromStorage();

        //! Assert
        expect(result.length, 1);
        expect(result.first.id, '1');
      });
    });

    group('save all task to storage ...', () {
      test('should call save preference with correct key and data', () async {
        //! Arrange
        final tasks = [
          const TaskModel(
            id: '1',
            content: 'test',
            timer: TaskTimerModel(),
            status: TaskStatus.todo,
          ),
        ];
        when(
          () => mockStorage.savePreference(
            key: any(named: 'key'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => {});

        //! Act
        await dataSource.saveAllTaskToStorage(tasks);

        //! Assert
        verify(
          () => mockStorage.savePreference(
            key: PrefKeys.tasks,
            data: any(named: 'data', that: contains('test')),
          ),
        ).called(1);
      });
    });

    group('get all task comment from storage ...', () {
      test('should use dynamic task id in key for fetching comments', () async {
        //! Arrange
        const taskId = 'abc';
        const expectedKey = '${PrefKeys.comments}_$taskId';
        when(
          () => mockStorage.getPreference(key: expectedKey),
        ).thenReturn(null);

        //! Act
        await dataSource.getAllTaskCommentFromStorage(taskId);

        //! Assert
        verify(() => mockStorage.getPreference(key: expectedKey)).called(1);
      });
    });

    group('save all task comment to storage ...', () {
      test('should save comments using task id in the key', () async {
        //! Arrange
        const taskId = 'abc';
        const expectedKey = '${PrefKeys.comments}_$taskId';
        when(
          () => mockStorage.savePreference(
            key: any(named: 'key'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => {});

        //! Act
        await dataSource.saveAllTaskCommentToStorage(
          taskComment: [],
          taskID: taskId,
        );

        //! Assert
        verify(
          () => mockStorage.savePreference(
            key: expectedKey,
            data: any(named: 'data'),
          ),
        ).called(1);
      });
    });

    group('task label logic ...', () {
      test('should return empty list when labels preference is null', () async {
        //! Arrange
        when(
          () => mockStorage.getPreference(key: PrefKeys.labels),
        ).thenReturn(null);

        //! Act
        final result = await dataSource.getAllTaskLabelFromStorage();

        //! Assert
        expect(result, isEmpty);
      });
    });
  });
}
