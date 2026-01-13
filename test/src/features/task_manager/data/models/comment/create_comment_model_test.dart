import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/create_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';

void main() {
  group('create comment model ...', () {
    const tAttachmentEntity = CreateCommentAttachment(
      fileName: 'test.png',
      fileType: 'image/png',
      fileUrl: 'https://test.com/test.png',
      resourceType: 'file',
    );

    const tCreateCommentEntity = CreateCommentEntity(
      id: '1',
      taskId: 'task_123',
      projectId: 'project_456',
      content: 'this is a test comment',
      attachment: tAttachmentEntity,
    );

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Act
        final result = CreateCommentModel.fromEntity(tCreateCommentEntity);

        //! Assert
        expect(result.id, tCreateCommentEntity.id);
        expect(result.taskId, tCreateCommentEntity.taskId);
        expect(result.content, tCreateCommentEntity.content);
        expect(result.attachment, isA<CreateCommentAttachment>());
      });
    });

    group('to json ...', () {
      test('should return a json map containing the proper data ...', () {
        //! Arrange
        final model = CreateCommentModel.fromEntity(tCreateCommentEntity);

        //! Act
        final result = model.toJson();

        //! Assert
        final expectedMap = {
          'task_id': 'task_123',
          'project_id': 'project_456',
          'content': 'this is a test comment',
          'attachment': {
            'file_name': 'test.png',
            'file_type': 'image/png',
            'file_url': 'https://test.com/test.png',
            'resource_type': 'file',
          },
        };
        expect(result, expectedMap);
      });

      test('should not include attachment key if attachment is null ...', () {
        //! Arrange
        const entityWithoutAttachment = CreateCommentEntity(
          id: '1',
          taskId: 'task_123',
          projectId: 'project_456',
          content: 'no attachment',
        );
        final model = CreateCommentModel.fromEntity(entityWithoutAttachment);

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result.containsKey('attachment'), isFalse);
      });
    });
  });

  group('create comment attachment model ...', () {
    final tJson = {
      'file_name': 'test.png',
      'file_type': 'image/png',
      'file_url': 'https://test.com/test.png',
      'resource_type': 'file',
    };

    group('from json ...', () {
      test('should return a valid model from json ...', () {
        //! Act
        final result = CreateCommentAttachmentModel.fromJson(tJson);

        //! Assert
        expect(result.fileName, 'test.png');
        expect(result.fileUrl, 'https://test.com/test.png');
      });
    });

    group('from entity ...', () {
      test('should return a valid model from attachment entity ...', () {
        //! Arrange
        const entity = CreateCommentAttachment(fileName: 'manual.pdf');

        //! Act
        final result = CreateCommentAttachmentModel.fromEntity(entity);

        //! Assert
        expect(result.fileName, 'manual.pdf');
      });
    });

    group('to json ...', () {
      test('should return a json map containing attachment data ...', () {
        //! Arrange
        const model = CreateCommentAttachmentModel(fileName: 'test.jpg');

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result['file_name'], 'test.jpg');
      });
    });
  });
}
