import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/kanban_board_page.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_detail_page.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_history_page.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const KanbanBoardPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'task/:taskId',
          builder: (BuildContext context, GoRouterState state) {
            final taskId = state.pathParameters['taskId']!;
            return TaskDetailPage(taskId: taskId);
          },
        ),
        GoRoute(
          path: 'history',
          builder: (BuildContext context, GoRouterState state) {
            return const TaskHistoryPage();
          },
        ),
      ],
    ),
  ],
);
