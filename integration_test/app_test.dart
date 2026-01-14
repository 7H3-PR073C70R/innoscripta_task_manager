// ignore_for_file: lines_longer_than_80_chars, document_ignores

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/main_development.dart' as app;
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/kanban_board_page.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_detail_page.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/pages/task_history_page.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_card.dart';
import 'package:innoscripta_task_manager/src/shared/widgets/animated_loader.dart';
import 'package:integration_test/integration_test.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end App Test', () {
    testWidgets(
      'Full user flow: Kanban -> Add Task -> Detail -> Complete -> History',
      (tester) async {
        final originalOnError = FlutterError.onError;
        final uniqueTitle =
            'Test Task ${DateTime.now().millisecondsSinceEpoch}';

        //! 1. Launch App
        debugPrint('Step 1: Launching App');
        await app.main();

        // Restore original onError so test framework can catch exceptions correctly
        FlutterError.onError = originalOnError;

        await tester.pump();

        debugPrint('Step 1.1: Waiting for AnimatedLoader to disappear');
        for (var i = 0; i < 15; i++) {
          if (find.byType(AnimatedLoader).evaluate().isEmpty) break;
          await tester.pump(const Duration(seconds: 1));
        }

        await tester.pumpAndSettle();

        //! Assert - Home Page (Kanban)
        debugPrint('Step 1.2: Checking for KanbanBoardPage');
        expect(find.byType(KanbanBoardPage), findsOneWidget);

        //! 2. Add New Task
        debugPrint('Step 2: Opening Add Task sheet');
        final addTaskButtons = find.text('Add Task');
        expect(addTaskButtons, findsWidgets);
        await tester.tap(addTaskButtons.first);
        await tester.pumpAndSettle();

        debugPrint('Step 2.1: Filling task form');
        final titleField = find.widgetWithText(TextField, 'Task Title');
        final descField = find.widgetWithText(TextField, 'Description');
        final createButton = find.text('Create');

        await tester.enterText(titleField, uniqueTitle);
        await tester.enterText(
          descField,
          'This task was created by an integration test.',
        );

        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        debugPrint('Step 2.2: Tapping Create button');
        await tester.tap(createButton);
        await tester.pumpAndSettle();

        //! Assert - Task on Kanban
        debugPrint('Step 2.3: Verifying task appears on Kanban');
        expect(find.text(uniqueTitle), findsOneWidget);

        //! 3. Navigate to Task Detail
        debugPrint('Step 3: Navigating to Task Detail');
        final taskCard = find.descendant(
          of: find.byType(TaskCard),
          matching: find.text(uniqueTitle),
        );
        await tester.tap(taskCard);
        await tester.pumpAndSettle();

        //! Assert - Detail Page
        debugPrint('Step 3.1: Verifying TaskDetailPage');
        expect(find.byType(TaskDetailPage), findsOneWidget);

        //! 4. Complete Task
        debugPrint('Step 4: Completing the task');
        // The first GestureDetector in _HeaderSection is the completion toggle.
        // at(0) might be it if the AppBar leading is an IconButton (which we already established it is).
        // Let's use a descendants-based finder for more precision.
        final toggle = find
            .descendant(
              of: find.byType(TaskDetailPage),
              matching: find.byType(GestureDetector),
            )
            .first;

        await tester.tap(toggle);
        await tester.pumpAndSettle();
        // App auto-pops back to Kanban on successful completion.
        // Wait for banner to dismisses
        for (var i = 0; i < 15; i++) {
          if (find.byType(CustomSnackBar).evaluate().isEmpty) break;
          await tester.pump(const Duration(seconds: 1));
        }
        //! 5. Navigate to History
        debugPrint('Step 5: Navigating to History');
        expect(find.byType(KanbanBoardPage), findsOneWidget);

        final historyButton = find.byIcon(Icons.history);
        await tester.tap(historyButton);
        await tester.pumpAndSettle();

        //! Assert - History Page
        debugPrint('Step 5.1: Verifying TaskHistoryPage');
        expect(find.byType(TaskHistoryPage), findsOneWidget);
        expect(find.text(uniqueTitle), findsOneWidget);
        debugPrint('Test Finished Successfully');
      },
    );
  });
}
