import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';

void main() {
  group('create task label entity ...', () {
    test('should support value equality', () {
      //! arrange
      const entityA = CreateTaskLabelEntity(
        name: 'shopping',
        order: 1,
        color: Colors.blue,
        isFavorite: true,
      );

      const entityB = CreateTaskLabelEntity(
        name: 'shopping',
        order: 1,
        color: Colors.blue,
        isFavorite: true,
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = CreateTaskLabelEntity(
        name: 'work',
        order: 2,
        color: Colors.red,
      );

      //! act
      final updated = entity.copyWith(
        name: 'personal',
        isFavorite: false,
      );

      //! assert
      expect(updated.name, 'personal');
      expect(updated.order, 2);
      expect(updated.isFavorite, false);
      expect(updated, isNot(equals(entity)));
    });

    test('props should contain all fields', () {
      //! arrange
      const entity = CreateTaskLabelEntity(
        name: 'urgent',
        order: 5,
        color: Colors.red,
        isFavorite: true,
      );

      //! assert
      expect(
        entity.props,
        containsAll(['urgent', 5, Colors.red, true]),
      );
    });
  });
}
