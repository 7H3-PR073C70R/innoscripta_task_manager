import 'package:equatable/equatable.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.timer,
    required this.status,
    this.id,
    this.creatorId,
    this.createdAt,
    this.assigneeId,
    this.assignerId,
    this.commentCount,
    this.isCompleted,
    this.content,
    this.description,
    this.due,
    this.deadline,
    this.duration,
    this.labels,
    this.order,
    this.priority,
    this.projectId,
    this.sectionId,
    this.parentId,
    this.url,
    this.completedAt,
  });
  final TaskTimer timer;
  final TaskStatus status;
  final String? id;
  final String? creatorId;
  final DateTime? createdAt;
  final String? assigneeId;
  final String? assignerId;
  final num? commentCount;
  final bool? isCompleted;
  final String? content;
  final String? description;
  final TaskDue? due;
  final TaskDeadline? deadline;
  final TaskDuration? duration;
  final List<String>? labels;
  final num? order;
  final num? priority;
  final String? projectId;
  final String? sectionId;
  final String? parentId;
  final String? url;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [
    status,
    timer,
    id,
    creatorId,
    createdAt,
    assigneeId,
    assignerId,
    commentCount,
    isCompleted,
    content,
    description,
    due,
    deadline,
    duration,
    labels,
    order,
    priority,
    projectId,
    sectionId,
    parentId,
    url,
    completedAt,
  ];

  TaskEntity copyWith({
    TaskTimer? timer,
    TaskStatus? status,
    String? id,
    String? creatorId,
    DateTime? createdAt,
    String? assigneeId,
    String? assignerId,
    num? commentCount,
    bool? isCompleted,
    String? content,
    String? description,
    TaskDue? due,
    TaskDeadline? deadline,
    TaskDuration? duration,
    List<String>? labels,
    num? order,
    num? priority,
    String? projectId,
    String? sectionId,
    String? parentId,
    String? url,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      timer: timer ?? this.timer,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      assigneeId: assigneeId ?? this.assigneeId,
      assignerId: assignerId ?? this.assignerId,
      commentCount: commentCount ?? this.commentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      content: content ?? this.content,
      description: description ?? this.description,
      due: due ?? this.due,
      deadline: deadline ?? this.deadline,
      duration: duration ?? this.duration,
      labels: labels ?? this.labels,
      order: order ?? this.order,
      priority: priority ?? this.priority,
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      parentId: parentId ?? this.parentId,
      url: url ?? this.url,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
    );
  }
}

class TaskDue extends Equatable {
  const TaskDue({
    this.date,
    this.isRecurring,
    this.datetime,
    this.string,
    this.timezone,
  });
  final DateTime? date;
  final bool? isRecurring;
  final DateTime? datetime;
  final String? string;
  final String? timezone;

  @override
  List<Object?> get props => [date, isRecurring, datetime, string, timezone];
}

class TaskDeadline extends Equatable {
  const TaskDeadline({this.date});
  final DateTime? date;

  @override
  List<Object?> get props => [date];
}

class TaskDuration extends Equatable {
  const TaskDuration({this.amount, this.unit});
  final num? amount;
  final String? unit;

  @override
  List<Object?> get props => [amount, unit];
}

class TaskTimer extends Equatable {
  const TaskTimer({
    this.startTime,
    this.stopTime,
    this.isRunning = false,
    this.totalSecondsCompleted = 0,
  });
  final DateTime? startTime;
  final DateTime? stopTime;
  final bool? isRunning;
  final num? totalSecondsCompleted;

  @override
  List<Object?> get props => [startTime, isRunning, totalSecondsCompleted];

  TaskTimer copyWith({
    DateTime? startTime,
    DateTime? stopTime,
    bool? isRunning,
    num? totalSecondsCompleted,
  }) {
    return TaskTimer(
      startTime: startTime,
      isRunning: isRunning ?? this.isRunning,
      stopTime: stopTime ?? this.stopTime,
      totalSecondsCompleted:
          totalSecondsCompleted ?? this.totalSecondsCompleted,
    );
  }
}
