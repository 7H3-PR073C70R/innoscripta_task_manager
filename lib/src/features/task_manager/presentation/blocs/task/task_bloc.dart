import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/di/locator.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/create_task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_active_task_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';
part 'task_bloc.freezed.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    GetAllActiveTaskUseCase? getAllActiveTaskUseCase,
    GetAllActiveTaskFromStorageUseCase? getAllActiveTaskFromStorageUseCase,
    SaveAllTaskToStorageUseCase? saveAllTaskToStorageUseCase,
    CreateTaskUseCase? createTaskUseCase,
    UpdateTaskUseCase? updateTaskUseCase,
    DeleteTaskUseCase? deleteUseCase,
  }) : _getAllActiveTaskUseCase = getAllActiveTaskUseCase ?? locator(),
       _getAllActiveTaskFromStorageUseCase =
           getAllActiveTaskFromStorageUseCase ?? locator(),
       _saveAllTaskToStorageUseCase = saveAllTaskToStorageUseCase ?? locator(),
       _createTaskUseCase = createTaskUseCase ?? locator(),
       _updateTaskUseCase = updateTaskUseCase ?? locator(),
       _deleteTaskUseCase = deleteUseCase ?? locator(),
       super(const _Initial()) {
    on<_GetAllActiveTask>(_onGetAllActiveTask);
    on<_SaveAllTaskToStorage>(_onSaveAllTaskToStorage);
    on<_CreateTask>(_onCreateTask);
    on<_UpdateTask>(_onUpdateTask);
    on<_DeleteTask>(_onDeleteTask);
  }

  final GetAllActiveTaskUseCase _getAllActiveTaskUseCase;
  final GetAllActiveTaskFromStorageUseCase _getAllActiveTaskFromStorageUseCase;
  final SaveAllTaskToStorageUseCase _saveAllTaskToStorageUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  FutureOr<void> _onGetAllActiveTask(
    _GetAllActiveTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state.viewState.isProcessing) return;

    emit(state.copyWith(viewState: ViewState.processing));

    final result = await _getAllActiveTaskUseCase(event.request);

    await result.fold(
      (error) async {
        final taskFromStorage = await _fetchAllTasksFromStorage();
        emit(
          state.copyWith(
            viewState: ViewState.error,
            tasks: taskFromStorage,
            errorMessage: error.message,
          ),
        );
      },
      (tasks) {
        add(_SaveAllTaskToStorage(tasks));
        emit(
          state.copyWith(
            viewState: ViewState.success,
            tasks: tasks,
          ),
        );
      },
    );

    emit(state.copyWith(viewState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onSaveAllTaskToStorage(
    _SaveAllTaskToStorage event,
    Emitter<TaskState> emit,
  ) async {
    await _saveAllTaskToStorageUseCase(event.tasks);
  }

  FutureOr<void> _onCreateTask(
    _CreateTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _createTaskUseCase(event.request);

    result.fold(
      (error) => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (task) {
        final updatedTasks = [task, ...state.tasks];
        add(_SaveAllTaskToStorage(updatedTasks));
        emit(
          state.copyWith(
            mutationState: ViewState.success,
            tasks: updatedTasks,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onUpdateTask(
    _UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _updateTaskUseCase(event.request);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (updatedTask) async {
        // Compute for isolated list manipulation
        final updatedTasks = await compute(_updateListWithTask, {
          'tasks': [...state.tasks],
          'updatedTask': updatedTask,
        });

        add(_SaveAllTaskToStorage(updatedTasks));

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            tasks: updatedTasks,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onDeleteTask(
    _DeleteTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _deleteTaskUseCase(event.id);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (_) async {
        // Compute for isolated list manipulation
        final updatedTasks = await compute(_removeItemFromList, {
          'tasks': [...state.tasks],
          'id': event.id,
        });

        add(_SaveAllTaskToStorage(updatedTasks));

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            tasks: updatedTasks,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  Future<List<TaskEntity>> _fetchAllTasksFromStorage() async {
    final result = await _getAllActiveTaskFromStorageUseCase(const NoParams());
    return result.fold((_) => [], (tasks) => tasks);
  }
}

/// Isolated function to update a task in a large list
List<TaskEntity> _updateListWithTask(Map<String, dynamic> message) {
  final tasks = List<TaskEntity>.from(message['tasks'] as List<TaskEntity>);
  final updatedTask = message['updatedTask'] as TaskEntity;

  final index = tasks.indexWhere((t) => t.id == updatedTask.id);
  if (index != -1) {
    tasks[index] = updatedTask;
  }
  return tasks;
}

/// Isolated function to remove a task from a large list
List<TaskEntity> _removeItemFromList(Map<String, dynamic> message) {
  final tasks = List<TaskEntity>.from(message['tasks'] as List<TaskEntity>);
  final id = message['id'] as String;

  final index = tasks.indexWhere((t) => t.id == id);
  if (index != -1) {
    tasks.removeAt(index);
  }
  return tasks;
}
