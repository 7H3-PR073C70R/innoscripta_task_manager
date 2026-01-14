import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/core/extensions/snackbar_extension.dart';
import 'package:innoscripta_task_manager/src/core/extensions/theme_extension.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/kanban_column.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_form_sheet.dart';
import 'package:innoscripta_task_manager/src/l10n/l10n.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';

class KanbanBoardPage extends StatefulWidget {
  const KanbanBoardPage({super.key});

  @override
  State<KanbanBoardPage> createState() => _KanbanBoardPageState();
}

class _KanbanBoardPageState extends State<KanbanBoardPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(
      const TaskEvent.getAllActiveTask(
        GetActiveTasksFilterEntity(),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _dragCheckTimer;
  bool _isDragging = false;
  Offset? _currentPointerPosition;

  @override
  void dispose() {
    _scrollController.dispose();
    _dragCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _createTask({TaskStatus? status}) async {
    final result = await showTaskForm(
      context,
      status: status,
    );

    if (result != null && mounted) {
      context.read<TaskBloc>().add(
        TaskEvent.createTask(result),
      );
    }
  }

  void _onTaskMoved(TaskEntity task, TaskStatus newStatus) {
    if (task.status == newStatus) return;

    final updatedTask = task.copyWith(status: newStatus);

    context.read<TaskBloc>().add(
      TaskEvent.updateTaskLocally(updatedTask),
    );
  }

  void _handleDragStarted() {
    setState(() => _isDragging = true);
    _startAutoScroll();
  }

  void _handleDragEnded() {
    setState(() => _isDragging = false);
    _dragCheckTimer?.cancel();
    _dragCheckTimer = null;
  }

  void _startAutoScroll() {
    _dragCheckTimer?.cancel();
    _dragCheckTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_isDragging || _currentPointerPosition == null) return;

      final screenWidth = MediaQuery.of(context).size.width;
      final dx = _currentPointerPosition!.dx;
      const threshold = 50.0;
      const scrollSpeed = 15.0;

      if (screenWidth >= 900) return; // Only scroll on mobile

      if (dx < threshold) {
        // Scroll Left
        if (_scrollController.hasClients) {
          final newOffset = _scrollController.offset - scrollSpeed;
          _scrollController.jumpTo(
            newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          );
        }
      } else if (dx > screenWidth - threshold) {
        // Scroll Right
        if (_scrollController.hasClients) {
          final newOffset = _scrollController.offset + scrollSpeed;
          _scrollController.jumpTo(
            newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final appString = context.l10n;

    return Listener(
      onPointerMove: (event) {
        _currentPointerPosition = event.position;
      },
      child: Scaffold(
        backgroundColor: colors.background[50],
        appBar: AppBar(
          title: Text(
            appString.appTitle,
            style: textTheme.heading.copyWith(color: colors.gray[900]),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                context.go('/history');
              },
              icon: Icon(Icons.history, color: colors.gray[700]),
              tooltip: appString.taskHistory,
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _createTask,
              icon: const Icon(Icons.add),
              label: Text(appString.addTask),
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary[500],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state.viewState.isError || state.mutationState.isError) {
              unawaited(Navigator.maybePop(context));
              context.showSnackBar(
                message:
                    state.errorMessage ?? appString.anUnexpectedErrorOccurred,
                type: SnackBarType.error,
              );
            }
            if (state.mutationState.isProcessing) {
              unawaited(context.showLoadingModal());
            }
            if (state.mutationState.isSuccess) {
              unawaited(Navigator.maybePop(context));
            }
          },
          builder: (context, state) {
            if (state.viewState.isProcessing && state.tasks.isEmpty) {
              return const Center(child: AnimatedLoader());
            }

            final activeTasks = state.tasks
                .where((t) => !(t.isCompleted ?? false))
                .toList();

            final todoTasks = activeTasks
                .where((t) => t.status == TaskStatus.todo)
                .toList();
            final inProgressTasks = activeTasks
                .where((t) => t.status == TaskStatus.inProgress)
                .toList();
            final doneTasks = activeTasks
                .where((t) => t.status == TaskStatus.done)
                .toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                // Mobile view
                if (constraints.maxWidth < 900) {
                  return _MobileKanbanBoard(
                    scrollController: _scrollController,
                    todoTasks: todoTasks,
                    inProgressTasks: inProgressTasks,
                    doneTasks: doneTasks,
                    onTaskMoved: _onTaskMoved,
                    onAddTask: (status) => _createTask(status: status),
                    onDragStarted: _handleDragStarted,
                    onDragEnded: _handleDragEnded,
                  );
                }

                // Desktop view
                return _DesktopKanbanBoard(
                  todoTasks: todoTasks,
                  inProgressTasks: inProgressTasks,
                  doneTasks: doneTasks,
                  onTaskMoved: _onTaskMoved,
                  onAddTask: (status) => _createTask(status: status),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DesktopKanbanBoard extends StatelessWidget {
  const _DesktopKanbanBoard({
    required this.todoTasks,
    required this.inProgressTasks,
    required this.doneTasks,
    required this.onTaskMoved,
    required this.onAddTask,
  });

  final List<TaskEntity> todoTasks;
  final List<TaskEntity> inProgressTasks;
  final List<TaskEntity> doneTasks;
  final void Function(TaskEntity, TaskStatus) onTaskMoved;
  final void Function(TaskStatus) onAddTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: KanbanColumn(
              title: context.l10n.toDo,
              status: TaskStatus.todo,
              tasks: todoTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.todo),
              onTaskMoved: onTaskMoved,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: KanbanColumn(
              title: context.l10n.inProgress,
              status: TaskStatus.inProgress,
              tasks: inProgressTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.inProgress),
              onTaskMoved: onTaskMoved,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: KanbanColumn(
              title: context.l10n.done,
              status: TaskStatus.done,
              tasks: doneTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.done),
              onTaskMoved: onTaskMoved,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileKanbanBoard extends StatelessWidget {
  const _MobileKanbanBoard({
    required this.todoTasks,
    required this.inProgressTasks,
    required this.doneTasks,
    required this.onTaskMoved,
    required this.onAddTask,
    required this.scrollController,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  final ScrollController scrollController;
  final List<TaskEntity> todoTasks;
  final List<TaskEntity> inProgressTasks;
  final List<TaskEntity> doneTasks;
  final void Function(TaskEntity, TaskStatus) onTaskMoved;
  final void Function(TaskStatus) onAddTask;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: KanbanColumn(
              title: context.l10n.toDo,
              status: TaskStatus.todo,
              tasks: todoTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.todo),
              onTaskMoved: onTaskMoved,
              onDragStarted: onDragStarted,
              onDragEnded: onDragEnded,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: KanbanColumn(
              title: context.l10n.inProgress,
              status: TaskStatus.inProgress,
              tasks: inProgressTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.inProgress),
              onTaskMoved: onTaskMoved,
              onDragStarted: onDragStarted,
              onDragEnded: onDragEnded,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: KanbanColumn(
              title: context.l10n.done,
              status: TaskStatus.done,
              tasks: doneTasks,
              onTaskTap: (task) => context.go('/task/${task.id}'),
              onAddTask: () => onAddTask(TaskStatus.done),
              onTaskMoved: onTaskMoved,
              onDragStarted: onDragStarted,
              onDragEnded: onDragEnded,
            ),
          ),
        ],
      ),
    );
  }
}
