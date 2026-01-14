import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/utils/use_case.dart';
import 'package:innoscripta_task_manager/src/di/locator.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/create_task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/label/task_label_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_label_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_label_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_label_use_case.dart';

part 'label_event.dart';
part 'label_state.dart';
part 'label_bloc.freezed.dart';

class LabelBloc extends Bloc<LabelEvent, LabelState> {
  LabelBloc({
    GetAllTaskLabelUseCase? getAllTaskLabelUseCase,
    GetAllTaskLabelFromStorageUseCase? getAllTaskLabelFromStorageUseCase,
    SaveAllTaskLabelToStorageUseCase? saveAllTaskLabelToStorageUseCase,
    CreateTaskLabelUseCase? createTaskLabelUseCase,
    UpdateTaskLabelUseCase? updateTaskLabelUseCase,
    DeleteTaskLabelUseCase? deleteTaskLabelUseCase,
  }) : _getAllTaskLabelUseCase = getAllTaskLabelUseCase ?? locator(),
       _getAllTaskLabelFromStorageUseCase =
           getAllTaskLabelFromStorageUseCase ?? locator(),
       _saveAllTaskLabelToStorageUseCase =
           saveAllTaskLabelToStorageUseCase ?? locator(),
       _createTaskLabelUseCase = createTaskLabelUseCase ?? locator(),
       _updateTaskLabelUseCase = updateTaskLabelUseCase ?? locator(),
       _deleteTaskLabelUseCase = deleteTaskLabelUseCase ?? locator(),
       super(const _Initial()) {
    on<_GetAllTaskLabel>(_onGetAllTaskLabel);
    on<_SaveAllTaskLabelToStorage>(_onSaveAllTaskLabelToStorage);
    on<_CreateTaskLabel>(_onCreateTaskLabel);
    on<_UpdateTaskLabel>(_onUpdateTaskLabel);
    on<_DeleteTaskLabel>(_onDeleteTaskLabel);
  }

  final GetAllTaskLabelUseCase _getAllTaskLabelUseCase;
  final GetAllTaskLabelFromStorageUseCase _getAllTaskLabelFromStorageUseCase;
  final SaveAllTaskLabelToStorageUseCase _saveAllTaskLabelToStorageUseCase;
  final CreateTaskLabelUseCase _createTaskLabelUseCase;
  final UpdateTaskLabelUseCase _updateTaskLabelUseCase;
  final DeleteTaskLabelUseCase _deleteTaskLabelUseCase;

  FutureOr<void> _onGetAllTaskLabel(
    _GetAllTaskLabel event,
    Emitter<LabelState> emit,
  ) async {
    if (state.viewState.isProcessing) return;

    emit(state.copyWith(viewState: ViewState.processing));

    final result = await _getAllTaskLabelUseCase(const NoParams());

    await result.fold(
      (error) async {
        final labelsFromStorage = await _fetchAllTaskLabelsFromStorage();
        emit(
          state.copyWith(
            viewState: ViewState.error,
            labels: labelsFromStorage,
            errorMessage: error.message,
          ),
        );
      },
      (labels) {
        add(_SaveAllTaskLabelToStorage(labels));
        emit(
          state.copyWith(
            viewState: ViewState.success,
            labels: labels,
          ),
        );
      },
    );

    emit(state.copyWith(viewState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onSaveAllTaskLabelToStorage(
    _SaveAllTaskLabelToStorage event,
    Emitter<LabelState> emit,
  ) async {
    await _saveAllTaskLabelToStorageUseCase(event.labels);
  }

  FutureOr<void> _onCreateTaskLabel(
    _CreateTaskLabel event,
    Emitter<LabelState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _createTaskLabelUseCase(event.request);

    result.fold(
      (error) => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (label) {
        final updatedLabels = [label, ...state.labels];
        add(_SaveAllTaskLabelToStorage(updatedLabels));
        emit(
          state.copyWith(
            mutationState: ViewState.success,
            labels: updatedLabels,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onUpdateTaskLabel(
    _UpdateTaskLabel event,
    Emitter<LabelState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _updateTaskLabelUseCase(event.request);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (updatedLabel) async {
        // Compute for isolated list manipulation
        final updatedLabels = await compute(_updateListWithTaskLabel, {
          'labels': [...state.labels],
          'updatedLabel': updatedLabel,
        });

        add(_SaveAllTaskLabelToStorage(updatedLabels));

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            labels: updatedLabels,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onDeleteTaskLabel(
    _DeleteTaskLabel event,
    Emitter<LabelState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _deleteTaskLabelUseCase(event.id);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (_) async {
        // Compute for isolated list manipulation
        final updatedLabels = await compute(_removeItemFromList, {
          'labels': [...state.labels],
          'id': event.id,
        });

        add(_SaveAllTaskLabelToStorage(updatedLabels));

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            labels: updatedLabels,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  Future<List<TaskLabelEntity>> _fetchAllTaskLabelsFromStorage() async {
    final result = await _getAllTaskLabelFromStorageUseCase(const NoParams());
    return result.fold((_) => [], (labels) => labels);
  }
}

/// Isolated function to update a label in a large list
List<TaskLabelEntity> _updateListWithTaskLabel(Map<String, dynamic> message) {
  final labels = List<TaskLabelEntity>.from(
    message['labels'] as List<TaskLabelEntity>,
  );
  final updatedLabel = message['updatedLabel'] as TaskLabelEntity;

  final index = labels.indexWhere((l) => l.id == updatedLabel.id);
  if (index != -1) {
    labels[index] = updatedLabel;
  }
  return labels;
}

/// Isolated function to remove a label from a large list
List<TaskLabelEntity> _removeItemFromList(Map<String, dynamic> message) {
  final labels = List<TaskLabelEntity>.from(
    message['labels'] as List<TaskLabelEntity>,
  );
  final id = message['id'] as String;

  final index = labels.indexWhere((l) => l.id == id);
  if (index != -1) {
    labels.removeAt(index);
  }
  return labels;
}
