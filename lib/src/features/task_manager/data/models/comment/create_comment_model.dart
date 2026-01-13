import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';

class CreateCommentModel extends CreateCommentEntity {
  const CreateCommentModel({
    required super.id,
    required super.taskId,
    required super.projectId,
    required super.content,
    super.attachment,
  });

  factory CreateCommentModel.fromEntity(CreateCommentEntity entity) {
    return CreateCommentModel(
      taskId: entity.taskId,
      projectId: entity.projectId,
      content: entity.content,
      attachment: entity.attachment,
      id: entity.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task_id': taskId,
      'project_id': projectId,
      'content': content,
      if (attachment != null)
        'attachment': CreateCommentAttachmentModel.fromEntity(
          attachment!,
        ).toJson(),
    };
  }
}

class CreateCommentAttachmentModel extends CreateCommentAttachment {
  const CreateCommentAttachmentModel({
    super.fileName,
    super.fileType,
    super.fileUrl,
    super.resourceType,
  });

  factory CreateCommentAttachmentModel.fromJson(Map<String, dynamic> json) {
    return CreateCommentAttachmentModel(
      fileName: json['file_name'] as String?,
      fileType: json['file_type'] as String?,
      fileUrl: json['file_url'] as String?,
      resourceType: json['resource_type'] as String?,
    );
  }

  factory CreateCommentAttachmentModel.fromEntity(
    CreateCommentAttachment entity,
  ) {
    return CreateCommentAttachmentModel(
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
