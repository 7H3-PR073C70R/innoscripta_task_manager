import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/priority_badge.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  group('priority badge ...', () {
    testWidgets('renders all priority levels correctly', (tester) async {
      //! Arrange
      const priorities = [1, 2, 4]; // High, Medium, Low/Other

      for (final p in priorities) {
        //! Act
        await tester.pumpApp(
          Scaffold(
            body: PriorityBadge(priority: p),
          ),
        );

        //! Assert
        if (p == 1) {
          expect(find.text('High'), findsOneWidget);
        } else if (p == 2) {
          expect(find.text('Medium'), findsOneWidget);
        } else {
          expect(find.text('Low'), findsOneWidget);
        }
      }
    });

    testWidgets('renders with specific size', (tester) async {
      //! Arrange
      const size = PriorityBadgeSize.large;

      //! Act
      await tester.pumpApp(
        const Scaffold(
          body: PriorityBadge(
            priority: 1,
            size: size,
          ),
        ),
      );

      //! Assert
      expect(find.text('High'), findsOneWidget);
      final textWidget = tester.widget<Text>(find.text('High'));
      expect(textWidget.style?.fontSize, 14.0);
    });
  });
}
