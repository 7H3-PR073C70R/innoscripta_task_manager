import 'package:bloc_test/bloc_test.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/comment/comment_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/label/label_bloc.dart';
import 'package:innoscripta_task_manager/src/features/task_manager/presentation/blocs/task/task_bloc.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

class MockLabelBloc extends MockBloc<LabelEvent, LabelState>
    implements LabelBloc {}

class MockCommentBloc extends MockBloc<CommentEvent, CommentState>
    implements CommentBloc {}
