import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/core/enums/view_state.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_form_sheet.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/mocks.dart';
import '../../../../../helpers/pump_app.dart';



void main() {
  late MockLabelBloc mockLabelBloc;

  setUp(() {
    mockLabelBloc = MockLabelBloc();
    when(() => mockLabelBloc.state).thenReturn(
      const LabelState.initial(viewState: ViewState.success),
    );
  });

  group('task form sheet ...', () {
    testWidgets('renders create mode by default', (tester) async {
      //! Arrange & Act
      await tester.pumpApp(
        BlocProvider<LabelBloc>.value(
          value: mockLabelBloc,
          child: const Scaffold(
            body: TaskFormSheet(),
          ),
        ),
      );

      //! Assert
      expect(find.text('Create Task'), findsOneWidget);
      expect(find.text('Task Title'), findsOneWidget);
    });
  });
}
