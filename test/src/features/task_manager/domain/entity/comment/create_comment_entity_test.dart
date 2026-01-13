import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import '../../../../../../helpers/test_entities.dart';

void main() {
  group('create comment entity ...', () {
    test('should support value equality', () {
      //! arrange
      final entityA = CreateCommentEntity(
        taskId: TestEntities.tCommentEntity.taskId!,
        projectId: TestEntities.tCommentEntity.projectId!,
        content: TestEntities.tCommentEntity.content!,
      );

      final entityB = CreateCommentEntity(
        taskId: TestEntities.tCommentEntity.taskId!,
        projectId: TestEntities.tCommentEntity.projectId!,
        content: TestEntities.tCommentEntity.content!,
      );

      //! assert
      expect(entityA, equals(entityB));
    });

    test('copyWith should return a new object with updated values', () {
      //! arrange
      const originalAttachment = CreateCommentAttachment(fileName: 'old.pdf');
      const entity = CreateCommentEntity(
        taskId: '1',
        projectId: 'A',
        content: 'Old Content',
        attachment: originalAttachment,
      );

      //! act
      final updated = entity.copyWith(
        content: 'New Content',
        attachment: const CreateCommentAttachment(fileName: 'new.pdf'),
      );

      //! assert
      expect(updated.content, 'New Content');
      expect(updated.taskId, entity.taskId); // Remains unchanged
      expect(updated.attachment?.fileName, 'new.pdf');
      expect(updated, isNot(equals(entity)));
    });

    test('should support nested equality for attachments', () {
      //! arrange
      const attachment1 = CreateCommentAttachment(
        fileName: 'file.png',
        fileType: 'image/png',
      );
      const attachment2 = CreateCommentAttachment(
        fileName: 'file.png',
        fileType: 'image/png',
      );

      const entity1 = CreateCommentEntity(
        taskId: '1',
        projectId: '1',
        content: 'test',
        attachment: attachment1,
      );

      const entity2 = CreateCommentEntity(
        taskId: '1',
        projectId: '1',
        content: 'test',
        attachment: attachment2,
      );

      //! assert
      expect(entity1, equals(entity2));
    });
  });

  group('create comment attachment ...', () {
    test('copyWith should work correctly for attachment fields', () {
      //! arrange
      const attachment = CreateCommentAttachment(fileName: 'test.txt');

      //! act
      final result = attachment.copyWith(fileType: 'text/plain');

      //! assert
      expect(result.fileName, 'test.txt');
      expect(result.fileType, 'text/plain');
    });
  });
}
