import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';

class GetCommentsFilterModel extends GetCommentsFilterEntity {
  const GetCommentsFilterModel({
    required super.projectId,
    required super.taskId,
  });

  factory GetCommentsFilterModel.fromJson(Map<String, dynamic> json) {
    return GetCommentsFilterModel(
      projectId: json['project_id'] as String,
      taskId: json['task_id'] as String,
    );
  }

  factory GetCommentsFilterModel.fromEntity(GetCommentsFilterEntity entity) {
    return GetCommentsFilterModel(
      projectId: entity.projectId,
      taskId: entity.taskId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_id': projectId,
      'task_id': taskId,
    };
  }
}
