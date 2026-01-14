import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_status.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/kanban_column.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_card.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late LabelBloc labelBloc;

  setUp(() {
    labelBloc = MockLabelBloc();
    when(() => labelBloc.state).thenReturn(const LabelState.initial());
  });

  Widget makeTestableWidget(Widget child) {
    return BlocProvider.value(
      value: labelBloc,
      child: child,
    );
  }

  group('kanban column ...', () {
    testWidgets('renders column title and task count', (tester) async {
      //! Arrange
      final tasks = [
        TestEntities.tTaskEntity.copyWith(id: '1', content: 'Task 1'),
      ];

      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          KanbanColumn(
            title: 'To Do',
            status: TaskStatus.todo,
            tasks: tasks,
            onTaskTap: (_) {},
            onAddTask: () {},
            onTaskMoved: (_, _) {},
          ),
        ),
      );

      //! Assert
      expect(find.text('To Do'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.byType(TaskCard), findsOneWidget);
    });

    testWidgets('shows empty state when no tasks are present', (tester) async {
      //! Arrange
      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          KanbanColumn(
            title: 'In Progress',
            status: TaskStatus.inProgress,
            tasks: const [],
            onTaskTap: (_) {},
            onAddTask: () {},
            onTaskMoved: (_, _) {},
          ),
        ),
      );

      //! Assert
      expect(find.text('No tasks'), findsOneWidget);
    });

    testWidgets('triggers onAddTask when add button is pressed', (
      tester,
    ) async {
      //! Arrange
      var addPressed = false;

      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          KanbanColumn(
            title: 'Done',
            status: TaskStatus.done,
            tasks: const [],
            onTaskTap: (_) {},
            onAddTask: () => addPressed = true,
            onTaskMoved: (_, _) {},
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));

      //! Assert
      expect(addPressed, isTrue);
    });
  });
}
