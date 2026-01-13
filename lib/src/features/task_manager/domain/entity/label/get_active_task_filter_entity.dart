import 'package:equatable/equatable.dart';

class GetActiveTasksFilterEntity extends Equatable {
  const GetActiveTasksFilterEntity({
    this.projectId,
    this.sectionId,
    this.label,
    this.filter,
    this.lang,
    this.ids,
  });
  final String? projectId;
  final String? sectionId;
  final String? label;
  final String? filter;
  final String? lang;
  final List<num>? ids;

  @override
  List<Object?> get props => [
    projectId,
    sectionId,
    label,
    filter,
    lang,
    ids,
  ];

  GetActiveTasksFilterEntity copyWith({
    String? projectId,
    String? sectionId,
    String? label,
    String? filter,
    String? lang,
    List<num>? ids,
  }) {
    return GetActiveTasksFilterEntity(
      projectId: projectId ?? this.projectId,
      sectionId: sectionId ?? this.sectionId,
      label: label ?? this.label,
      filter: filter ?? this.filter,
      lang: lang ?? this.lang,
      ids: ids ?? this.ids,
    );
  }
}
