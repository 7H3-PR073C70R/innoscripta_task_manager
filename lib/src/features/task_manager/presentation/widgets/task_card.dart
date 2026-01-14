import 'package:flutter/material.dart';

import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/priority_badge.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_labels.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_timer_widget.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:intl/intl.dart';


class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.onTap,
    this.onTimerStart,
    this.onTimerStop,
    super.key,
  });

  final TaskEntity task;
  final VoidCallback onTap;
  final VoidCallback? onTimerStart;
  final VoidCallback? onTimerStop;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.surface[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? colors.primary[300]! : colors.gray[200]!,
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: colors.primary[100]!.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: colors.gray[200]!.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TaskLabels(labelIds: widget.task.labels),
                  const SizedBox(height: 8),

                  Text(
                    widget.task.content ?? context.l10n.untitledTask,
                    style: textTheme.taskTitle.copyWith(
                      color: colors.gray[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (widget.task.description != null &&
                      widget.task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.task.description!,
                      style: textTheme.body.copyWith(
                        fontSize: 12,
                        color: colors.gray[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  if (widget.task.assigneeId != null) ...[
                    Row(
                      children: [
                        Text(
                          context.l10n.assigneesLabel,
                          style: textTheme.caption.copyWith(
                            color: colors.gray[600],
                          ),
                        ),
                        const SizedBox(width: 4),
                        const _AssigneeAvatars(),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  Row(
                    children: [
                      if (widget.task.due?.date != null) ...[
                        _DueDateLabel(dueDate: widget.task.due!.date!),
                        const SizedBox(width: 8),
                      ],
                      if (widget.task.priority != null &&
                          widget.task.priority! <= 3)
                        PriorityBadge(
                          priority: widget.task.priority!.toInt(),
                          size: PriorityBadgeSize.small,
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  _TaskCardFooter(
                    task: widget.task,
                    onTimerStart: widget.onTimerStart,
                    onTimerStop: widget.onTimerStop,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssigneeAvatars extends StatelessWidget {
  const _AssigneeAvatars();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: colors.primary[100],
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.surface[50]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              'A',
              style: textTheme.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.primary[700],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DueDateLabel extends StatelessWidget {
  const _DueDateLabel({required this.dueDate});

  final DateTime dueDate;

  bool _isDueSoon() {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    return difference.inDays <= 2 && difference.inDays >= 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final dueSoon = _isDueSoon();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.calendar_today,
          size: 12,
          color: dueSoon ? colors.error[500] : colors.gray[500],
        ),
        const SizedBox(width: 4),
        Text(
          DateFormat('MMM dd').format(dueDate),
          style: textTheme.caption.copyWith(
            fontSize: 11,
            color: dueSoon ? colors.error[700] : colors.gray[700],
            fontWeight: dueSoon ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _TaskCardFooter extends StatelessWidget {
  const _TaskCardFooter({
    required this.task,
    this.onTimerStart,
    this.onTimerStop,
  });

  final TaskEntity task;
  final VoidCallback? onTimerStart;
  final VoidCallback? onTimerStop;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Row(
      children: [
        if (task.duration != null) ...[
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: colors.gray[500],
          ),
          const SizedBox(width: 4),
          Text(
            '${task.duration!.amount}${task.duration!.unit?.substring(0, 1)}',
            style: textTheme.caption.copyWith(
              color: colors.gray[700],
            ),
          ),
          const SizedBox(width: 12),
        ],

        const Spacer(),

        if (task.timer.totalSecondsCompleted! > 0 ||
            (task.timer.isRunning ?? false))
          TaskTimerWidget(
            timer: task.timer,
            onStart: onTimerStart ?? () {},
            onStop: onTimerStop ?? () {},
            compact: true,
          ),
      ],
    );
  }
}
