// ignore_for_file: document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/kanban_board_page.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late TaskBloc taskBloc;
  late LabelBloc labelBloc;

  setUp(() {
    taskBloc = MockTaskBloc();
    labelBloc = MockLabelBloc();

    // Default stub for LabelBloc
    when(() => labelBloc.state).thenReturn(
      const LabelState.initial(),
    );
  });

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: taskBloc),
        BlocProvider.value(value: labelBloc),
      ],
      child: const KanbanBoardPage(),
    );
  }

  group('kanban board page ...', () {
    testWidgets('renders KanbanBoardPage and shows loading indicator', (
      tester,
    ) async {
      //! Arrange
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      when(() => taskBloc.state).thenReturn(
        const TaskState.initial(viewState: ViewState.processing),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());

      //! Assert
      expect(find.byType(AnimatedLoader), findsOneWidget);
    });

    testWidgets('renders KanbanBoardPage with tasks correctly', (tester) async {
      //! Arrange
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      final tasks = [
        TestEntities.tTaskEntity.copyWith(id: '1', content: 'Task 1'),
        TestEntities.tTaskEntity.copyWith(id: '2', content: 'Task 2'),
      ];
      when(() => taskBloc.state).thenReturn(
        TaskState.initial(viewState: ViewState.success, tasks: tasks),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());
      await tester.pump();

      //! Assert
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('shows empty state description when no tasks are present', (
      tester,
    ) async {
      //! Arrange
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      when(() => taskBloc.state).thenReturn(
        const TaskState.initial(viewState: ViewState.success),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());

      //! Assert
      expect(
        find.text('Drag tasks here or create a new one'),
        findsNWidgets(3),
      );
    });
  });
}
