import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';

class GetActiveTasksFilterModel extends GetActiveTasksFilterEntity {
  const GetActiveTasksFilterModel({
    super.projectId,
    super.sectionId,
    super.label,
    super.filter,
    super.lang,
    super.ids,
  });

  factory GetActiveTasksFilterModel.fromEntity(
    GetActiveTasksFilterEntity entity,
  ) {
    return GetActiveTasksFilterModel(
      projectId: entity.projectId,
      sectionId: entity.sectionId,
      label: entity.label,
      filter: entity.filter,
      lang: entity.lang,
      ids: entity.ids,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (projectId != null) 'project_id': projectId,
      if (sectionId != null) 'section_id': sectionId,
      if (label != null) 'label': label,
      if (filter != null) 'filter': filter,
      if (lang != null) 'lang': lang,
      if (ids != null) 'ids': ids,
    };
  }
}
