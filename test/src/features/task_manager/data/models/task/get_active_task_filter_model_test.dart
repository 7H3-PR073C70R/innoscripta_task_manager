import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/get_active_task_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';

void main() {
  group('get active tasks filter model ...', () {
    const tProjectId = 'p123';

    const tIds = [1, 2, 3];

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Arrange
        const entity = GetActiveTasksFilterEntity(
          projectId: tProjectId,
          ids: [1, 2],
        );

        //! Act
        final result = GetActiveTasksFilterModel.fromEntity(entity);

        //! Assert
        expect(result.projectId, entity.projectId);
        expect(result.ids, entity.ids);
      });
    });

    group('to json ...', () {
      test('should return a json map containing the proper data ...', () {
        //! Arrange
        const model = GetActiveTasksFilterModel(
          projectId: tProjectId,
          ids: tIds,
        );

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result['project_id'], tProjectId);
        expect(result['ids'], tIds);
      });

      test('should not include null fields in the json map ...', () {
        //! Arrange
        const model = GetActiveTasksFilterModel(projectId: tProjectId);

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result.length, 1);
        expect(result.containsKey('project_id'), isTrue);
        expect(result.containsKey('ids'), isFalse);
      });
    });
  });
}
