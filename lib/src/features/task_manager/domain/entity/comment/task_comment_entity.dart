import 'package:equatable/equatable.dart';

class TaskCommentEntity extends Equatable {
  const TaskCommentEntity({
    this.content,
    this.id,
    this.postedAt,
    this.projectId,
    this.taskId,
    this.attachment,
  });
  final String? content;
  final String? id;
  final DateTime? postedAt;
  final String? projectId;
  final String? taskId;
  final CommentAttachment? attachment;

  @override
  List<Object?> get props => [
    content,
    id,
    postedAt,
    projectId,
    taskId,
    attachment,
  ];

  TaskCommentEntity copyWith({
    String? content,
    String? id,
    DateTime? postedAt,
    String? projectId,
    String? taskId,
    CommentAttachment? attachment,
  }) {
    return TaskCommentEntity(
      content: content ?? this.content,
      id: id ?? this.id,
      postedAt: postedAt ?? this.postedAt,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      attachment: attachment ?? this.attachment,
    );
  }
}

class CommentAttachment extends Equatable {
  const CommentAttachment({
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

  CommentAttachment copyWith({
    String? fileName,
    String? fileType,
    String? fileUrl,
    String? resourceType,
  }) {
    return CommentAttachment(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileUrl: fileUrl ?? this.fileUrl,
      resourceType: resourceType ?? this.resourceType,
    );
  }
}
