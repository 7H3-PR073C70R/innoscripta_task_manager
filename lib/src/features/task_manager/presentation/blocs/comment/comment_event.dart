part of 'comment_bloc.dart';

@freezed
abstract class CommentEvent with _$CommentEvent {
  const factory CommentEvent.getAllTaskComment(
    GetCommentsFilterEntity request,
  ) = _GetAllTaskComment;
  const factory CommentEvent.saveAllTaskCommentToStorage(
    SaveAllTaskCommentToStorageParams request,
  ) = _SaveAllTaskCommentToStorage;
  const factory CommentEvent.createTaskComment(
    CreateCommentEntity request,
  ) = _CreateTaskComment;
  const factory CommentEvent.updateTaskComment(
    CreateCommentEntity request,
  ) = _UpdateTaskComment;
  const factory CommentEvent.deleteTaskComment(
    String id,
  ) = _DeleteTaskComment;
}
