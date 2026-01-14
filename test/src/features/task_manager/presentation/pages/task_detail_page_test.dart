import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_detail_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

void main() {
  late TaskBloc taskBloc;
  late CommentBloc commentBloc;
  late LabelBloc labelBloc;

  setUp(() {
    taskBloc = MockTaskBloc();
    commentBloc = MockCommentBloc();
    labelBloc = MockLabelBloc();

    when(() => labelBloc.state).thenReturn(const LabelState.initial());
    when(() => commentBloc.state).thenReturn(const CommentState.initial());
  });

  Widget makeTestableWidget(String taskId) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: taskBloc),
        BlocProvider.value(value: commentBloc),
        BlocProvider.value(value: labelBloc),
      ],
      child: TaskDetailPage(taskId: taskId),
    );
  }

  group('task detail page ...', () {
    testWidgets('renders task details correctly', (tester) async {
      //! Arrange
      final task = TestEntities.tTaskEntity.copyWith(
        id: '1',
        content: 'Detail Task',
        description: 'Detail Description',
      );
      when(() => taskBloc.state).thenReturn(
        TaskState.initial(viewState: ViewState.success, tasks: [task]),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget('1'));

      //! Assert
      expect(find.text('Detail Task'), findsOneWidget);
      expect(find.text('Detail Description'), findsOneWidget);
    });

    testWidgets('shows task not found when task id is missing', (tester) async {
      //! Arrange
      when(() => taskBloc.state).thenReturn(
        const TaskState.initial(viewState: ViewState.success),
      );

      //! Act
      await tester.pumpApp(makeTestableWidget('NON_EXISTENT'));

      //! Assert
      expect(find.text('Task not found'), findsOneWidget);
    });
  });
}
