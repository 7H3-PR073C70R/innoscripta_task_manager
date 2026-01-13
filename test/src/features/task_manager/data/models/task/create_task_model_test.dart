import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/create_task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';

void main() {
  group('create task model ...', () {
    final tDate = DateTime(2026, 1, 14, 12, 30);
    const tContent = 'Test Task';
    const tDescription = 'Test Description';

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Arrange
        final entity = CreateTaskEntity(
          id: '1',
          content: tContent,
          description: tDescription,
          projectId: 'p1',
          priority: 4,
          dueDate: tDate,
        );

        //! Act
        final result = CreateTaskModel.fromEntity(entity);

        //! Assert
        expect(result.id, entity.id);
        expect(result.content, entity.content);
        expect(result.description, entity.description);
        expect(result.projectId, entity.projectId);
        expect(result.priority, entity.priority);
        expect(result.dueDate, entity.dueDate);
      });
    });

    group('to json ...', () {
      test('should return a json map with all non-null fields ...', () {
        //! Arrange
        final model = CreateTaskModel(
          id: '1',
          content: tContent,
          description: tDescription,
          projectId: 'proj_123',
          labels: const ['work', 'urgent'],
          priority: 2,
          dueDate: tDate,
          dueDatetime: tDate,
          deadlineDate: tDate,
        );

        //! Act
        final result = model.toJson();

        //! Assert
        final expectedMap = {
          'content': tContent,
          'description': tDescription,
          'project_id': 'proj_123',
          'labels': ['work', 'urgent'],
          'priority': 2,
          'due_date': '2026-01-14',
          'due_datetime': tDate.toIso8601String(),
          'deadline_date': '2026-01-14',
        };
        expect(result, expectedMap);
      });

      test(
        'should only include required fields when optional fields are null ...',
        () {
          //! Arrange
          const model = CreateTaskModel(
            id: '1',
            content: tContent,
            description: tDescription,
          );

          //! Act
          final result = model.toJson();

          //! Assert
          expect(result, {
            'content': tContent,
            'description': tDescription,
          });
          expect(result.containsKey('project_id'), isFalse);
          expect(result.containsKey('due_date'), isFalse);
          expect(result.containsKey('priority'), isFalse);
        },
      );

      test(
        'should correctly format due_date and deadline_date to YYYY-MM-DD ...',
        () {
          //! Arrange
          final specificDate = DateTime(2026, 12, 31, 23, 59);
          final model = CreateTaskModel(
            id: '1',
            content: 'Date Test',
            description: '',
            dueDate: specificDate,
            deadlineDate: specificDate,
          );

          //! Act
          final result = model.toJson();

          //! Assert
          expect(result['due_date'], '2026-12-31');
          expect(result['deadline_date'], '2026-12-31');
        },
      );
    });
  });
}
