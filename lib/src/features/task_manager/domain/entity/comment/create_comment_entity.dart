import 'package:equatable/equatable.dart';

class CreateCommentEntity extends Equatable {
  const CreateCommentEntity({
    required this.taskId,
    required this.projectId,
    required this.content,
    this.attachment,
  });
  final String taskId;
  final String projectId;
  final String content;
  final CreateCommentAttachment? attachment;

  @override
  List<Object?> get props => [taskId, projectId, content, attachment];

  CreateCommentEntity copyWith({
    String? taskId,
    String? projectId,
    String? content,
    CreateCommentAttachment? attachment,
  }) {
    return CreateCommentEntity(
      taskId: taskId ?? this.taskId,
      projectId: projectId ?? this.projectId,
      content: content ?? this.content,
      attachment: attachment ?? this.attachment,
    );
  }
}

class CreateCommentAttachment extends Equatable {
  const CreateCommentAttachment({
    this.fileName,
    this.fileType,
    this.fileUrl,
    this.resourceType,
  });
  final String? fileName;
  final String? fileType;
  final String? fileUrl;
  final String? resourceType;

  @override
  List<Object?> get props => [fileName, fileType, fileUrl, resourceType];

  CreateCommentAttachment copyWith({
    String? fileName,
    String? fileType,
    String? fileUrl,
    String? resourceType,
  }) {
    return CreateCommentAttachment(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
      resourceType: resourceType ?? this.resourceType,
    );
  }
}
