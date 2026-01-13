import 'package:innoscripta_task_manager/src/features/task_manager/domain/entity/task/task_entity.dart';

extension TaskEntityExtension on TaskEntity {
  TaskEntity startTimer() {
    return copyWith(
      timer: timer.copyWith(
        startTime: DateTime.now(),
        isRunning: true,
      ),
    );
  }

  TaskEntity stopTimer() {
    if (timer.isRunning == false || timer.startTime == null) {
      return this;
    }

    final now = DateTime.now();
    final sessionSeconds = now.difference(timer.startTime!).inSeconds;
    final newTotal = (timer.totalSecondsCompleted ?? 0) + sessionSeconds;

    return copyWith(
      timer: timer.copyWith(
        isRunning: false,
        stopTime: now,
        totalSecondsCompleted: newTotal,
      ),
    );
  }

  num get currentTotalSeconds {
    if ((timer.isRunning ?? false) && timer.startTime != null) {
      final sessionSeconds = DateTime.now()
          .difference(timer.startTime!)
          .inSeconds;
      return (timer.totalSecondsCompleted ?? 0) + sessionSeconds;
    }
    return timer.totalSecondsCompleted ?? 0;
  }
}
