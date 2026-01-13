// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';

void main() {
  group('task model ...', () {
    final tDate = DateTime(2026, 1, 14, 12);

    final tJson = {
      'id': '1',
      'content': 'task 1',
      'status': 1, // inProgress
      'created_at': tDate.toIso8601String(),
      'timer': {
        'is_running': true,
        'total_seconds_completed': 120,
      },
      'due': {
        'date': '2026-01-14',
        'string': 'today',
      },
      'labels': ['work'],
    };

    const tEntity = TaskEntity(
      id: '1',
      content: 'task 1',
      status: TaskStatus.inProgress,
      timer: TaskTimer(isRunning: true, totalSecondsCompleted: 120),
      labels: ['work'],
    );

    group('from json ...', () {
      test('should return a valid model with all nested objects ...', () {
        //! Act
        final result = TaskModel.fromJson(tJson);

        //! Assert
        expect(result.id, '1');
        expect(result.status, TaskStatus.inProgress);
        expect(result.timer.isRunning, isTrue);
        expect(result.due?.string, 'today');
        expect(result.labels, contains('work'));
      });

      test(
        'should use default timer and todo status when json fields are null ...',
        () {
          //! Act
          final result = TaskModel.fromJson(const {'id': '2'});

          //! Assert
          expect(result.status, TaskStatus.todo);
          expect(result.timer.isRunning, isFalse);
          expect(result.timer.totalSecondsCompleted, 0);
        },
      );
    });

    group('to json ...', () {
      test('should return a json map containing nested model data ...', () {
        //! Arrange
        final model = TaskModel.fromEntity(tEntity);

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result['id'], '1');
        expect(result['status'], 1);
        expect((result['timer'] as Map<String, dynamic>)['is_running'], isTrue);
        expect(result['labels'], contains('work'));
      });
    });

    group('sub-models logic ...', () {
      test('task due model should format date only for date field ...', () {
        final due = TaskDueModel(date: tDate);
        final json = due.toJson();
        expect(json['date'], '2026-01-14');
      });

      test('task timer model should handle null times correctly ...', () {
        const timerJson = {'is_running': false, 'total_seconds_completed': 0};
        final model = TaskTimerModel.fromJson(timerJson);
        expect(model.startTime, isNull);
        expect(model.isRunning, isFalse);
      });

      test('task deadline model to json should strip time ...', () {
        final deadline = TaskDeadlineModel(date: tDate);
        expect(deadline.toJson()['date'], '2026-01-14');
      });

      test('task duration model should map amount and unit ...', () {
        const durationJson = {'amount': 30, 'unit': 'minute'};
        final model = TaskDurationModel.fromJson(durationJson);
        expect(model.amount, 30);
        expect(model.unit, 'minute');
      });
    });
  });
}
