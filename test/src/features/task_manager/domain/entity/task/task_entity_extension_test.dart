// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';

void main() {
  group('task entity extension ...', () {
    const tTaskTimer = TaskTimer();

    const tTask = TaskEntity(
      id: '1',
      content: 'test task',
      timer: tTaskTimer,
      status: TaskStatus.todo,
    );

    test(
      '[startTimer] should update [isRunning] to true and set starttime',
      () {
        //! act
        final result = tTask.startTimer();

        //! assert
        expect(result.timer.isRunning, true);
        expect(result.timer.startTime, isNotNull);
      },
    );

    test(
      '[stopTimer] should calculate elapsed time and update [totalSecondsCompleted]',
      () async {
        //! arrange
        final startTime = DateTime.now().subtract(const Duration(seconds: 5));
        final taskWithTimer = tTask.copyWith(
          timer: tTaskTimer.copyWith(
            isRunning: true,
            startTime: startTime,
            totalSecondsCompleted: 10,
          ),
        );

        //! act
        final result = taskWithTimer.stopTimer();

        //! assert
        expect(result.timer.isRunning, false);
        expect(result.timer.stopTime, isNotNull);
        // Expected: 10 (previous) + 5 (elapsed) = 15
        // Using greaterThanOrEqualTo to account for execution time
        expect(result.timer.totalSecondsCompleted, greaterThanOrEqualTo(15));
      },
    );

    test('[stopTimer] should return same instance if timer is not running', () {
      //! arrange
      const taskNotRunning = tTask;

      //! act
      final result = taskNotRunning.stopTimer();

      //! assert
      expect(result, same(taskNotRunning));
    });

    test(
      '[currentTotalSeconds] should return accumulated time plus active session',
      () {
        //! arrange
        final startTime = DateTime.now().subtract(const Duration(seconds: 10));
        final taskWithActiveTimer = tTask.copyWith(
          timer: tTaskTimer.copyWith(
            isRunning: true,
            startTime: startTime,
            totalSecondsCompleted: 100,
          ),
        );

        //! act
        final total = taskWithActiveTimer.currentTotalSeconds;

        //! assert
        // Expected: 100 + 10 = 110
        expect(total, greaterThanOrEqualTo(110));
      },
    );

    test(
      '[currentTotalSeconds] should return only completed seconds if not running',
      () {
        //! arrange
        final taskStopped = tTask.copyWith(
          timer: tTaskTimer.copyWith(
            isRunning: false,
            totalSecondsCompleted: 50,
          ),
        );

        //! act
        final total = taskStopped.currentTotalSeconds;

        //! assert
        expect(total, 50);
      },
    );
  });
}
