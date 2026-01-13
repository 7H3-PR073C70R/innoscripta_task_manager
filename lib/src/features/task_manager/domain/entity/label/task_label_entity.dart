import 'package:equatable/equatable.dart';

class TaskLabelEntity extends Equatable {
  const TaskLabelEntity({
    this.id,
    this.name,
    this.color,
    this.order,
    this.isFavorite,
  });
  final String? id;
  final String? name;
  final String? color;
  final num? order;
  final bool? isFavorite;

  @override
  List<Object?> get props => [id, name, color, order, isFavorite];

  TaskLabelEntity copyWith({
    String? id,
    String? name,
    String? color,
    num? order,
    bool? isFavorite,
  }) {
    return TaskLabelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      order: order ?? this.order,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
