import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';

void main() {
  group('get comments filter entity ...', () {
    test('should support value equality', () {
      //! arrange
      const entityA = GetCommentsFilterEntity(
        projectId: 'project_123',
        taskId: 'task_456',
      );

      const entityB = GetCommentsFilterEntity(
        projectId: 'project_123',
        taskId: 'task_456',
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = GetCommentsFilterEntity(
        projectId: 'old_project',
        taskId: 'old_task',
      );

      //! act
      final updated = entity.copyWith(
        projectId: 'new_project',
      );

      //! assert
      expect(updated.projectId, 'new_project');
      expect(updated.taskId, 'old_task');
      expect(updated, isNot(equals(entity)));
    });

    test('props should contain all fields', () {
      //! arrange
      const entity = GetCommentsFilterEntity(
        projectId: 'p1',
        taskId: 't1',
      );

      //! assert
      expect(entity.props, containsAll(['p1', 't1']));
    });
  });
}
