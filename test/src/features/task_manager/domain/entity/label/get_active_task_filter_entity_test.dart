// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/get_active_task_filter_entity.dart';

void main() {
  group('get active tasks filter entity ...', () {
    test('should support value equality', () {
      //! arrange
      const entityA = GetActiveTasksFilterEntity(
        projectId: 'p1',
        ids: [1, 2, 3],
      );

      const entityB = GetActiveTasksFilterEntity(
        projectId: 'p1',
        ids: [1, 2, 3],
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = GetActiveTasksFilterEntity(
        projectId: 'old_project',
        filter: 'priority 1',
      );

      //! act
      final updated = entity.copyWith(
        projectId: 'new_project',
        lang: 'en',
      );

      //! assert
      expect(updated.projectId, 'new_project');
      expect(updated.filter, 'priority 1');
      expect(updated.lang, 'en');
      expect(updated, isNot(equals(entity)));
    });

    test('props should contain all fields', () {
      //! arrange
      const entity = GetActiveTasksFilterEntity(
        projectId: 'p1',
        sectionId: 's1',
        label: 'l1',
        filter: 'f1',
        lang: 'en',
      );

      //! assert
      expect(
        entity.props,
        containsAll(['p1', 's1', 'l1', 'f1', 'en']),
      );
    });

    test(
      'should maintain equality with different list instances containing same values',
      () {
        //! arrange
        const entityA = GetActiveTasksFilterEntity(ids: [10, 20]);
        const entityB = GetActiveTasksFilterEntity(ids: [10, 20]);

        //! assert
        expect(entityA, equals(entityB));
      },
    );
  });
}
