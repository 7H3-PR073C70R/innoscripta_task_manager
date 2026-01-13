import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';

class TaskLabelModel extends TaskLabelEntity {
  const TaskLabelModel({
    super.id,
    super.name,
    super.color,
    super.order,
    super.isFavorite,
  });

  factory TaskLabelModel.fromJson(Map<String, dynamic> json) {
    return TaskLabelModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      color: json['color'] as String?,
      order: json['order'] as num?,
      isFavorite: json['is_favorite'] as bool?,
    );
  }

  factory TaskLabelModel.fromEntity(TaskLabelEntity entity) {
    return TaskLabelModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      order: entity.order,
      isFavorite: entity.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'order': order,
      'is_favorite': isFavorite,
    };
  }
}
