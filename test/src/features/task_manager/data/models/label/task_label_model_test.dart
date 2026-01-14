import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';

void main() {
  group('task label model ...', () {
    const tId = 'label_1';
    const tName = 'work';
    const tColor = 'berry_red';
    const tOrder = 10;
    const tIsFavorite = true;

    const tJson = {
      'id': tId,
      'name': tName,
      'color': 'berry_red',
      'order': tOrder,
      'is_favorite': tIsFavorite,
    };

    const tEntity = TaskLabelEntity(
      id: tId,
      name: tName,
      color: tColor,
      order: tOrder,
      isFavorite: tIsFavorite,
    );

    group('from json ...', () {
      test('should return a valid model when the json is valid ...', () {
        //! Act
        final result = TaskLabelModel.fromJson(tJson);

        //! Assert
        expect(result.id, tId);
        expect(result.name, tName);
        expect(result.color, tColor);
        expect(result.order, tOrder);
        expect(result.isFavorite, tIsFavorite);
      });

      test('should handle null values in json correctly ...', () {
        //! Arrange
        final json = <String, dynamic>{
          'id': '1',
          'name': null,
          'color': null,
          'order': null,
          'is_favorite': null,
        };

        //! Act
        final result = TaskLabelModel.fromJson(json);

        //! Assert
        expect(result.id, '1');
        expect(result.name, isNull);
        expect(result.color, isNull);
        expect(result.order, isNull);
        expect(result.isFavorite, isNull);
      });
    });

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Act
        final result = TaskLabelModel.fromEntity(tEntity);

        //! Assert
        expect(result.id, tEntity.id);
        expect(result.name, tEntity.name);
        expect(result.color, tEntity.color);
        expect(result.order, tEntity.order);
        expect(result.isFavorite, tEntity.isFavorite);
      });
    });

    group('to json ...', () {
      test('should return a json map containing the proper data ...', () {
        //! Arrange
        const model = TaskLabelModel(
          id: tId,
          name: tName,
          color: tColor,
          order: tOrder,
          isFavorite: tIsFavorite,
        );

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result, tJson);
      });
    });
  });
}
