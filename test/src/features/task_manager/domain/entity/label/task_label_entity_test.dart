import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';

void main() {
  group('task label entity ...', () {
    test('should support value equality', () {
      //! arrange
      const entityA = TaskLabelEntity(
        id: '1',
        name: 'urgent',
        color: 'red',
        order: 1,
        isFavorite: true,
      );

      const entityB = TaskLabelEntity(
        id: '1',
        name: 'urgent',
        color: 'red',
        order: 1,
        isFavorite: true,
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = TaskLabelEntity(
        id: '1',
        name: 'work',
        isFavorite: false,
      );

      //! act
      final updated = entity.copyWith(
        name: 'personal',
        order: 5,
      );

      //! assert
      expect(updated.name, 'personal');
      expect(updated.order, 5);
      expect(updated.id, '1');
      expect(updated.isFavorite, false);
      expect(updated, isNot(equals(entity)));
    });

    test('props should contain all fields', () {
      //! arrange
      const entity = TaskLabelEntity(
        id: 'label_id',
        name: 'shopping',
        color: 'blue',
        order: 10,
        isFavorite: false,
      );

      //! assert
      expect(
        entity.props,
        containsAll(['label_id', 'shopping', 'blue', 10, false]),
      );
    });
  });
}
