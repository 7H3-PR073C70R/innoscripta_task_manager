import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';

void main() {
  group('task comment entity ...', () {
    test('should support value equality', () {
      //! arrange
      final postedAt = DateTime.now();
      final entityA = TaskCommentEntity(
        id: '1',
        content: 'test content',
        postedAt: postedAt,
      );
      final entityB = TaskCommentEntity(
        id: '1',
        content: 'test content',
        postedAt: postedAt,
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const entity = TaskCommentEntity(
        id: '1',
        content: 'old content',
        projectId: 'p1',
      );

      //! act
      final updated = entity.copyWith(
        content: 'new content',
        taskId: 't1',
      );

      //! assert
      expect(updated.content, 'new content');
      expect(updated.projectId, 'p1');
      expect(updated.taskId, 't1');
      expect(updated, isNot(equals(entity)));
    });

    test('should support nested equality for attachments', () {
      //! arrange
      const attachment1 = CommentAttachment(
        fileName: 'file.pdf',
        fileType: 'application/pdf',
      );
      const attachment2 = CommentAttachment(
        fileName: 'file.pdf',
        fileType: 'application/pdf',
      );

      const entity1 = TaskCommentEntity(
        id: '1',
        attachment: attachment1,
      );
      const entity2 = TaskCommentEntity(
        id: '1',
        attachment: attachment2,
      );

      //! assert
      expect(entity1, equals(entity2));
    });
  });

  group('comment attachment ...', () {
    test('should support value equality', () {
      //! arrange
      const attachmentA = CommentAttachment(
        fileName: 'img.png',
        resourceType: 'file',
      );
      const attachmentB = CommentAttachment(
        fileName: 'img.png',
        resourceType: 'file',
      );

      //! assert
      expect(attachmentA, equals(attachmentB));
    });

    test('copyWith should work correctly for attachment fields', () {
      //! arrange
      const attachment = CommentAttachment(fileName: 'data.json');

      //! act
      final result = attachment.copyWith(
        fileUrl: 'https://example.com/data.json',
      );

      //! assert
      expect(result.fileName, 'data.json');
      expect(result.fileUrl, 'https://example.com/data.json');
    });
  });
}
