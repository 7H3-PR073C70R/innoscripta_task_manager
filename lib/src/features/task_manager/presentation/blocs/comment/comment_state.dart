part of 'comment_bloc.dart';

@freezed
abstract class CommentState with _$CommentState {
  const factory CommentState.initial({
    @Default(ViewState.idle) ViewState viewState,
    @Default(ViewState.idle) ViewState mutationState,
    @Default([]) List<TaskCommentEntity> comments,
    String? errorMessage,
  }) = _Initial;
}
