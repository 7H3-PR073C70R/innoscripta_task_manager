import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/empty_state_widget.dart';

import '../../../../../helpers/pump_app.dart';


void main() {
  group('empty state widget ...', () {
    testWidgets('renders title and description correctly', (tester) async {
      //! Arrange
      const title = 'Empty Title';
      const description = 'Empty Description';

      //! Act
      await tester.pumpApp(
        const Scaffold(
          body: EmptyStateWidget(
            title: title,
            description: description,
          ),
        ),
      );

      //! Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      //! Arrange
      const icon = Icons.info;

      //! Act
      await tester.pumpApp(
        const Scaffold(
          body: EmptyStateWidget(
            title: 'Title',
            description: 'Description',
            icon: icon,
          ),
        ),
      );
      await tester.pumpAndSettle(); // For TweenAnimationBuilder

      //! Assert
      expect(find.byIcon(icon), findsOneWidget);
    });

    testWidgets('renders action button and triggers callback', (tester) async {
      //! Arrange
      var actionTriggered = false;
      const actionLabel = 'Click Me';

      //! Act
      await tester.pumpApp(
        Scaffold(
          body: EmptyStateWidget(
            title: 'Title',
            description: 'Description',
            actionLabel: actionLabel,
            action: () => actionTriggered = true,
          ),
        ),
      );

      await tester.tap(find.text(actionLabel));
      await tester.pump();

      //! Assert
      expect(actionTriggered, isTrue);
    });
  });
}
