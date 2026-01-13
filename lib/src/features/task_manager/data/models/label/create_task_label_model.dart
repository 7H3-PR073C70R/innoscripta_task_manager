import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';

class CreateTaskLabelModel extends CreateTaskLabelEntity {
  const CreateTaskLabelModel({
    required super.name,
    required super.id,
    super.order,
    super.color,
    super.isFavorite,
  });

  factory CreateTaskLabelModel.fromEntity(CreateTaskLabelEntity entity) {
    return CreateTaskLabelModel(
      name: entity.name,
      order: entity.order,
      color: entity.color,
      isFavorite: entity.isFavorite,
      id: entity.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (order != null) 'order': order,
      if (color != null)
        'color': '0x${color!.toARGB32().toRadixString(16).padLeft(8, '0')}',
      if (isFavorite != null) 'is_favorite': isFavorite,
    };
  }
}
