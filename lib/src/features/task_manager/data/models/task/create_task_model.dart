import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';

class CreateTaskModel extends CreateTaskEntity {
  const CreateTaskModel({
    required super.id,
    required super.content,
    required super.description,
    super.projectId,
    super.sectionId,
    super.parentId,
    super.order,
    super.labels,
    super.priority,
    super.dueString,
    super.dueDate,
    super.dueDatetime,
    super.dueLang,
    super.assigneeId,
    super.duration,
    super.durationUnit,
    super.deadlineDate,
  });

  factory CreateTaskModel.fromEntity(CreateTaskEntity entity) {
    return CreateTaskModel(
      id: entity.id,
      content: entity.content,
      description: entity.description,
      projectId: entity.projectId,
      sectionId: entity.sectionId,
      parentId: entity.parentId,
      order: entity.order,
      labels: entity.labels,
      priority: entity.priority,
      dueString: entity.dueString,
      dueDate: entity.dueDate,
      dueDatetime: entity.dueDatetime,
      dueLang: entity.dueLang,
      assigneeId: entity.assigneeId,
      duration: entity.duration,
      durationUnit: entity.durationUnit,
      deadlineDate: entity.deadlineDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'description': description,
      if (projectId != null) 'project_id': projectId,
      if (sectionId != null) 'section_id': sectionId,
      if (parentId != null) 'parent_id': parentId,
      if (order != null) 'order': order,
      if (labels != null) 'labels': labels,
      if (priority != null) 'priority': priority,
      if (dueString != null) 'due_string': dueString,
      if (dueDate != null) 'due_date': dueDate?.toIso8601String().split('T')[0],
      if (dueDatetime != null) 'due_datetime': dueDatetime?.toIso8601String(),
      if (dueLang != null) 'due_lang': dueLang,
      if (assigneeId != null) 'assignee_id': assigneeId,
      if (duration != null) 'duration': duration,
      if (durationUnit != null) 'duration_unit': durationUnit,
      if (deadlineDate != null)
        'deadline_date': deadlineDate?.toIso8601String().split('T')[0],
    };
  }
}
