import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/get_active_task_filter_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_history_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late TaskBloc taskBloc;

  setUpAll(() {
    registerFallbackValue(
      const TaskEvent.getAllActiveTask(GetActiveTasksFilterEntity()),
    );
  });

  setUp(() {
    taskBloc = MockTaskBloc();
  });

  Widget makeTestableWidget() {
    return BlocProvider.value(
      value: taskBloc,
      child: const TaskHistoryPage(),
    );
  }

  group('task history page ...', () {
    testWidgets('renders TaskHistoryPage with no completed tasks', (
      tester,
    ) async {
      //! Arrange
      when(() => taskBloc.state).thenReturn(
        const TaskState.initial(viewState: ViewState.success),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());

      //! Assert
      expect(find.text('No completed tasks'), findsOneWidget);
    });

    testWidgets('renders TaskHistoryPage with completed tasks', (tester) async {
      //! Arrange
      final tasks = [
        TestEntities.tTaskEntity.copyWith(
          id: '1',
          content: 'Completed Task 1',
          isCompleted: true,
        ),
      ];
      when(() => taskBloc.state).thenReturn(
        TaskState.initial(viewState: ViewState.success, tasks: tasks),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());

      //! Assert
      expect(find.text('Completed Task 1'), findsOneWidget);
    });

    testWidgets('triggers reopenTask when reopen button is pressed', (
      tester,
    ) async {
      //! Arrange
      final tasks = [
        TestEntities.tTaskEntity.copyWith(
          id: '1',
          content: 'Completed Task 1',
          isCompleted: true,
        ),
      ];
      when(() => taskBloc.state).thenReturn(
        TaskState.initial(viewState: ViewState.success, tasks: tasks),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget());
      await tester.tap(find.text('Reopen Task'));

      //! Assert
      verify(() => taskBloc.add(any())).called(1);
    });
  });
}
