// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/empty_state_widget.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/priority_badge.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:intl/intl.dart';

class TaskHistoryPage extends StatefulWidget {
  const TaskHistoryPage({super.key});

  @override
  State<TaskHistoryPage> createState() => _TaskHistoryPageState();
}

class _TaskHistoryPageState extends State<TaskHistoryPage> {
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return Scaffold(
      backgroundColor: colors.background[50],
      appBar: AppBar(
        title: Text(
          appString.taskHistory,
          style: textTheme.heading.copyWith(color: colors.gray[900]),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: colors.gray[900]),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _dateRange = picked);
              }
            },
            icon: Icon(Icons.date_range, color: colors.primary[500]),
            tooltip: appString.filterByDate,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          var completedTasks = state.tasks
              .where(
                (t) => t.isCompleted ?? false,
              )
              .toList();

          if (_dateRange != null) {
            completedTasks = completedTasks.where((t) {
              final date = t.completedAt ?? t.createdAt;
              if (date == null) return false;
              return date.isAfter(_dateRange!.start) &&
                  date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
            }).toList();
          }

          if (completedTasks.isEmpty) {
            return EmptyStateWidget(
              title: appString.noCompletedTasks,
              description: appString.tasksYouCompleteWillAppearHere,
              icon: Icons.history,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: completedTasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = completedTasks[index];
              return _HistoryTaskCard(task: task);
            },
          );
        },
      ),
    );
  }
}

class _HistoryTaskCard extends StatelessWidget {
  const _HistoryTaskCard({required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.gray[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.content ?? appString.untitledTask,
                      style: textTheme.subHeading.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.gray[900],
                        decoration: TextDecoration.lineThrough,
                        decorationColor: colors.gray[400],
                      ),
                    ),
                  ],
                ),
              ),
              if (task.priority != null)
                PriorityBadge(
                  priority: task.priority!.toInt(),
                  size: PriorityBadgeSize.small,
                ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  context.read<TaskBloc>().add(TaskEvent.reopenTask(task.id!));
                },
                icon: Icon(Icons.refresh, size: 16, color: colors.primary[500]),
                label: Text(
                  appString.reopenTask,
                  style: textTheme.caption.copyWith(
                    color: colors.primary[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (task.description != null) ...[
            Text(
              task.description!,
              style: textTheme.body.copyWith(color: colors.gray[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: colors.success[500]),
              const SizedBox(width: 4),
              Text(
                '${appString.completedOn} ${task.completedAt != null ? DateFormat('MMM dd, HH:mm').format(task.completedAt!) : ''}',
                style: textTheme.caption.copyWith(color: colors.success[700]),
              ),
            ],
          ),
          if ((task.timer.totalSecondsCompleted != null &&
                  task.timer.totalSecondsCompleted! > 0) ||
              (task.duration != null && task.duration!.amount != null)) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (task.timer.totalSecondsCompleted != null &&
                    task.timer.totalSecondsCompleted! > 0) ...[
                  Icon(Icons.timer_outlined, size: 16, color: colors.gray[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${appString.timeTracked}: ${_formatDuration(task.timer.totalSecondsCompleted!.toInt())}',
                    style: textTheme.caption.copyWith(color: colors.gray[700]),
                  ),
                ],
                if (task.duration != null && task.duration!.amount != null) ...[
                  if (task.timer.totalSecondsCompleted != null &&
                      task.timer.totalSecondsCompleted! > 0)
                    const SizedBox(width: 16),
                  Icon(
                    Icons.schedule_outlined,
                    size: 16,
                    color: colors.gray[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${appString.duration}: ${task.duration!.amount}${task.duration!.unit ?? ''}',
                    style: textTheme.caption.copyWith(color: colors.gray[700]),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}
