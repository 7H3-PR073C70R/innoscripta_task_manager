import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innoscripta_task_manager/src/core/constants/app_spacing.dart';
import 'package:innoscripta_task_manager/src/core/enums/enums.dart';
import 'package:innoscripta_task_manager/src/core/extensions/snackbar_extension.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/create_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/get_comments_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/comment/task_comment_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/empty_state_widget.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/app_button.dart';
import 'package:innoscripta_task_manager/src/shared/wrapper/shrinkable_button.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({
    required this.taskId,
    required this.projectId,
    super.key,
  });

  final String taskId;
  final String projectId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    context.read<CommentBloc>().add(
      CommentEvent.getAllTaskComment(
        GetCommentsFilterEntity(
          projectId: '',
          taskId: widget.taskId,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final commentEntity = CreateCommentEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: widget.taskId,
      projectId: widget.projectId,
      content: content,
    );

    context.read<CommentBloc>().add(
      CommentEvent.createTaskComment(commentEntity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appString.comments,
          style: textTheme.subHeading.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.gray[900],
          ),
        ),
        AppSpacing.verticalSpaceMedium,

        _CommentInput(
          controller: _commentController,
          focusNode: _focusNode,
          isComposing: _isComposing,
          onChanged: (value) =>
              setState(() => _isComposing = value.trim().isNotEmpty),
          onCancel: () {
            _commentController.clear();
            setState(() => _isComposing = false);
          },
          onPost: _handleSubmit,
        ),

        const SizedBox(height: 16),

        Expanded(
          child: BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {
              if (state.viewState.isError || state.mutationState.isError) {
                context.showSnackBar(
                  message:
                      state.errorMessage ?? appString.anUnexpectedErrorOccurred,
                  type: SnackBarType.error,
                );
              }
              if (state.mutationState.isSuccess) {
                _commentController.clear();
                setState(() => _isComposing = false);
              }
            },
            builder: (context, state) {
              if (state.viewState.isProcessing) {
                return const Center(child: AnimatedLoader());
              }
              if (state.comments.isEmpty) {
                return SingleChildScrollView(
                  child: EmptyStateWidget(
                    title: appString.noComments,
                    description: appString.beTheFirstToComment,
                    icon: Icons.chat_bubble_outline,
                  ),
                );
              }

              return ListView.separated(
                itemCount: state.comments.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final comment = state.comments[index];
                  return _CommentItem(comment: comment);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({
    required this.controller,
    required this.focusNode,
    required this.isComposing,
    required this.onChanged,
    required this.onCancel,
    required this.onPost,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isComposing;
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;
  final VoidCallback onPost;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus ? colors.primary[300]! : colors.gray[200]!,
          width: focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: context.l10n.addComment,
              hintStyle: context.textTheme.caption.copyWith(
                color: colors.gray[400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
            onChanged: onChanged,
          ),
          if (isComposing)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colors.gray[200]!,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShrinkableButton(
                    onTap: onCancel,
                    child: Text(
                      context.l10n.cancel,
                      style: context.textTheme.body.copyWith(
                        color: colors.gray[700],
                      ),
                    ),
                  ),
                  AppSpacing.horizontalSpaceSmall,
                  BlocSelector<CommentBloc, CommentState, bool>(
                    selector: (state) {
                      return state.mutationState.isProcessing;
                    },
                    builder: (context, isProcessing) {
                      return AppButton(
                        onPressed: onPost,
                        isBusy: isProcessing,
                        text: context.l10n.postComment,
                        height: 36,
                        width: 80,
                        backgroundColor: colors.primary[500],
                        textColor: Colors.white,
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({required this.comment});

  final TaskCommentEntity comment;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.gray[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.primary[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    context.l10n.user.substring(0, 1),
                    style: textTheme.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.user,
                      style: textTheme.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.gray[900],
                      ),
                    ),
                    if (comment.postedAt != null)
                      Text(
                        DateFormat(
                          'MMM dd, yyyy • HH:mm',
                        ).format(comment.postedAt!),
                        style: textTheme.caption.copyWith(
                          color: colors.gray[600],
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<CommentBloc>().add(
                    CommentEvent.deleteTaskComment(comment.id!),
                  );
                },
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: colors.gray[500],
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content ?? '',
            style: textTheme.body.copyWith(
              color: colors.gray[800],
            ),
          ),
        ],
      ),
    );
  }
}
