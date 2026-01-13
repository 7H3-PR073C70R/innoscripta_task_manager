enum TaskStatus {
  todo,
  inProgress,
  done;

  bool get isCompleted => this == done;
  bool get isInProgress => this == inProgress;
  bool get isTodo => this == todo;
}
