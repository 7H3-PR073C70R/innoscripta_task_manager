import 'dart:convert';

import 'package:innoscripta_task_manager/src/core/constants/pref_keys.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/comment/task_comment_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/label/task_label_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/data/models/task/task_model.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/services/local_storage_service.dart';

abstract interface class TaskManagerLocalDataSource {
  //! Task
  Future<List<TaskEntity>> getAllActiveTaskFromStorage();

  Future<void> saveAllTaskToStorage(
    List<TaskEntity> request,
  );

  //! Task-Label
  Future<List<TaskLabelEntity>> getAllTaskLabelFromStorage();

  Future<void> saveAllTaskLabelToStorage(
    List<TaskLabelEntity> request,
  );

  //! Task-Comment
  Future<List<TaskCommentEntity>> getAllTaskCommentFromStorage(String taskID);

  Future<void> saveAllTaskCommentToStorage({
    required List<TaskCommentEntity> taskComment,
    required String taskID,
  });
}

class TaskManagerLocalDataSourceImpl implements TaskManagerLocalDataSource {
  const TaskManagerLocalDataSourceImpl(this._localStorageService);
  final LocalStorageService _localStorageService;

  //! Task Logic
  @override
  Future<List<TaskEntity>> getAllActiveTaskFromStorage() async {
    final jsonString = _localStorageService.getPreference(key: PrefKeys.tasks);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAllTaskToStorage(List<TaskEntity> request) async {
    final jsonList = request
        .map((e) => TaskModel.fromEntity(e).toJson())
        .toList();
    await _localStorageService.savePreference(
      key: PrefKeys.tasks,
      data: jsonEncode(jsonList),
    );
  }

  //! Task-Label Logic
  @override
  Future<List<TaskLabelEntity>> getAllTaskLabelFromStorage() async {
    final jsonString = _localStorageService.getPreference(key: PrefKeys.labels);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((e) => TaskLabelModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAllTaskLabelToStorage(List<TaskLabelEntity> request) async {
    final jsonList = request
        .map((e) => TaskLabelModel.fromEntity(e).toJson())
        .toList();
    await _localStorageService.savePreference(
      key: PrefKeys.labels,
      data: jsonEncode(jsonList),
    );
  }

  //! Task-Comment (Per ID Storage)
  @override
  Future<List<TaskCommentEntity>> getAllTaskCommentFromStorage(
    String taskID,
  ) async {
    final jsonString = _localStorageService.getPreference(
      key: '${PrefKeys.comments}_$taskID',
    );
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => TaskCommentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAllTaskCommentToStorage({
    required List<TaskCommentEntity> taskComment,
    required String taskID,
  }) async {
    final jsonList = taskComment
        .map((e) => TaskCommentModel.fromEntity(e).toJson())
        .toList();
    await _localStorageService.savePreference(
      key: '${PrefKeys.comments}_$taskID',
      data: jsonEncode(jsonList),
    );
  }
}
