import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/widgets/task_timer_widget.dart';

import '../../../../../helpers/pump_app.dart';


void main() {
  group('task timer widget ...', () {
    testWidgets('renders full timer by default', (tester) async {
      //! Arrange
      const timer = TaskTimer(
        totalSecondsCompleted: 3661,
      ); // 01:01:01

      //! Act
      await tester.pumpApp(
        Scaffold(
          body: TaskTimerWidget(
            timer: timer,
            onStart: () {},
            onStop: () {},
          ),
        ),
      );

      //! Assert
      expect(find.text('01:01:01'), findsOneWidget);
      expect(find.text('Start Timer'), findsOneWidget);
    });

    testWidgets('renders compact timer when compact is true', (tester) async {
      //! Arrange
      const timer = TaskTimer(
        totalSecondsCompleted: 3661,
      ); // 1h 1m

      //! Act
      await tester.pumpApp(
        Scaffold(
          body: TaskTimerWidget(
            timer: timer,
            onStart: () {},
            onStop: () {},
            compact: true,
          ),
        ),
      );

      //! Assert
      expect(find.text('1h 1m'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('triggers onStart when play button is pressed', (tester) async {
      //! Arrange
      var startTriggered = false;
      const timer = TaskTimer();

      //! Act
      await tester.pumpApp(
        Scaffold(
          body: TaskTimerWidget(
            timer: timer,
            onStart: () => startTriggered = true,
            onStop: () {},
          ),
        ),
      );

      await tester.tap(find.text('Start Timer'));
      await tester.pump();

      //! Assert
      expect(startTriggered, isTrue);
    });

    testWidgets('triggers onStop when stop button is pressed', (tester) async {
      //! Arrange
      var stopTriggered = false;
      const timer = TaskTimer(
        isRunning: true,
        totalSecondsCompleted: 10,
      );

      //! Act
      await tester.pumpApp(
        Scaffold(
          body: TaskTimerWidget(
            timer: timer,
            onStart: () {},
            onStop: () => stopTriggered = true,
          ),
        ),
      );

      await tester.tap(find.text('Stop Timer'));
      await tester.pump();

      //! Assert
      expect(stopTriggered, isTrue);
    });
  });
}
