import 'package:equatable/equatable.dart';

class CreateTaskEntity extends Equatable {
  const CreateTaskEntity({
    required this.content,
    required this.description,
    this.projectId,
    this.sectionId,
    this.parentId,
    this.order,
    this.labels,
    this.priority,
    this.dueString,
    this.dueDate,
    this.dueDatetime,
    this.dueLang,
    this.assigneeId,
    this.duration,
    this.durationUnit,
    this.deadlineDate,
  });
  final String content;
  final String description;
  final String? projectId;
  final String? sectionId;
  final String? parentId;
  final num? order;
  final List<String>? labels;
  final num? priority;
  final String? dueString;
  final DateTime? dueDate;
  final DateTime? dueDatetime;
  final String? dueLang;
  final String? assigneeId;
  final num? duration;
  final String? durationUnit;
  final DateTime? deadlineDate;

  @override
  List<Object?> get props => [
    content,
    description,
    projectId,
    sectionId,
    parentId,
    order,
    labels,
    priority,
    dueString,
    dueDate,
    dueDatetime,
    dueLang,
    assigneeId,
    duration,
    durationUnit,
    deadlineDate,
  ];

  CreateTaskEntity copyWith({
    String? content,
    String? description,
    String? projectId,
    String? sectionId,
    String? parentId,
    num? order,
    List<String>? labels,
    num? priority,
    String? dueString,
    DateTime? dueDate,
    DateTime? dueDatetime,
    String? dueLang,
    String? assigneeId,
    num? duration,
    String? durationUnit,
    DateTime? deadlineDate,
  }) {
    return CreateTaskEntity(
      content: content ?? this.content,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
      labels: labels ?? this.labels,
      priority: priority ?? this.priority,
      dueString: dueString ?? this.dueString,
      dueDate: dueDate ?? this.dueDate,
      dueDatetime: dueDatetime ?? this.dueDatetime,
      dueLang: dueLang ?? this.dueLang,
      assigneeId: assigneeId ?? this.assigneeId,
      duration: duration ?? this.duration,
      durationUnit: durationUnit ?? this.durationUnit,
      deadlineDate: deadlineDate ?? this.deadlineDate,
    );
  }
}
