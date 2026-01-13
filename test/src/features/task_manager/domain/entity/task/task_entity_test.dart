import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import '../../../../../../helpers/test_entities.dart';

void main() {
  group('task entity ...', () {
    test('should support value equality', () {
      //! arrange
      final entityA = TestEntities.tTaskEntity;
      final entityB = TaskEntity(
        id: '2995104339',
        content: 'Buy Milk',
        commentCount: 10,
        isCompleted: false,
        createdAt: DateTime.parse('2019-12-11T22:36:50.000000Z'),
        priority: 1,
        order: 1,
        projectId: '2203306141',
        labels: const ['Food', 'Shopping'],
        url: 'https://app.todoist.com/showTask?id=2995104339',
        timer: const TaskTimer(),
      );

      //! assert
      expect(
        entityA,
        equals(entityB),
        reason: 'Checking equality for [entityA]',
      );
    });

    test('[copyWith] should return a new object with updated values', () {
      //! arrange
      final entity = TestEntities.tTaskEntity;

      //! act
      final updated = entity.copyWith(
        content: 'new content',
        isCompleted: true,
      );

      //! assert
      expect(
        updated.content,
        'new content',
        reason: 'Value should be updated via [copyWith]',
      );
      expect(updated.isCompleted, true);
      expect(updated.id, entity.id);
      expect(
        updated,
        isNot(same(entity)),
        reason: 'Should be a new instance of [TaskEntity]',
      );
    });

    test('[copyWith] should correctly update nested timer', () {
      //! arrange
      final entity = TestEntities.tTaskEntity;
      const newTimer = TaskTimer(
        isRunning: true,
        totalSecondsCompleted: 500,
      );

      //! act
      final updated = entity.copyWith(timer: newTimer);

      //! assert
      expect(updated.timer.isRunning, true);
      expect(updated.timer.totalSecondsCompleted, 500);
      expect(
        updated.timer,
        isNot(equals(entity.timer)),
        reason: 'The [timer] property should be updated',
      );
    });

    test('props should contain all significant fields', () {
      //! arrange
      final entity = TestEntities.tTaskEntity;

      //! assert
      expect(
        entity.props,
        containsAll(['2995104339', 'Buy Milk', 10, false]),
        reason: 'The [props] list must include all fields for Equatable',
      );
    });
  });

  group('task timer ...', () {
    test('should support value equality', () {
      //! arrange
      const timerA = TaskTimer();
      final timerB = TestEntities.tTaskEntity.timer;

      //! assert
      expect(
        timerA,
        equals(timerB),
        reason: 'Comparing [timerA] with [timerB]',
      );
    });

    test('[copyWith] should update timer fields correctly', () {
      //! arrange
      final timer = TestEntities.tTaskEntity.timer;

      //! act
      final result = timer.copyWith(
        isRunning: true,
        totalSecondsCompleted: 60,
      );

      //! assert
      expect(result.isRunning, true);
      expect(
        result.totalSecondsCompleted,
        60,
        reason: 'Verifying [totalSecondsCompleted] update',
      );
    });
  });
}
