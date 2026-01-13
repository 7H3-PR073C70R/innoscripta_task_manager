import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';

void main() {
  group('create task entity ...', () {
    test('should support value equality', () {
      //! arrange
      final date = DateTime(2024);
      final entityA = CreateTaskEntity(
        content: 'buy milk',
        description: 'low fat',
        labels: const ['groceries'],
        dueDate: date,
      );

      final entityB = CreateTaskEntity(
        content: 'buy milk',
        description: 'low fat',
        labels: const ['groceries'],
        dueDate: date,
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = CreateTaskEntity(
        content: 'old content',
        description: 'old description',
        priority: 1,
      );

      //! act
      final updated = entity.copyWith(
        content: 'new content',
        priority: 4,
      );

      //! assert
      expect(updated.content, 'new content');
      expect(updated.description, 'old description');
      expect(updated.priority, 4);
      expect(updated, isNot(equals(entity)));
    });

    test('should support nested equality for list of labels', () {
      //! arrange
      const entity1 = CreateTaskEntity(
        content: 'task',
        description: 'desc',
        labels: ['label1', 'label2'],
      );

      const entity2 = CreateTaskEntity(
        content: 'task',
        description: 'desc',
        labels: ['label1', 'label2'],
      );

      //! assert
      expect(entity1, equals(entity2));
    });

    test('props should contain all fields', () {
      //! arrange
      final date = DateTime(2024);
      final entity = CreateTaskEntity(
        content: 'content',
        description: 'description',
        order: 1,
        priority: 2,
        dueDate: date,
        duration: 30,
        durationUnit: 'minute',
      );

      //! assert
      expect(
        entity.props,
        containsAll([
          'content',
          'description',
          1,
          2,
          date,
          30,
          'minute',
        ]),
      );
    });
  });
}
