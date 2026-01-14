import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_labels.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';
import '../../../../../helpers/test_entities.dart';

void main() {
  late MockLabelBloc mockLabelBloc;

  setUp(() {
    mockLabelBloc = MockLabelBloc();
  });

  group('task labels ...', () {
    testWidgets('renders nothing when labelIds is null', (tester) async {
      //! Arrange & Act
      await tester.pumpApp(
        const Scaffold(
          body: TaskLabels(),
        ),
      );

      //! Assert
      expect(find.byType(Wrap), findsNothing);
    });

    testWidgets('renders labels correctly when labelIds are present', (
      tester,
    ) async {
      //! Arrange
      const tLabel = TestEntities.tLabelEntity;
      when(() => mockLabelBloc.state).thenReturn(
        const LabelState.initial(
          viewState: ViewState.success,
          labels: [tLabel],
        ),
      );

      //! Act
      await tester.pumpApp(
        BlocProvider<LabelBloc>.value(
          value: mockLabelBloc,
          child: Scaffold(
            body: TaskLabels(labelIds: [tLabel.id!]),
          ),
        ),
      );

      //! Assert
      expect(find.text(tLabel.name!), findsOneWidget);
    });

    testWidgets('renders nothing when labelIds do not match existing labels', (
      tester,
    ) async {
      //! Arrange
      when(() => mockLabelBloc.state).thenReturn(
        const LabelState.initial(
          viewState: ViewState.success,
        ),
      );

      //! Act
      await tester.pumpApp(
        BlocProvider<LabelBloc>.value(
          value: mockLabelBloc,
          child: const Scaffold(
            body: TaskLabels(labelIds: ['non-existent-id']),
          ),
        ),
      );

      //! Assert
      expect(find.byType(Wrap), findsNothing);
    });
  });
}
