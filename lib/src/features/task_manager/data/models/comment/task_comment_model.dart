import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';

class TaskCommentModel extends TaskCommentEntity {
  const TaskCommentModel({
    super.content,
    super.id,
    super.postedAt,
    super.projectId,
    super.taskId,
    super.attachment,
  });

  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      content: json['content'] as String?,
      id: json['id'] as String?,
      postedAt: json['posted_at'] != null
          ? DateTime.parse(json['posted_at'] as String)
          : null,
      projectId: json['project_id'] as String?,
      taskId: json['task_id'] as String?,
      attachment: json['attachment'] != null
          ? CommentAttachmentModel.fromJson(
              json['attachment'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  factory TaskCommentModel.fromEntity(TaskCommentEntity entity) {
    return TaskCommentModel(
      content: entity.content,
      id: entity.id,
      postedAt: entity.postedAt,
      projectId: entity.projectId,
      taskId: entity.taskId,
      attachment: entity.attachment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'id': id,
      'posted_at': postedAt?.toIso8601String(),
      'project_id': projectId,
      'task_id': taskId,
      if (attachment != null)
        'attachment': CommentAttachmentModel.fromEntity(attachment!).toJson(),
    };
  }
}

class CommentAttachmentModel extends CommentAttachment {
  const CommentAttachmentModel({
    super.fileName,
    super.fileType,
    super.fileUrl,
    super.resourceType,
  });

  factory CommentAttachmentModel.fromJson(Map<String, dynamic> json) {
    return CommentAttachmentModel(
      fileName: json['file_name'] as String?,
      fileType: json['file_type'] as String?,
      fileUrl: json['file_url'] as String?,
      resourceType: json['resource_type'] as String?,
    );
  }

  factory CommentAttachmentModel.fromEntity(CommentAttachment entity) {
    return CommentAttachmentModel(
      fileName: entity.fileName,
      fileType: entity.fileType,
      fileUrl: entity.fileUrl,
      resourceType: entity.resourceType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name': fileName,
      'file_type': fileType,
      'file_url': fileUrl,
      'resource_type': resourceType,
    };
  }
}
