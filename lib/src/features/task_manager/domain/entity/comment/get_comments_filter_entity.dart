import 'package:equatable/equatable.dart';

class GetCommentsFilterEntity extends Equatable {
  const GetCommentsFilterEntity({
    required this.projectId,
    required this.taskId,
  });
  final String projectId;
  final String taskId;

  @override
  List<Object?> get props => [projectId, taskId];

  GetCommentsFilterEntity copyWith({
    String? projectId,
    String? taskId,
  }) {
    return GetCommentsFilterEntity(
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
    );
  }
}
