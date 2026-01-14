import 'package:flutter/material.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/core/themes/color/app_theme_colors.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/empty_state_widget.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_card.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';

class KanbanColumn extends StatefulWidget {
  const KanbanColumn({
    required this.title,
    required this.status,
    required this.tasks,
    required this.onTaskTap,
    required this.onAddTask,
    required this.onTaskMoved,
    this.onTimerStart,
    this.onTimerStop,
    this.color,
    this.onDragStarted,
    this.onDragEnded,
    super.key,
  });

  final String title;
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final void Function(TaskEntity) onTaskTap;
  final VoidCallback onAddTask;
  final void Function(TaskEntity, TaskStatus) onTaskMoved;
  final void Function(TaskEntity)? onTimerStart;
  final void Function(TaskEntity)? onTimerStop;
  final Color? color;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnded;

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final columnColor = widget.color ?? _getColumnColor(colors);

    return DragTarget<TaskEntity>(
      onWillAcceptWithDetails: (details) {
        return details.data.status != widget.status;
      },
      onAcceptWithDetails: (details) {
        widget.onTaskMoved(details.data, widget.status);
        setState(() => _isDragOver = false);
      },
      onMove: (_) {
        if (!_isDragOver) {
          setState(() => _isDragOver = true);
        }
      },
      onLeave: (_) {
        setState(() => _isDragOver = false);
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isDragOver
                ? columnColor.withValues(alpha: 0.05)
                : colors.background[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isDragOver ? columnColor : colors.gray[200]!,
              width: _isDragOver ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _KanbanColumnHeader(
                title: widget.title,
                taskCount: widget.tasks.length,
                columnColor: columnColor,
                onAddTask: widget.onAddTask,
              ),
              Expanded(
                child: widget.tasks.isEmpty
                    ? const _KanbanEmptyState()
                    : _KanbanTaskList(
                        tasks: widget.tasks,
                        onTaskTap: widget.onTaskTap,
                        onTimerStart: widget.onTimerStart,
                        onTimerStop: widget.onTimerStop,
                        onDragStarted: widget.onDragStarted,
                        onDragEnded: widget.onDragEnded,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColumnColor(AppThemeColors colors) {
    return switch (widget.status) {
      TaskStatus.todo => colors.warning[500]!,
      TaskStatus.inProgress => colors.primary[500]!,
      TaskStatus.done => colors.success[500]!,
    };
  }
}

class _KanbanColumnHeader extends StatelessWidget {
  const _KanbanColumnHeader({
    required this.title,
    required this.taskCount,
    required this.columnColor,
    required this.onAddTask,
  });

  final String title;
  final int taskCount;
  final Color columnColor;
  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.gray[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: columnColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: textTheme.subHeading.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.gray[900],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.gray[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$taskCount',
              style: textTheme.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.gray[700],
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onAddTask,
            icon: Icon(
              Icons.add,
              color: colors.gray[600],
            ),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: context.l10n.addTask,
          ),
        ],
      ),
    );
  }
}

class _KanbanTaskList extends StatelessWidget {
  const _KanbanTaskList({
    required this.tasks,
    required this.onTaskTap,
    this.onTimerStart,
    this.onTimerStop,
    this.onDragStarted,
    this.onDragEnded,
  });

  final List<TaskEntity> tasks;
  final void Function(TaskEntity) onTaskTap;
  final void Function(TaskEntity)? onTimerStart;
  final void Function(TaskEntity)? onTimerStop;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnded;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Draggable<TaskEntity>(
          data: task,
          onDragStarted: onDragStarted,
          onDragEnd: (_) => onDragEnded?.call(),
          feedback: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 300,
              child: Opacity(
                opacity: 0.8,
                child: TaskCard(
                  task: task,
                  onTap: () {},
                ),
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: TaskCard(
              task: task,
              onTap: () {},
            ),
          ),
          child: TaskCard(
            task: task,
            onTap: () => onTaskTap(task),
            onTimerStart: onTimerStart != null
                ? () => onTimerStart!(task)
                : null,
            onTimerStop: onTimerStop != null ? () => onTimerStop!(task) : null,
          ),
        );
      },
    );
  }
}

class _KanbanEmptyState extends StatelessWidget {
  const _KanbanEmptyState();

  @override
  Widget build(BuildContext context) {
    final appString = context.l10n;
    return EmptyStateWidget(
      title: appString.noTasks,
      description: appString.dragTasksDescription,
      icon: Icons.inbox_outlined,
    );
  }
}
