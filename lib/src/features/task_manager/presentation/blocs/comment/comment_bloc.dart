import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/di/locator.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/create_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/delete_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_from_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/get_all_task_comment_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/save_all_task_comment_to_storage_use_case.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/use_cases/update_task_comment_use_case.dart';

part 'comment_event.dart';
part 'comment_state.dart';
part 'comment_bloc.freezed.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({
    GetAllTaskCommentUseCase? getAllTaskCommentUseCase,
    GetAllTaskCommentFromStorageUseCase? getAllTaskCommentFromStorageUseCase,
    SaveAllTaskCommentToStorageUseCase? saveAllTaskCommentToStorageUseCase,
    CreateTaskCommentUseCase? createTaskCommentUseCase,
    UpdateTaskCommentUseCase? updateTaskCommentUseCase,
    DeleteTaskCommentUseCase? deleteTaskCommentUseCase,
  }) : _getAllTaskCommentUseCase = getAllTaskCommentUseCase ?? locator(),
       _getAllTaskCommentFromStorageUseCase =
           getAllTaskCommentFromStorageUseCase ?? locator(),
       _saveAllTaskCommentToStorageUseCase =
           saveAllTaskCommentToStorageUseCase ?? locator(),
       _createTaskCommentUseCase = createTaskCommentUseCase ?? locator(),
       _updateTaskCommentUseCase = updateTaskCommentUseCase ?? locator(),
       _deleteTaskCommentUseCase = deleteTaskCommentUseCase ?? locator(),
       super(const _Initial()) {
    on<_GetAllTaskComment>(_onGetAllTaskComment);
    on<_SaveAllTaskCommentToStorage>(_onSaveAllTaskCommentToStorage);
    on<_CreateTaskComment>(_onCreateTaskComment);
    on<_UpdateTaskComment>(_onUpdateTaskComment);
    on<_DeleteTaskComment>(_onDeleteTaskComment);
  }

  final GetAllTaskCommentUseCase _getAllTaskCommentUseCase;
  final GetAllTaskCommentFromStorageUseCase
  _getAllTaskCommentFromStorageUseCase;
  final SaveAllTaskCommentToStorageUseCase _saveAllTaskCommentToStorageUseCase;
  final CreateTaskCommentUseCase _createTaskCommentUseCase;
  final UpdateTaskCommentUseCase _updateTaskCommentUseCase;
  final DeleteTaskCommentUseCase _deleteTaskCommentUseCase;

  FutureOr<void> _onGetAllTaskComment(
    _GetAllTaskComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.viewState.isProcessing) return;

    emit(state.copyWith(viewState: ViewState.processing));

    final result = await _getAllTaskCommentUseCase(event.request);

    await result.fold(
      (error) async {
        final commentsFromStorage = await _fetchAllTaskCommentsFromStorage(
          event.request.taskId,
        );
        emit(
          state.copyWith(
            viewState: ViewState.error,
            comments: commentsFromStorage,
            errorMessage: error.message,
          ),
        );
      },
      (comments) {
        add(
          _SaveAllTaskCommentToStorage(
            SaveAllTaskCommentToStorageParams(
              taskComment: comments,
              taskID: event.request.taskId,
            ),
          ),
        );
        emit(
          state.copyWith(
            viewState: ViewState.success,
            comments: comments,
          ),
        );
      },
    );

    emit(state.copyWith(viewState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onSaveAllTaskCommentToStorage(
    _SaveAllTaskCommentToStorage event,
    Emitter<CommentState> emit,
  ) async {
    await _saveAllTaskCommentToStorageUseCase(event.request);
  }

  FutureOr<void> _onCreateTaskComment(
    _CreateTaskComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _createTaskCommentUseCase(event.request);

    result.fold(
      (error) => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (comment) {
        final updatedComments = [comment, ...state.comments];
        add(
          _SaveAllTaskCommentToStorage(
            SaveAllTaskCommentToStorageParams(
              taskComment: updatedComments,
              taskID: event.request.taskId,
            ),
          ),
        );
        emit(
          state.copyWith(
            mutationState: ViewState.success,
            comments: updatedComments,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onUpdateTaskComment(
    _UpdateTaskComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _updateTaskCommentUseCase(event.request);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (updatedComment) async {
        // Compute for isolated list manipulation
        final updatedComments = await compute(_updateListWithTaskComment, {
          'comments': [...state.comments],
          'updatedComment': updatedComment,
        });

        add(
          _SaveAllTaskCommentToStorage(
            SaveAllTaskCommentToStorageParams(
              taskComment: updatedComments,
              taskID: event.request.taskId,
            ),
          ),
        );

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            comments: updatedComments,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  FutureOr<void> _onDeleteTaskComment(
    _DeleteTaskComment event,
    Emitter<CommentState> emit,
  ) async {
    if (state.mutationState.isProcessing) return;

    emit(state.copyWith(mutationState: ViewState.processing));

    final result = await _deleteTaskCommentUseCase(event.id);

    await result.fold(
      (error) async => emit(
        state.copyWith(
          mutationState: ViewState.error,
          errorMessage: error.message,
        ),
      ),
      (_) async {
        // Compute for isolated list manipulation
        final updatedComments = await compute(_removeItemFromList, {
          'comments': [...state.comments],
          'id': event.id,
        });

        add(
          _SaveAllTaskCommentToStorage(
            SaveAllTaskCommentToStorageParams(
              taskComment: updatedComments,
              taskID: event.id,
            ),
          ),
        );

        emit(
          state.copyWith(
            mutationState: ViewState.success,
            comments: updatedComments,
          ),
        );
      },
    );

    emit(state.copyWith(mutationState: ViewState.idle, errorMessage: null));
  }

  Future<List<TaskCommentEntity>> _fetchAllTaskCommentsFromStorage(
    String taskId,
  ) async {
    final result = await _getAllTaskCommentFromStorageUseCase(
      taskId,
    );
    return result.fold((_) => [], (comments) => comments);
  }
}

/// Isolated function to update a comment in a large list
List<TaskCommentEntity> _updateListWithTaskComment(
  Map<String, dynamic> message,
) {
  final comments = List<TaskCommentEntity>.from(
    message['comments'] as List<TaskCommentEntity>,
  );
  final updatedComment = message['updatedComment'] as TaskCommentEntity;

  final index = comments.indexWhere((c) => c.id == updatedComment.id);
  if (index != -1) {
    comments[index] = updatedComment;
  }
  return comments;
}

/// Isolated function to remove a comment from a large list
List<TaskCommentEntity> _removeItemFromList(Map<String, dynamic> message) {
  final comments = List<TaskCommentEntity>.from(
    message['comments'] as List<TaskCommentEntity>,
  );
  final id = message['id'] as String;

  final index = comments.indexWhere((c) => c.id == id);
  if (index != -1) {
    comments.removeAt(index);
  }
  return comments;
}
