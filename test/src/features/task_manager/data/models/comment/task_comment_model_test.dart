import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/task_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';

void main() {
  group('task comment model ...', () {
    final tDate = DateTime(2024, 1, 1, 12);
    final tDateString = tDate.toIso8601String();

    final tJson = {
      'content': 'test content',
      'id': '1',
      'posted_at': tDateString,
      'project_id': 'p1',
      'task_id': 't1',
      'attachment': {
        'file_name': 'test.png',
        'file_type': 'image/png',
        'file_url': 'url',
        'resource_type': 'file',
      },
    };

    const tEntity = TaskCommentEntity(
      id: '1',
      content: 'test content',
      projectId: 'p1',
      taskId: 't1',
      attachment: CommentAttachment(
        fileName: 'test.png',
        fileType: 'image/png',
        fileUrl: 'url',
        resourceType: 'file',
      ),
    );

    group('from json ...', () {
      test('should return a valid model when the json is valid ...', () {
        //! Act
        final result = TaskCommentModel.fromJson(tJson);

        //! Assert
        expect(result.id, '1');
        expect(result.postedAt, tDate);
        expect(result.attachment, isA<CommentAttachment>());
        expect(result.attachment?.fileName, 'test.png');
      });

      test('should handle null posted_at and attachment ...', () {
        //! Arrange
        final json = {'id': '1', 'posted_at': null, 'attachment': null};

        //! Act
        final result = TaskCommentModel.fromJson(json);

        //! Assert
        expect(result.postedAt, isNull);
        expect(result.attachment, isNull);
      });
    });

    group('from entity ...', () {
      test('should return a valid model from entity ...', () {
        //! Act
        final result = TaskCommentModel.fromEntity(tEntity);

        //! Assert
        expect(result.id, tEntity.id);
        expect(result.content, tEntity.content);
        expect(result.attachment, tEntity.attachment);
      });
    });

    group('to json ...', () {
      test('should return a json map containing the proper data ...', () {
        //! Arrange
        final model = TaskCommentModel(
          id: '1',
          content: 'test',
          postedAt: tDate,
        );

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result['id'], '1');
        expect(result['posted_at'], tDateString);
      });

      test('should include attachment in json when present ...', () {
        //! Arrange
        final model = TaskCommentModel.fromEntity(tEntity);

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result.containsKey('attachment'), isTrue);
        expect(
          (result['attachment'] as Map<String, dynamic>)['file_name'],
          'test.png',
        );
      });
    });
  });

  group('comment attachment model ...', () {
    const tAttachmentJson = {
      'file_name': 'file.pdf',
      'file_type': 'application/pdf',
      'file_url': 'https://test.com',
      'resource_type': 'file',
    };

    group('from json ...', () {
      test('should return a valid model from json ...', () {
        //! Act
        final result = CommentAttachmentModel.fromJson(tAttachmentJson);

        //! Assert
        expect(result.fileName, 'file.pdf');
        expect(result.resourceType, 'file');
      });
    });

    group('to json ...', () {
      test('should return correct json map ...', () {
        //! Arrange
        const model = CommentAttachmentModel(fileName: 'file.pdf');

        //! Act
        final result = model.toJson();

        //! Assert
        expect(result['file_name'], 'file.pdf');
      });
    });
  });
}
