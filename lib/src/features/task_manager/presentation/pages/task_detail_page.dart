import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/extensions/snackbar_extension.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';

import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/comment_section.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/priority_badge.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_form_sheet.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_labels.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_timer_widget.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({
    required this.taskId,
    super.key,
  });

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final appString = context.l10n;

    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.mutationState.isSuccess) {
          context.showSnackBar(
            message: appString.actionPerformedSuccessfully,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pop();
          });
        }
      },
      builder: (context, state) {
        final task = state.tasks.firstWhere(
          (t) => t.id == taskId,
          orElse: () => const TaskEntity(
            timer: TaskTimer(),
            status: TaskStatus.todo,
          ),
        );

        if (task.id == null) {
          return Scaffold(
            body: Center(child: Text(appString.taskNotFound)),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: colors.gray[900]),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await showTaskForm(context, task: task);
                  if (result != null && context.mounted) {
                    context.read<TaskBloc>().add(
                      TaskEvent.updateTask(result),
                    );
                  }
                },
                icon: Icon(Icons.edit_outlined, color: colors.gray[700]),
              ),
              IconButton(
                onPressed: () {
                  context.read<TaskBloc>().add(
                    TaskEvent.deleteTask(taskId),
                  );
                },
                icon: Icon(Icons.delete_outline, color: colors.error[500]),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(task: task),
                const SizedBox(height: 24),
                _DescriptionSection(task: task),
                const SizedBox(height: 32),
                SizedBox(
                  height: 400,
                  child: CommentSection(
                    taskId: task.id!,
                    projectId: task.projectId ?? 'default',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (task.id != null)
                        GestureDetector(
                          onTap: () {
                            if (task.status == TaskStatus.done) {
                              context.read<TaskBloc>().add(
                                TaskEvent.reopenTask(task.id!),
                              );
                            } else {
                              context.read<TaskBloc>().add(
                                TaskEvent.closeTask(task.id!),
                              );
                            }
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: task.status == TaskStatus.done
                                    ? colors.success[500]!
                                    : colors.gray[300]!,
                                width: 2,
                              ),
                              color: task.isCompleted ?? false
                                  ? colors.success[500]
                                  : Colors.transparent,
                            ),
                            child: task.status == TaskStatus.done
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(width: 12),
                      Expanded(child: TaskLabels(labelIds: task.labels)),
                      const SizedBox(width: 12),
                      if (task.priority != null)
                        PriorityBadge(priority: task.priority!.toInt()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.content ?? '',
                    style: textTheme.heading.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.gray[900],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            TaskTimerWidget(
              compact: true,
              timer: task.timer,
              onStart: () {
                final newTimer = task.timer.copyWith(
                  startTime: DateTime.now(),
                  isRunning: true,
                );
                context.read<TaskBloc>().add(
                  TaskEvent.updateTaskLocally(
                    task.copyWith(timer: newTimer),
                  ),
                );
              },
              onStop: () {
                final now = DateTime.now();
                final startTime = task.timer.startTime ?? now;
                final elapsed = now.difference(startTime).inSeconds;
                final total = (task.timer.totalSecondsCompleted ?? 0) + elapsed;

                final newTimer = task.timer.copyWith(
                  isRunning: false,
                  totalSecondsCompleted: total,
                );
                context.read<TaskBloc>().add(
                  TaskEvent.updateTaskLocally(
                    task.copyWith(timer: newTimer),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    if (task.description == null || task.description!.isEmpty) {
      return Text(
        context.l10n.noDescription,
        style: textTheme.body.copyWith(
          fontStyle: FontStyle.italic,
          color: colors.gray[500],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.taskDescription,
          style: textTheme.subHeading.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.gray[900],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          task.description!,
          style: textTheme.body.copyWith(
            color: colors.gray[800],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
