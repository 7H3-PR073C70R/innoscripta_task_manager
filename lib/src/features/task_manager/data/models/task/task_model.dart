import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.timer,
    required super.status,
    super.id,
    super.creatorId,
    super.createdAt,
    super.assigneeId,
    super.assignerId,
    super.commentCount,
    super.isCompleted,
    super.content,
    super.description,
    super.due,
    super.deadline,
    super.duration,
    super.labels,
    super.order,
    super.priority,
    super.projectId,
    super.sectionId,
    super.parentId,
    super.url,
    super.completedAt,
  });
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      timer: entity.timer,
      status: entity.status,
      id: entity.id,
      creatorId: entity.creatorId,
      createdAt: entity.createdAt,
      assigneeId: entity.assigneeId,
      assignerId: entity.assignerId,
      commentCount: entity.commentCount,
      isCompleted: entity.isCompleted,
      content: entity.content,
      description: entity.description,
      due: entity.due,
      deadline: entity.deadline,
      duration: entity.duration,
      labels: entity.labels,
      order: entity.order,
      priority: entity.priority,
      projectId: entity.projectId,
      sectionId: entity.sectionId,
      parentId: entity.parentId,
      url: entity.url,
      completedAt: entity.completedAt,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String?,
      creatorId: json['creator_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      assigneeId: json['assignee_id'] as String?,
      assignerId: json['assigner_id'] as String?,
      commentCount: json['comment_count'] as num?,
      isCompleted: json['is_completed'] as bool?,
      content: json['content'] as String?,
      description: json['description'] as String?,
      due: json['due'] != null
          ? TaskDueModel.fromJson(json['due'] as Map<String, dynamic>)
          : null,
      deadline: json['deadline'] != null
          ? TaskDeadlineModel.fromJson(json['deadline'] as Map<String, dynamic>)
          : null,
      duration: json['duration'] != null
          ? TaskDurationModel.fromJson(json['duration'] as Map<String, dynamic>)
          : null,
      timer: json['timer'] != null
          ? TaskTimerModel.fromJson(json['timer'] as Map<String, dynamic>)
          : const TaskTimerModel(),
      status: json['status'] != null
          ? TaskStatus.values[json['status'] as int]
          : TaskStatus.todo,
      labels: (json['labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      order: json['order'] as num?,
      priority: json['priority'] as num?,
      projectId: json['project_id'] as String?,
      sectionId: json['section_id'] as String?,
      parentId: json['parent_id'] as String?,
      url: json['url'] as String?,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'created_at': createdAt?.toIso8601String(),
      'assignee_id': assigneeId,
      'assigner_id': assignerId,
      'comment_count': commentCount,
      'is_completed': isCompleted,
      'content': content,
      'description': description,
      'due': due != null ? TaskDueModel.fromEntity(due!).toJson() : null,
      'deadline': deadline != null
          ? TaskDeadlineModel.fromEntity(deadline!).toJson()
          : null,
      'duration': duration != null
          ? TaskDurationModel.fromEntity(duration!).toJson()
          : null,
      'timer': TaskTimerModel.fromEntity(timer).toJson(),
      'status': status.index,
      'labels': labels,
      'order': order,
      'priority': priority,
      'project_id': projectId,
      'section_id': sectionId,
      'parent_id': parentId,
      'url': url,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class TaskDueModel extends TaskDue {
  const TaskDueModel({
    super.date,
    super.isRecurring,
    super.datetime,
    super.string,
    super.timezone,
  });

  factory TaskDueModel.fromJson(Map<String, dynamic> json) => TaskDueModel(
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    isRecurring: json['is_recurring'] as bool?,
    datetime: json['datetime'] != null
        ? DateTime.parse(json['datetime'] as String)
        : null,
    string: json['string'] as String?,
    timezone: json['timezone'] as String?,
  );

  factory TaskDueModel.fromEntity(TaskDue entity) => TaskDueModel(
    date: entity.date,
    isRecurring: entity.isRecurring,
    datetime: entity.datetime,
    string: entity.string,
    timezone: entity.timezone,
  );

  Map<String, dynamic> toJson() => {
    'date': date?.toIso8601String().split('T')[0],
    'is_recurring': isRecurring,
    'datetime': datetime?.toIso8601String(),
    'string': string,
    'timezone': timezone,
  };
}

class TaskDeadlineModel extends TaskDeadline {
  const TaskDeadlineModel({super.date});
  factory TaskDeadlineModel.fromJson(Map<String, dynamic> json) =>
      TaskDeadlineModel(
        date: json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : null,
      );
  factory TaskDeadlineModel.fromEntity(TaskDeadline entity) =>
      TaskDeadlineModel(date: entity.date);
  Map<String, dynamic> toJson() => {
    'date': date?.toIso8601String().split('T')[0],
  };
}

class TaskDurationModel extends TaskDuration {
  const TaskDurationModel({super.amount, super.unit});
  factory TaskDurationModel.fromJson(Map<String, dynamic> json) =>
      TaskDurationModel(
        amount: json['amount'] as num?,
        unit: json['unit'] as String?,
      );
  factory TaskDurationModel.fromEntity(TaskDuration entity) =>
      TaskDurationModel(amount: entity.amount, unit: entity.unit);
  Map<String, dynamic> toJson() => {'amount': amount, 'unit': unit};
}

class TaskTimerModel extends TaskTimer {
  const TaskTimerModel({
    super.startTime,
    super.stopTime,
    super.isRunning,
    super.totalSecondsCompleted,
  });

  factory TaskTimerModel.fromJson(Map<String, dynamic> json) => TaskTimerModel(
    startTime: json['start_time'] != null
        ? DateTime.parse(json['start_time'] as String)
        : null,
    stopTime: json['stop_time'] != null
        ? DateTime.parse(json['stop_time'] as String)
        : null,
    isRunning: json['is_running'] as bool? ?? false,
    totalSecondsCompleted: json['total_seconds_completed'] as num? ?? 0,
  );

  factory TaskTimerModel.fromEntity(TaskTimer entity) => TaskTimerModel(
    startTime: entity.startTime,
    stopTime: entity.stopTime,
    isRunning: entity.isRunning,
    totalSecondsCompleted: entity.totalSecondsCompleted,
  );

  Map<String, dynamic> toJson() => {
    'start_time': startTime?.toIso8601String(),
    'stop_time': stopTime?.toIso8601String(),
    'is_running': isRunning,
    'total_seconds_completed': totalSecondsCompleted,
  };
}
