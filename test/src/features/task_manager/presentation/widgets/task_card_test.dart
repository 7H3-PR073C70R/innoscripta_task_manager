import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/priority_badge.dart';
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

  group('task card ...', () {
    testWidgets('renders task content and priority badge', (tester) async {
      //! Arrange
      final task = TestEntities.tTaskEntity.copyWith(
        content: 'Test Task Card',
        priority: 1,
      );

      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          TaskCard(task: task, onTap: () {}),
        ),
      );

      //! Assert
      expect(find.text('Test Task Card'), findsOneWidget);
      expect(find.byType(PriorityBadge), findsOneWidget);
    });

    testWidgets('triggers onTap when clicked', (tester) async {
      //! Arrange
      var tapped = false;
      final task = TestEntities.tTaskEntity;

      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          TaskCard(task: task, onTap: () => tapped = true),
        ),
      );

      await tester.tap(find.byType(TaskCard));

      //! Assert
      expect(tapped, isTrue);
    });

    testWidgets('shows labels correctly', (tester) async {
      //! Arrange
      final label = TestEntities.tLabelEntity.copyWith(
        id: 'label1',
        name: 'Work',
      );
      final task = TestEntities.tTaskEntity.copyWith(labels: ['label1']);

      when(() => labelBloc.state).thenReturn(
        LabelState.initial(viewState: ViewState.success, labels: [label]),
      );

      //! Act
      await tester.pumpApp(
        makeTestableWidget(
          TaskCard(task: task, onTap: () {}),
        ),
      );

      //! Assert
      expect(find.text('Work'), findsOneWidget);
    });
  });
}
