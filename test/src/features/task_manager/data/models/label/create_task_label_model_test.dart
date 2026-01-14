import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/create_task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';

void main() {
  group('create task label model ...', () {
    const tName = 'urgent';
    const tId = 'label_123';
    const tColor = 'berry_red';
    const tColorName = 'berry_red';

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Arrange
        const entity = CreateTaskLabelEntity(
          name: tName,
          id: tId,
          color: tColor,
          isFavorite: true,
          order: 1,
        );

        //! Act
        final result = CreateTaskLabelModel.fromEntity(entity);

        //! Assert
        expect(result.name, entity.name);
        expect(result.id, entity.id);
        expect(result.color, entity.color);
        expect(result.isFavorite, entity.isFavorite);
        expect(result.order, entity.order);
      });
    });

    group('to json ...', () {
      test(
        'should return a json map with all fields when they are not null ...',
        () {
          //! Arrange
          const model = CreateTaskLabelModel(
            name: tName,
            id: tId,
            color: tColor,
            isFavorite: true,
            order: 5,
          );

          //! Act
          final result = model.toJson();

          //! Assert
          final expectedMap = {
            'name': tName,
            'order': 5,
            'color': tColorName,
            'is_favorite': true,
          };
          expect(result, expectedMap);
        },
      );

      test(
        'should only include name in json when other fields are null ...',
        () {
          //! Arrange
          const model = CreateTaskLabelModel(
            name: tName,
            id: tId,
          );

          //! Act
          final result = model.toJson();

          //! Assert
          expect(result, {'name': tName});
          expect(result.containsKey('order'), isFalse);
          expect(result.containsKey('color'), isFalse);
          expect(result.containsKey('is_favorite'), isFalse);
        },
      );

      test(
        'should correctly include color name in json ...',
        () {
          //! Arrange
          const colorName = 'blue';
          const model = CreateTaskLabelModel(
            name: 'blue',
            id: '1',
            color: colorName,
          );

          //! Act
          final result = model.toJson();

          //! Assert
          expect(result['color'], colorName);
        },
      );
    });
  });
}
