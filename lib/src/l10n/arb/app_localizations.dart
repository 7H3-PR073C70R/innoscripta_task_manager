// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// Sample text
  ///
  /// In en, this message translates to:
  /// **'sample'**
  String get sample;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get appTitle;

  /// To Do column title
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get toDo;

  /// In Progress column title
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Done column title
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Add task button
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// Create task dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// Edit task dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// Task title field label
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// Task description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskDescription;

  /// Priority field label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// Low priority
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Medium priority
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// High priority
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Due date field label
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// Labels field
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Start timer button
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// Stop timer button
  ///
  /// In en, this message translates to:
  /// **'Stop Timer'**
  String get stopTimer;

  /// Reset timer button
  ///
  /// In en, this message translates to:
  /// **'Reset Timer'**
  String get resetTimer;

  /// Time tracked label
  ///
  /// In en, this message translates to:
  /// **'Time Tracked'**
  String get timeTracked;

  /// Comments section title
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// Add comment placeholder
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// Post comment button
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postComment;

  /// No comments message
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// Task history page title
  ///
  /// In en, this message translates to:
  /// **'Task History'**
  String get taskHistory;

  /// Completed tasks section
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasks;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// Empty state description
  ///
  /// In en, this message translates to:
  /// **'Create your first task to get started'**
  String get createYourFirstTask;

  /// No completed tasks message
  ///
  /// In en, this message translates to:
  /// **'No completed tasks'**
  String get noCompletedTasks;

  /// Completed date label
  ///
  /// In en, this message translates to:
  /// **'Completed on'**
  String get completedOn;

  /// Not started status
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStarted;

  /// In research status
  ///
  /// In en, this message translates to:
  /// **'In Research'**
  String get inResearch;

  /// On track status
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// Complete status
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Assignees label
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get assignees;

  /// Links label
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get links;

  /// Subtasks label
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get subtasks;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Task details page title
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// Delete task button
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// Delete task confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get deleteTaskConfirmation;

  /// Task deleted message
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// Task created message
  ///
  /// In en, this message translates to:
  /// **'Task created'**
  String get taskCreated;

  /// Task updated message
  ///
  /// In en, this message translates to:
  /// **'Task updated'**
  String get taskUpdated;

  /// Timer started message
  ///
  /// In en, this message translates to:
  /// **'Timer started'**
  String get timerStarted;

  /// Timer stopped message
  ///
  /// In en, this message translates to:
  /// **'Timer stopped'**
  String get timerStopped;

  /// Required field validation
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// 'An unexpected error occurred'
  ///
  /// In en, this message translates to:
  /// **'\'An unexpected error occurred\''**
  String get anUnexpectedErrorOccurred;

  /// Tasks count
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String tasksCount(int count);

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Label Name field
  ///
  /// In en, this message translates to:
  /// **'Label Name'**
  String get labelName;

  /// Color field
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Create New Label button
  ///
  /// In en, this message translates to:
  /// **'Create New Label'**
  String get createNewLabel;

  /// Unnamed label fallback
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// Validation message for title
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// Select Date placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Unit label
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Minute unit
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// Hour unit
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// Day unit
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Duration unit validation error
  ///
  /// In en, this message translates to:
  /// **'Duration unit is required when duration is provided'**
  String get durationUnitRequired;

  /// None option
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Generic success message
  ///
  /// In en, this message translates to:
  /// **'Action performed successfully'**
  String get actionPerformedSuccessfully;

  /// Empty description fallback
  ///
  /// In en, this message translates to:
  /// **'No description provided'**
  String get noDescription;

  /// Task not found message
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get taskNotFound;

  /// Untitled task fallback
  ///
  /// In en, this message translates to:
  /// **'Untitled Task'**
  String get untitledTask;

  /// Assignees section label
  ///
  /// In en, this message translates to:
  /// **'Assignees:'**
  String get assigneesLabel;

  /// No tasks title
  ///
  /// In en, this message translates to:
  /// **'No tasks'**
  String get noTasks;

  /// No tasks description
  ///
  /// In en, this message translates to:
  /// **'Drag tasks here or create a new one'**
  String get dragTasksDescription;

  /// Filter by date tooltip
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// Completed status label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Generic user name
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No comments description
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment'**
  String get beTheFirstToComment;

  /// Empty history description
  ///
  /// In en, this message translates to:
  /// **'Tasks you complete will appear here'**
  String get tasksYouCompleteWillAppearHere;

  /// Edit label dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Label'**
  String get editLabel;

  /// Delete label button tooltip
  ///
  /// In en, this message translates to:
  /// **'Delete Label'**
  String get deleteLabel;

  /// Validation message for label name
  ///
  /// In en, this message translates to:
  /// **'Label name is required'**
  String get labelNameRequired;

  /// Reopen task button text
  ///
  /// In en, this message translates to:
  /// **'Reopen Task'**
  String get reopenTask;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
