import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CreateTaskLabelEntity extends Equatable {
  const CreateTaskLabelEntity({
    required this.id,
    required this.name,
    this.order,
    this.color,
    this.isFavorite,
  });
  final String id;
  final String name;
  final num? order;
  final Color? color;
  final bool? isFavorite;

  @override
  List<Object?> get props => [name, order, color, isFavorite];

  CreateTaskLabelEntity copyWith({
    String? name,
    String? id,
    num? order,
    Color? color,
    bool? isFavorite,
  }) {
    return CreateTaskLabelEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
