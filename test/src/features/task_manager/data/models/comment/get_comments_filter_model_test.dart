import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/get_comments_filter_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';

void main() {
  group('get comments filter model ...', () {
    const tProjectId = 'project_123';
    const tTaskId = 'task_456';

    const tJson = {
      'project_id': tProjectId,
      'task_id': tTaskId,
    };

    const tEntity = GetCommentsFilterEntity(
      projectId: tProjectId,
      taskId: tTaskId,
    );

    group('from json ...', () {
      test('should return a valid model when the json is valid ...', () {
        //! Act
        final result = GetCommentsFilterModel.fromJson(tJson);

        //! Assert
        expect(result.projectId, tProjectId);
        expect(result.taskId, tTaskId);
        expect(result, isA<GetCommentsFilterModel>());
      });
    });

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Act
        final result = GetCommentsFilterModel.fromEntity(tEntity);

        //! Assert
        expect(result.projectId, tEntity.projectId);
        expect(result.taskId, tEntity.taskId);
      });
    });

    group('to json ...', () {
      test('should return a json map containing the proper data ...', () {
        //! Arrange
        const model = GetCommentsFilterModel(
          projectId: tProjectId,
          taskId: tTaskId,
        );

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result, tJson);
      });
    });
  });
}
