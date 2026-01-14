// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sample => 'sample';

  @override
  String get appTitle => 'Task Manager';

  @override
  String get toDo => 'To Do';

  @override
  String get inProgress => 'In Progress';

  @override
  String get done => 'Done';

  @override
  String get addTask => 'Add Task';

  @override
  String get createTask => 'Create Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskDescription => 'Description';

  @override
  String get priority => 'Priority';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get dueDate => 'Due Date';

  @override
  String get labels => 'Labels';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get stopTimer => 'Stop Timer';

  @override
  String get resetTimer => 'Reset Timer';

  @override
  String get timeTracked => 'Time Tracked';

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get postComment => 'Post';

  @override
  String get noComments => 'No comments yet';

  @override
  String get taskHistory => 'Task History';

  @override
  String get completedTasks => 'Completed Tasks';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get createYourFirstTask => 'Create your first task to get started';

  @override
  String get noCompletedTasks => 'No completed tasks';

  @override
  String get completedOn => 'Completed on';

  @override
  String get notStarted => 'Not Started';

  @override
  String get inResearch => 'In Research';

  @override
  String get onTrack => 'On Track';

  @override
  String get complete => 'Complete';

  @override
  String get assignees => 'Assignees';

  @override
  String get links => 'Links';

  @override
  String get subtasks => 'Subtasks';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get deleteTaskConfirmation => 'Are you sure you want to delete this task?';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskCreated => 'Task created';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get timerStarted => 'Timer started';

  @override
  String get timerStopped => 'Timer stopped';

  @override
  String get required => 'Required';

  @override
  String get anUnexpectedErrorOccurred => '\'An unexpected error occurred\'';

  @override
  String tasksCount(int count) {
    return '$count tasks';
  }

  @override
  String get create => 'Create';

  @override
  String get labelName => 'Label Name';

  @override
  String get color => 'Color';

  @override
  String get createNewLabel => 'Create New Label';

  @override
  String get unnamed => 'Unnamed';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get selectDate => 'Select Date';

  @override
  String get duration => 'Duration';

  @override
  String get unit => 'Unit';

  @override
  String get minute => 'Minute';

  @override
  String get hour => 'Hour';

  @override
  String get day => 'Day';

  @override
  String get durationUnitRequired => 'Duration unit is required when duration is provided';

  @override
  String get none => 'None';

  @override
  String get actionPerformedSuccessfully => 'Action performed successfully';

  @override
  String get noDescription => 'No description provided';

  @override
  String get taskNotFound => 'Task not found';

  @override
  String get untitledTask => 'Untitled Task';

  @override
  String get assigneesLabel => 'Assignees:';

  @override
  String get noTasks => 'No tasks';

  @override
  String get dragTasksDescription => 'Drag tasks here or create a new one';

  @override
  String get filterByDate => 'Filter by Date';

  @override
  String get completed => 'Completed';

  @override
  String get user => 'User';

  @override
  String get beTheFirstToComment => 'Be the first to comment';

  @override
  String get tasksYouCompleteWillAppearHere => 'Tasks you complete will appear here';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get deleteLabel => 'Delete Label';

  @override
  String get labelNameRequired => 'Label name is required';

  @override
  String get reopenTask => 'Reopen Task';
}
